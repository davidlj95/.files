# Shell aliases
#
# Tested with bash & zsh
#

# Git
## Git branch list prunables
## Lists branches that can be pruned, as they don't exist on remote
## Based on https://stackoverflow.com/a/17029936/3263250
function gblp() {
    git branch -r | \
    awk '{print $1}' | \
    egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | \
    awk '{print $1}'
}
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

# Media conversion
function tomp4() {
    while [ $# -gt 0 ]; do
        file_to_convert="$1"
        converted_file="${file_to_convert%.*}.mp4"
        # ffmpeg -i "$file_to_convert" "$converted_file"
        echo ffmpeg -i "$file_to_convert" "$converted_file"
        shift
    done
}

# External IP address
# https://unix.stackexchange.com/a/81699/37512
alias wanip='dig @resolver4.opendns.com myip.opendns.com +short' 
alias wanip4='dig @resolver4.opendns.com myip.opendns.com +short -4'
alias wanip6='dig @resolver1.ipv6-sandbox.opendns.com AAAA myip.opendns.com +short -6'

# Graphite aliases
alias gtbc='gt branch checkout'
alias gtbcr='gt branch create'
alias gtlo='gt log'
alias gtsl='gt log short'
alias gtres='gt repo sync --restack'
alias gtss='gt stack submit'

# Shred
alias srm="shred -un 42"

# Tailscale for macOs
alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"