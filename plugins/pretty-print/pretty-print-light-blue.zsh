#!/usr/bin/env zsh

# Output functions
# ----------------------------------------------------------
# Light Blue
function pretty_print() {
  printf '\033[1;34m%s\033[0m\n' "$@"
}
pretty_print $@
