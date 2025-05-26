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
  git branch -r |
    awk '{print $1}' |
    grep -E -v -f /dev/fd/0 <(git branch -vv | grep origin) |
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

# Magic is coming 🪄
function ai() {
  # Use OpenAI if can connect
  if ping -c 1 api.openai.com &>/dev/null; then
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

function wai {
  pid="$(ai_pid)"
  if [ -n "$pid" ]; then
    echo "🦙⚙️ Ollama already running with PID $pid"
    return
  fi
  echo "🦙 Waking up local AI: ollama"
  (ollama serve >/dev/null 2>&1 &)
  printf "⏳ Waiting for server.."
  until curl --output /dev/null --silent --head --fail http://localhost:11434; do
    printf '.'
    sleep 1
  done
  printf "done\n"
}

function kai {
  pid="$(ai_pid)"
  if [ -z "$pid" ]; then
    echo "🦙🛑 Ollama not running"
    return
  fi
  kill $pid
  echo "🦙🔪 Killed ollama with PID $pid. With kindness"
}

function ai_pid {
  pgrep ollama
}

function lai() {
  OLLAMA_MODEL="ollama/llama3:instruct"
  echo "⚙️  Using $OLLAMA_MODEL"
  wai
  sgpt --model "$OLLAMA_MODEL" -s "$*"
}
