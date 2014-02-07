#!/usr/bin/env zsh

# Output functions
# ----------------------------------------------------------
# White
function pretty_print() {
  printf '\033[1;37m%s\033[0m\n' "$@"
}
pretty_print $@
