# Configures the shell environment. Launched after shell framework is loaded.
#
# Aimed to be shell independent
#
# Tested in zsh (though this was started using bash)

# Utils
command_without_completions_exist() {
  command_exists "$1" && ! completions_exist_for "$1"
}

# Completions
# `compdef` needed to load completions. This may fail if loaded before initialized
# For instance, before sourcing OhMyZsh script in `.zshrc`
if command_exists compdef; then
  # Angular
  # Seems that there are some built-in completions, but very "incomplete" :P. So add official anyway
  if command_without_completions_exists ng; then
    # shellcheck disable=SC1090
    source <(ng completion script)
  fi

  # Graphite
  if command_without_completions_exist gt; then
    # shellcheck disable=SC1090
    source <(gt completion)
  fi
fi

## X. Overrides specific to this machine
source_if_file_exists_and_is_readable "$HOME/.shell.env.postload.overrides.sh"