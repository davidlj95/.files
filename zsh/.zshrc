# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# In case using IntelliJ IDE, use agnoster, seems something weird with p10k
ZSH_CUSTOM="$ZSH/custom"
if [ -d "$ZSH_CUSTOM/themes/powerlevel10k" ] && 
    [ -z "$INTELLIJ_ENVIRONMENT_READER"  ]; then
    ZSH_THEME="powerlevel10k/powerlevel10k"
else
    ZSH_THEME="agnoster"
fi

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Plugins configuration
# # Bg notify
bgnotify_threshold=4  ## set your own notification threshold

function bgnotify_formatted {
  ## $1=exit_status, $2=command, $3=elapsed_time
  [ $1 -eq 0 ] && icon="✅" || icon="❌"
  bgnotify "$icon Task finished ⏱️  ${3}s" "$2";
}

# # Magic enter
MAGIC_ENTER_GIT_COMMAND="git status -u"
MAGIC_ENTER_OTHER_COMMAND="ls -lh ."

# # Tmux on start
export ZSH_TMUX_AUTOCONNECT=false

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    alias-finder
    archlinux
    aws
    bgnotify
    bundler
    common-aliases
    colored-man-pages
    colorize
    copypath
    copyfile
    docker
    docker-compose
    dotenv
    emoji
    git
    git-extras
    git-flow-avh
    github
    gitignore
    kubectl
    kube-ps1
    magic-enter
    man
    ng
    npm
    rails
    rsync
    ruby
    rvm
    sdk
    systemadmin
    systemd
    terraform
    tmux
    vi-mode
)

source $ZSH/oh-my-zsh.sh


# User configuration

# Load shell environment
if [ -r "$HOME/.shell.env" ]; then
    source "$HOME/.shell.env"
fi

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Load dotfiles aliases
if [ -r "$HOME/.shell.aliases.sh" ]; then
    source "$HOME/.shell.aliases.sh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Add autosuggestions
# OS detection
is_mac_os() {
	[ "$(uname)" = "Darwin" ]
}
ZSH_AS_HOME="/usr/share/zsh/plugins/zsh-autosuggestions"
is_mac_os && ZSH_AS_HOME="/usr/local/share/zsh-autosuggestions"
if [ -d "$ZSH_AS_HOME" ]; then
    source "$ZSH_AS_HOME/zsh-autosuggestions.zsh"
fi

# Add syntax highlight
ZSH_SHL_HOME="/usr/share/zsh/plugins/zsh-syntax-highlighting"
is_mac_os && ZSH_SHL_HOME="/usr/local/share/zsh-syntax-highlighting"
if [ -d "$ZSH_SHL_HOME" ]; then
    source "$ZSH_SHL_HOME/zsh-syntax-highlighting.zsh"
fi

# Load Angular CLI autocompletion.
if command_exists ng && ng completion script > /dev/null 2>&1; then
    source <(ng completion script)
fi

source /Users/davidlj95/.docker/init-zsh.sh || true # Added by Docker Desktop
