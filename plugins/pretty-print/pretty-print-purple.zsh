#!/usr/bin/env zsh

# Output functions
# ----------------------------------------------------------
# Purple
function pretty_print() {
  printf '\033[0;35m%s\033[0m\n' "$@"
}
pretty_print $@
