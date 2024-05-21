# Shell aliases
#
# Tested with zsh

# Git
alias gblp=git-branch-list-prunables

# Git branch prune
# Remove local branches that are tracked remotely
# but remote branch doesn't exit anymore
alias gbp="gblp | xargs git branch -D"

# Push and copy commit id of pushed thing
alias gli="git log --format='%H' -n 1 | pbcopy"

# Uncommit last commit, so you can commit again
alias gunc="git reset --soft HEAD~"

# # Git flow
alias gfli="git flow init"
alias gflfs="git flow feature start"
alias gflff="git flow feature finish"
alias gflfp="git flow feature publish"

# Clipboard
alias clipcopy="xsel --clipboard"

# FASD
alias v='f -e vim' # quick opening files with vim
alias m='f -e mplayer' # quick opening files with mplayer
alias o='a -e xdg-open' # quick opening files with xdg-open

# LSD if available
if command -v lsd > /dev/null 2>&1; then
	alias ls=lsd
fi

# Music helpers
alias c2s="playerctl -p spotify play && playerctl -p clementine stop"
alias s2c="playerctl -p clementine play && playerctl -p spotify stop"
alias mplay="playerctl play"
alias mstart="mplay"
alias mstop="playerctl stop"
alias mvol="playerctl volume"
alias mvolume="mvol"

# OS-Specific aliases
if [ "$(uname)" = "Cygwin" ] && [ -d "$NIRCMD_HOME" ]; then
	alias sudo='$NIRCMD_COMMAND elevate cmd.exe /K '
fi

# PostgreSQL
alias psql="psql --host localhost -U postgres"
alias createdb="createdb --host localhost -U postgres"

# External IP address
# https://unix.stackexchange.com/a/81699/37512
alias wanip='dig @resolver4.opendns.com myip.opendns.com +short'
alias wanip4='dig @resolver4.opendns.com myip.opendns.com +short -4'
alias wanip6='dig @resolver1.ipv6-sandbox.opendns.com AAAA myip.opendns.com +short -6'

# Graphite aliases
alias gtc='gt checkout'
alias gtcr='gt create'
alias gtg='gt get'
alias gtlo='gt log'
alias gtsl='gt log short'
alias gtsy='gt sync'
alias gtsu='gt submit'

# Shred
alias srm="shred -un 42"

# Tailscale for macOs
alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

# Corepack force
alias npm="corepack npm"

# GitHub aliases
alias gh-cache-clean="gh cache list --json id --jq '.[].id' | tee | xargs -L 1 gh cache delete"

# Magic is coming 🪄
function ai() {
    # Use OpenAI if can connect
    if ping -c 1 api.openai.com &> /dev/null; then
        echo "🛜  OpenAI connectivity success"
        oai "$*"
        return
    fi
    # Use local ollama if offline
    echo "📵 No connectivity to OpenAI"
    lai "$*"
}

function oai() {
    OPENAI_MODEL="gpt-4o-2024-05-13"
    echo "⚙️  Using $OPENAI_MODEL"
    sgpt --model "$OPENAI_MODEL" -s "$*"
}

function lai() {
    OLLAMA_MODEL="ollama/llama3:instruct"
    echo "⚙️  Using $OLLAMA_MODEL"
    ollama_pid="$(pgrep ollama)"
    if [ -z "$ollama_pid" ]; then
        echo "🦙 Waking up (o)llama first"
        (ollama serve >/dev/null 2>&1 &)
        printf "⏳ Waiting for server.."
        until curl --output /dev/null --silent --head --fail http://localhost:11434; do
            printf '.'
            sleep 1
        done
        printf "\n"
    fi
    sgpt --model "$OLLAMA_MODEL" -s "$*"
}
