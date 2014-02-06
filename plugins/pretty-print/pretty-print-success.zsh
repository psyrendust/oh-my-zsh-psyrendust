#!/usr/bin/env zsh

# Output functions
# ----------------------------------------------------------
# Green
function pretty_print_success() {
  printf '\033[0;32m%s\033[0m\n' "$@"
}
pretty_print_success "$@"
