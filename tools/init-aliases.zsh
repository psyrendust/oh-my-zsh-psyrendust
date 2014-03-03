#!/usr/bin/env zsh

# ------------------------------------------------------------------------------
# Helper aliases
# ------------------------------------------------------------------------------
alias zshconfig="sbl ~/.zshrc"
alias ohmyzsh="sbl ~/.oh-my-zsh"
alias sourceohmyzsh="source ~/.zshrc"
alias chownusrlocal="find /usr/local -maxdepth 2 -user root -exec sudo chown -R $(echo $USER):staff {} + -print"
alias npmlist="npm -g ls --depth=0 2>NUL"
alias psyversion="pppurple -i \"Running oh-my-zsh-psyrendust version \" && pplightpurple \"$(cat $ZSH_CUSTOM/.version)\""



# ------------------------------------------------------------------------------
# Update all global npm packages except for npm, because updating npm using npm
# always breaks. Running npm -g update will result in having to reinstall node.
# This little script will update all global npm packages except for npm.
# ------------------------------------------------------------------------------
alias npmupdate="npm -g ls --depth=0 2>NUL | awk -F'@' '{print $1}' | awk '{print $2}' | awk  '!/npm/'> $PSYRENDUST_CONFIG_BASE_PATH/npm-g-ls && xargs -0 -n 1 npm -g update < <(tr \\n \\0 <$PSYRENDUST_CONFIG_BASE_PATH/npm-g-ls) && rm $PSYRENDUST_CONFIG_BASE_PATH/npm-g-ls"



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
