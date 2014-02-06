#!/usr/bin/env zsh

# Output functions
# ----------------------------------------------------------
# Green
# Purple
function pretty_print_info() {
  printf '\033[0;35m%s\033[0m\n' "$@"
}
pretty_print_info "$@"
