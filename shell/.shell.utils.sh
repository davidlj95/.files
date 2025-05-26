# Some utils for shell config files and for shell life overall too

## For setting up shell
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

prepend_to_path() {
  export PATH="$1:$PATH"
}

prepend_to_path_if_exists_and_is_readable() {
  directory_exists_and_is_readable "$1" && prepend_to_path "$1"
}

directory_exists_and_is_readable() {
  [ -d "$1" ] && [ -r "$1" ]
}

completions_exist_for() {
  # https://stackoverflow.com/a/40014760
  # https://stackoverflow.com/a/35923387
  # shellcheck disable=SC2154
  (echo "$_comps" | grep -q "_$1") || (command_exists complete && complete -p | grep -q "$1")
}

source_if_file_exists_and_is_readable() {
  # shellcheck disable=SC1090
  [ -r "$1" ] && source "$1"
}

is_mac_os() {
  [ "$(uname)" = "Darwin" ]
}

is_linux_os() {
  [ "$(uname)" = "Linux" ]
}

## Others
datauri2image() {
  sed 's/data:image\/png;base64,//g' | base64 -d
}

## Git branch list prunables
## Lists branches that can be pruned, as they don't exist on remote
## Based on https://stackoverflow.com/a/17029936/3263250
function git-branch-list-prunables() {
    git branch -r | \
    awk '{print $1}' | \
    grep -E -v -f /dev/fd/0 <(git branch -vv | grep origin) | \
    awk '{print $1}'
}

function toMp4() {
    while [ $# -gt 0 ]; do
        file_to_convert="$1"
        converted_file="${file_to_convert%.*}.mp4"
        ffmpeg -i "$file_to_convert" "$converted_file"
        shift
    done
}
