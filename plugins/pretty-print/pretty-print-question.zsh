#!/usr/bin/env zsh

# Output functions
# ----------------------------------------------------------
# Yellow
function pretty_print_question() {
  printf '\033[0;33m%s\033[0m\n' "$@"
}
pretty_print_question "$@"
