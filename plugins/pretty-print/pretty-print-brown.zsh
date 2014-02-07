#!/usr/bin/env zsh

# Output functions
# ----------------------------------------------------------
# Brown
function pretty_print() {
  printf '\033[0;33m%s\033[0m\n' "$@"
}
pretty_print $@
