# Filter your zsh aliases using regex.

# List all installed aliases or filter using regex
function _alias-grep() {
  local pattern="${1:-}"
  if [[ $pattern == '' ]]; then
    alias
  else
    alias | grep -e $pattern
  fi
}

# List all installed aliases or filter using regex at the
# start of the string
function _alias-grep-starts-with() {
  local pattern="${1:-}"
  if [[ $pattern == '' ]]; then
    alias
  else
    alias | grep -e "^$pattern"
  fi
}

alias ag="_alias-grep"
alias agb="_alias-grep-starts-with"
