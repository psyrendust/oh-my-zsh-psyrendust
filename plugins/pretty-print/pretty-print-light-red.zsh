#!/usr/bin/env zsh

# Output functions
# ----------------------------------------------------------
# Light Red
function pretty_print() {
  printf '\033[1;31m%s\033[0m\n' "$@"
}
pretty_print $@
