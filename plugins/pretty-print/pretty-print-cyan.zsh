#!/usr/bin/env zsh

# Output functions
# ----------------------------------------------------------
# Cyan
function pretty_print() {
  printf '\033[0;36m%s\033[0m\n' "$@"
}
pretty_print $@
