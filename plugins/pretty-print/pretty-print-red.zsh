#!/usr/bin/env zsh

# Output functions
# ----------------------------------------------------------
# Red
function pretty_print() {
  printf '\033[0;31m%s\033[0m\n' "$@"
}
pretty_print $@
