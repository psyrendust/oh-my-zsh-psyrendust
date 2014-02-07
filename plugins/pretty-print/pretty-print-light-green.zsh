#!/usr/bin/env zsh

# Output functions
# ----------------------------------------------------------
# Light Green
function pretty_print() {
  printf '\033[1;32m%s\033[0m\n' "$@"
}
pretty_print $@
