#!/usr/bin/env zsh

# Output functions
# ----------------------------------------------------------
# Green
function print_success() {
  printf '\033[0;32m%s\033[0m\n' "$@"
}
# Red
function print_error() {
  printf '\033[0;31m%s\033[0m\n' "$@"
}
# Yellow
function print_question() {
  printf '\033[0;33m%s\033[0m\n' "$@"
}
# Purple
function print_info() {
  printf '\033[0;35m%s\033[0m\n' "$@"
}
