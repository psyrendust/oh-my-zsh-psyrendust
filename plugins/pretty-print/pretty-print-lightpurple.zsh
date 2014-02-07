#!/usr/bin/env zsh

# Output functions
# ----------------------------------------------------------
# Light Purple
function pretty_print() {
  printf '\033[1;35m%s\033[0m\n' "$@"
}
pretty_print $@
