# Configures the shell environment. Launched after shell framework is loaded.
#
# Aimed to be shell independent
#
# Tested in zsh (though this was started using bash)

# Graphite
# `compdef` needed to load completions. This may fail if loaded before initialized
# For instance, before sourcing OhMyZsh script in `.zshrc`
if command_exists gt && ! completions_exist_for gt && command_exists compdef; then
  # shellcheck disable=SC1090
  source <(gt completion)
fi

## X. Overrides specific to this machine
source_if_file_exists_and_is_readable "$HOME/.shell.env.postload.overrides.sh"