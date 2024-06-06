# Configures the shell environment. Launched after shell framework is loaded.
#
# Aimed to be shell independent
#
# Tested by dogfooding in zsh (though this was started using bash)

# Utils
command_without_completions_exists() {
  command_exists "$1" && ! completions_exist_for "$1"
}

# Completions
# Tabtab
get_tabtab_scripts() {
  shell_name="$(basename "$SHELL")"
  # Can be at "~/.config/tabtab/__tabtab.{shell_ext}" for v3
  # https://github.com/mklabs/tabtab/blob/v3.0.3/lib/installer.js#L218
  # In that version, extension == shell, so we're good here. Maybe PowerShell not supported though
  v3_tabtab_script="$HOME/.config/tabtab/__tabtab.${shell_name}"
  if [ -f "$v3_tabtab_script" ]; then
    echo "$v3_tabtab_script"
  fi
  # For mklabs/tabtab v1/v2, seems completions were installed directly to the {shell}rc file
  # Except for fish shell if fish completions dir exists
  # https://github.com/mklabs/tabtab/blob/v1.4.3/lib/installer.js#L65-L69
  # https://github.com/mklabs/tabtab/blob/v2.2.2/lib/installer.js#L65-L69
}
for tabtab_script in $(get_tabtab_scripts); do
  # shellcheck disable=SC1090
  source "$tabtab_script"
done

# Compdef
# `compdef` needed to load completions. This may fail if loaded before initialized
# For instance, before sourcing OhMyZsh script in `.zshrc`
if command_exists compdef; then
  # Angular
  # Seems that there are some built-in completions, but very "incomplete" :P. So add official anyway
  if command_exists ng; then
    # shellcheck disable=SC1090
    source <(ng completion script)
  fi

  # Graphite
  if command_without_completions_exists gt; then
    # shellcheck disable=SC1090
    source <(gt completion)
  fi

  # Pnpm
  # For v9.x, snippet via "pnpm completions zsh". Slightly modified
  if command_without_completions_exists pnpm; then
    _pnpm_completion() {
      local reply
      local si=$IFS

      # In pnpm we trust
      # shellcheck disable=SC2207
      IFS=$'\n' reply=($(COMP_CWORD="$((CURRENT - 1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" SHELL=zsh pnpm completion-server -- "${words[@]}"))
      IFS=$si

      # shellcheck disable=SC2128
      if [ "$reply" = "__tabtab_complete_files__" ]; then
        _files
      else
        _describe 'values' reply
      fi
    }
    compdef _pnpm_completion pnpm
  fi
fi

## X. Overrides specific to this machine
source_if_file_exists_and_is_readable "$HOME/.shell.env.postload.overrides.sh"
