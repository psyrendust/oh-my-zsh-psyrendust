#!/usr/bin/env zsh

# Output functions
# ----------------------------------------------------------
# Blue
function pretty_print() {
  printf '\033[0;34m%s\033[0m\n' "$@"
}
pretty_print $@
