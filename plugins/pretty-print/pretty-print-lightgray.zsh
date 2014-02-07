#!/usr/bin/env zsh

# Output functions
# ----------------------------------------------------------
# Light Gray
function pretty_print() {
  printf '\033[0;37m%s\033[0m\n' "$@"
}
pretty_print $@
