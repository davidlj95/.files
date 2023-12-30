#!/usr/bin/env bash

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# USAGE:
#
#    curl -O https://raw.githubusercontent.com/rynkowsg/scripts/master/macos/scan-qrcode.sh
#    ./scan-qrcode.sh
#
#  or
#
#    curl https://raw.githubusercontent.com/rynkowsg/scripts/master/macos/scan-qrcode.sh | bash
#
#
# EXAMPLES:
#
#  Just print the QR code
#
#    ./scan-qrcode.sh
#
#  Copy QR code to clipboard
#
#    ./scan-qrcode.sh | pbcopy
#
#  Import paper secret key from QR code:
#
#    ./scan-qrcode.sh | paperkey --pubring public-key.asc | gpg --import
#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#### ERROR CODES

NO_COMMAND_FOUND_ERROR=1
QR_CODE_NOT_DETECTED_ERROR=2

#### UTILS: CLEANUPS ####

declare -a on_exit_items

function on_exit() {
  for i in "${on_exit_items[@]}"; do
    eval $i
  done
}

function add_on_exit() {
  local n=${#on_exit_items[*]}
  on_exit_items[$n]="$*"
  # set the trap only the first time
  if [[ $n -eq 0 ]]; then
    trap on_exit EXIT
  fi
}

#### UTILS: ERRORS ####

RED=$(printf '\033[31m')
RESET=$(printf '\033[m')

function error_exit() {
  local msg="${1:-"Unknown Error"}"
  local code="${2:-"2"}"
  printf "${RED}%s${RESET}\n" "${msg}" >&2
  exit "$code"
}

### UTILS: DEPS CHECK ####

function assert_command_exists() {
  local command=$1
  if ! command -v "$command" &>/dev/null; then
    error_exit "'$command' doesn't exist. Please install '$command'." $NO_COMMAND_FOUND_ERROR
  else
    echo "Checking '$command'... FOUND" >&2
  fi
}

#### QR CODE SCANNING ####

function scan_qr() {
  local tries=10
  local snapshot="$(mktemp)"
  add_on_exit rm -f "${snapshot}"
  local result=""
  for number in $(seq 1 $tries); do
    echo "QR code snapshot attempt #${number}" >&2
    imagesnap -q -w 1 "${snapshot}"
    result="$(zbarimg -1 --raw -q -Sbinary "${snapshot}")"
    [[ -n $result ]] && break
    [[ $number -eq $tries ]] && error_exit "QR code not detected." $QR_CODE_NOT_DETECTED_ERROR
    sleep 1
  done
  echo "${result}"
}

function main() {
  assert_command_exists "imagesnap"
  assert_command_exists "zbarimg"
  scan_qr
}

main
