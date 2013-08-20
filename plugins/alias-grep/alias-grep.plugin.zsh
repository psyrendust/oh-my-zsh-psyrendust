# Filter your zsh aliases using regex.

# List all installed aliases or filter using regex
function ag() {
  local pattern="${1:-}"
  if [[ $pattern == '' ]]; then
    alias
  else
    alias | grep -e $pattern
  fi
}

# List all installed aliases or filter using regex at the
# start of the string
function agb() {
  local pattern="${1:-}"
  if [[ $pattern == '' ]]; then
    alias
  else
    alias | grep -e "^$pattern"
  fi
}