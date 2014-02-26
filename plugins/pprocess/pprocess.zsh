#!/usr/bin/env zsh

# Processing state helper functions
# ------------------------------------------------------------------------------
[[ -d $PSYRENDUST_CONFIG_BASE_PATH ]] || PSYRENDUST_CONFIG_BASE_PATH="$HOME/.psyrendust"

# Returns true if pprocess-[name space] file exists
function _pprocess-is-running() {
  if [[ -s "$PSYRENDUST_CONFIG_BASE_PATH/pprocess-${1}" ]]; then
    echo 1
  fi
}

# Sets the processing state to true for a given namespace
function _pprocess-start() {
  echo "$(date)" > "$PSYRENDUST_CONFIG_BASE_PATH/pprocess-${1}"
}

# Sets the processing state to false for a given namespace
function _pprocess-stop() {
  if [[ -s "$PSYRENDUST_CONFIG_BASE_PATH/pprocess-${1}" ]]; then
    rm "$PSYRENDUST_CONFIG_BASE_PATH/pprocess-${1}"
  fi
}

# Usage:
# pprocess -[r|s|x] [name space]
# ------------------------------------------------------------------------------
while getopts ":i:s:x" opt; do
  [[ $opt == "i" ]] && option=1 && break
  [[ $opt == "s" ]] && option=2 && break
  [[ $opt == "x" ]] && option=3 && break
done
shift
[[ $option == 1 ]] && _pprocess-is-running "$1"
[[ $option == 2 ]] && _pprocess-start "$1"
[[ $option == 3 ]] && _pprocess-stop "$1"
