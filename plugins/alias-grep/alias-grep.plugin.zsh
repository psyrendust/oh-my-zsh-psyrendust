# Filter your zsh aliases using regex.

# List all installed aliases or filter using regex
function _alias_grep() {
  local pattern="${1:-}"
  if [[ $pattern == '' ]]; then
    alias
  else
    alias | grep -e $pattern
  fi
}

# List all installed aliases or filter using regex at the
# start of the string
function _alias_grep_starts_with() {
  local pattern="${1:-}"
  if [[ $pattern == '' ]]; then
    alias
  else
    alias | grep -e "^$pattern"
  fi
}

alias ag="_alias_grep"
alias agb="_alias_grep_starts_with"