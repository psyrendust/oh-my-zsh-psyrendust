#!/usr/bin/env zsh

# Output functions
# ----------------------------------------------------------
# Light Cyan
function pretty_print() {
  printf '\033[1;36m%s\033[0m\n' "$@"
}
pretty_print $@
