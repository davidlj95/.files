#!/usr/bin/env bash

# Cygwin UTF8
[ "$(uname -o)" = "Cygwin" ] && chcp.com 65001 > /dev/null 2>&1

# Path to the bash it configuration
export BASH_IT="$HOME/.bash_it"

# Lock and Load a custom theme file.
# Leave empty to disable theming.
# location /.bash_it/themes/
export BASH_IT_THEME='powerline'

# (Advanced): Change this to the name of your remote repo if you
# cloned bash-it with a remote other than origin such as `bash-it`.
# export BASH_IT_REMOTE='bash-it'

# Your place for hosting Git repos. I use this for private repos.
export GIT_HOSTING='git@gitlab.com'

# Don't check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.
export IRC_CLIENT='irssi'

# Set this to the command you use for todo.txt-cli
export TODO="t"

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true

# Set Xterm/screen/Tmux title with only a short hostname.
# Uncomment this (or set SHORT_HOSTNAME to something else),
# Will otherwise fall back on $HOSTNAME.
#export SHORT_HOSTNAME=$(hostname -s)

# Set Xterm/screen/Tmux title with only a short username.
# Uncomment this (or set SHORT_USER to something else),
# Will otherwise fall back on $USER.
#export SHORT_USER=${USER:0:8}

# Set Xterm/screen/Tmux title with shortened command and directory.
# Uncomment this to set.
#export SHORT_TERM_LINE=true

# Set vcprompt executable path for scm advance info in prompt (demula theme)
# https://github.com/djl/vcprompt
#export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

# (Advanced): Uncomment this to make Bash-it reload itself automatically
# after enabling or disabling aliases, plugins, and completions.
# export BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1

# Uncomment this to make Bash-it create alias reload.
# export BASH_IT_RELOAD_LEGACY=1

utils_file="$HOME/.shell.utils.sh"
env_anteload_file="$HOME/.shell.env.anteload.sh"
if [ -r "$utils_file" ]; then
    source "$utils_file"
    [ -r "$env_anteload_file" ] && source "$env_anteload_file"
fi
aliases_file="$HOME/.shell.aliases.sh"
[ -r "$aliases_file" ] && source "$aliases_file"

# Load Bash It
source "$BASH_IT"/bash_it.sh

# Env configs after loading framework
env_postload_file="$HOME/.shell.env.postload.sh"
[ -r "$utils_file" ] && [ -r "$env_postload_file" ] && source "$env_postload_file"

# Load completions
## Generic
[ -d "/usr/share/bash-completion/completions" ] && 
	for f in /usr/share/bash-completion/completions/*;
		do . "$f";
	done
[ -d "$HOME/.bash_completion.d" ] && 
	for bcfile in ~/.bash_completion.d/* ; do
		. $bcfile
	done
## NVM
if [ -d "$NVM_HOME" ]; then
	[ -s "$NVM_HOME/bash_completion" ] && \. "$NVM_HOME/bash_completion"  # This loads nvm bash_completion
fi
## Spring
if [ -d "$SPRING_HOME" ]; then
	source "$SPRING_HOME/shell-completion/bash/spring"
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/davidlj/.sdkman"
[[ -s "/home/davidlj/.sdkman/bin/sdkman-init.sh" ]] && source "/home/davidlj/.sdkman/bin/sdkman-init.sh"
