# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Would you like to use another custom folder than $ZSH/custom?
# Moved here so we can load custom theme below
ZSH_CUSTOM="$HOME/.zsh-custom"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
if [ -d "$ZSH_CUSTOM/themes/powerlevel10k" ] &&
    # When IntelliJ IDE internally opens a terminal to read shell environment, seems something weird with p10k
    # https://youtrack.jetbrains.com/articles/IDEA-A-19/Shell-Environment-Loading
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
    brew
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
    gh
    git
    git-extras
    git-flow-avh
    github
    gitignore
    kubectl
    kube-ps1
    magic-enter
    man
    #ng (super incomplete ones, better use official ones!)
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
    yarn
    # https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md#oh-my-zsh
    zsh-autosuggestions
    # https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md#oh-my-zsh
    zsh-syntax-highlighting
    mvn
)

utils_file="$HOME/.shell.utils.sh"
env_anteload_file="$HOME/.shell.env.anteload.sh"
if [ -r "$utils_file" ]; then
    source "$utils_file"
    [ -r "$env_anteload_file" ] && source "$env_anteload_file"
fi

# Extra completions
# Why this needs to be here: https://github.com/zsh-users/zsh-completions/issues/603#issuecomment-967116106
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

source $ZSH/oh-my-zsh.sh

# User configuration

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
# <-- Defined at env postload -->


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# Env configs after loading framework
env_postload_file="$HOME/.shell.env.postload.sh"
[ -r "$utils_file" ] && [ -r "$env_postload_file" ] && source "$env_postload_file"
