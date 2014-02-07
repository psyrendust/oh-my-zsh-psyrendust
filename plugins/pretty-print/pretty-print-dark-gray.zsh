#!/usr/bin/env zsh

# Output functions
# ----------------------------------------------------------
# Dark Gray
function pretty_print() {
  printf '\033[1;30m%s\033[0m\n' "$@"
}
pretty_print $@
