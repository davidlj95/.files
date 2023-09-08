# TODO: Move to .shell.env
# Added by Toolbox App
export PATH="$PATH:/Users/davidlj95/Library/Application Support/JetBrains/Toolbox/scripts"

#compdef gt
###-begin-gt-completions-###
#
# yargs command completion script
#
# Installation: /opt/homebrew/bin/gt completion >> ~/.zshrc
#    or /opt/homebrew/bin/gt completion >> ~/.zprofile on OSX.
#
_gt_yargs_completions()
{
  local reply
  local si=$IFS
  IFS=$'
' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" /opt/homebrew/bin/gt --get-yargs-completions "${words[@]}"))
  IFS=$si
  _describe 'values' reply
}
autoload -Uz compinit
compinit -i
compdef _gt_yargs_completions gt
###-end-gt-completions-###

