// Globals
var TERMINAL_NOTIFIER = "terminal-notifier";
var EXCLUDED_TITLES = ["Flaix FM"];
var lastNotifiedTitle = null;

// Loads the plugin, called at end of file
function load() {
  var terminalNotifierExists = mp.command_native({
    name: "subprocess",
    args: [TERMINAL_NOTIFIER, "-version"],
    capture_stdout: true,
    playback_only: false,
  });

  if (terminalNotifierExists.status !== 0) {
    mp.msg.error(TERMINAL_NOTIFIER + " can't be found");
    mp.msg.info("Install it and try again");
    mp.msg.info(
      "To install with brew: 'brew install " + TERMINAL_NOTIFIER + "'"
    );
    return;
  }
  mp.msg.debug("Using " + terminalNotifierExists.stdout.trim());
  mp.register_event("file-loaded", notifyCurrentTrack);
  mp.observe_property("metadata", null, notifyCurrentTrack);
  mp.msg.info("Notify plugin loaded");
}

// Callback when metadata is updated
function notifyCurrentTrack() {
  var metadata = getMetadata();
  if (!metadata) {
    mp.msg.trace("No metadata. Skipping");
    return;
  }

  var title = getTitle(metadata);
  if (!title) {
    mp.msg.trace("No title in metadata. Skipping");
    return;
  }

  mp.msg.trace("Title update received: " + title);

  // Exclude if needed
  if (isExcluded(title)) {
    mp.msg.trace("Title excluded from updates. Skipping");
    return;
  }

  // Avoid duplicate notifications
  if (alreadyNotified(title)) {
    mp.msg.trace("Title already notified. Skipping");
    return;
  }

  notify(title);
}

function getMetadata() {
  return mp.get_property_native("metadata");
}

function getTitle(metadata) {
  return metadata["title"] || metadata["TITLE"] || metadata["icy-title"];
}

function isExcluded(title) {
  var titleExcludedDueToRuleIndex;
  for (var i = 0; i < EXCLUDED_TITLES.length; i++) {
    if (EXCLUDED_TITLES[i].indexOf(title) !== -1) {
      titleExcludedDueToRuleIndex = i;
      break;
    }
  }
  var excluded = titleExcludedDueToRuleIndex !== undefined;
  if (excluded) {
    mp.msg.debug(
      "Exclude rule matches. Rule #" +
        (titleExcludedDueToRuleIndex + 1) +
        " (contains '" +
        EXCLUDED_TITLES[titleExcludedDueToRuleIndex] +
        "'). Skipping"
    );
  }
  return excluded;
}

function alreadyNotified(title) {
  return lastNotifiedTitle === title;
}

function notify(title) {
  mp.msg.trace("Notifying new title: " + title);
  lastNotifiedTitle = title;
  mp.command_native_async([
    "run",
    TERMINAL_NOTIFIER,
    "-title",
    "Flaix FM",
    "-subtitle",
    "Now playing",
    "-message",
    title,
    "-contentImage",
    "/Users/davidlj95/Documents/flaixfm.png",
    "-open",
    "https://open.spotify.com/search/" + title,
  ]);
}

load();
