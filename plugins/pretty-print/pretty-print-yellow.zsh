#!/usr/bin/env zsh

# Output functions
# ----------------------------------------------------------
# Yellow
function pretty_print() {
  printf '\033[1;33m%s\033[0m\n' "$@"
}
pretty_print $@
