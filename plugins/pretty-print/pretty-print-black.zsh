#!/usr/bin/env zsh

# Output functions
# ----------------------------------------------------------
# Black
function pretty_print() {
  printf '\033[0;30m%s\033[0m\n' "$@"
}
pretty_print $@
