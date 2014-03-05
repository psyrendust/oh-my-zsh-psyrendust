#!/usr/bin/env zsh

# ------------------------------------------------------------------------------
# Helper aliases
# ------------------------------------------------------------------------------
alias zshconfig="sbl ~/.zshrc"
alias ohmyzsh="sbl ~/.oh-my-zsh"
alias sourceohmyzsh="source ~/.zshrc"
alias chownusrlocal="find /usr/local -maxdepth 2 -user root -exec sudo chown -R $(echo $USER):staff {} + -print"
alias npmlist="npm -g ls --depth=0 2>NUL"



# ------------------------------------------------------------------------------
# Add some OS related configuration
# ------------------------------------------------------------------------------
if [[ -n $SYSTEM_IS_MAC ]]; then
  # Add some OS X related configuration
  alias chownapps="find /Applications -maxdepth 1 -user root -exec sudo chown -R $(echo $USER):staff {} + -print"
  alias manp="man-preview"
  alias ql="quick-look"
elif [[ -n $SYSTEM_IS_CYGWIN ]]; then
  # Add some cygwin related configuration
  alias cygpackages="cygcheck -c -d | sed -e \"1,2d\" -e 's/ .*$//'"
  alias open="cygstart"
fi
