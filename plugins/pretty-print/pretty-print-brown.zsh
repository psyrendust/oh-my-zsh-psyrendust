#!/usr/bin/env zsh

# Output functions
# ----------------------------------------------------------
# Brown
#
# Accepts an optional flag -i to inline output
function pretty_print() {
  while getopts ":i" opt; do
    [[ $opt == "i" ]] && has_option=1
  done
  if [[ -n $has_option ]]; then
    shift && printf '\033[0;33m%s\033[0m' "$@"
  else
    printf '\033[0;33m%s\033[0m\n' "$@"
  fi
}
pretty_print $@
