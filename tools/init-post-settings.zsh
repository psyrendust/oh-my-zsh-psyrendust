#!/usr/bin/env zsh

# Run a few things after Oh My Zsh has finished initializing
# ------------------------------------------------------------------------------
if [[ -n $SYSTEM_IS_CYGWIN ]]; then
  # Install gem helper aliases
  # ----------------------------------------------------------------------------
  if [[ -n "$(which ruby 2>/dev/null)" ]]; then
    _psyrendust-gem-alias "install"
  fi



  # If we are using Cygwin and ZSH_THEME is Pure, then replace the prompt
  # character to something that works in Windows
  # ----------------------------------------------------------------------------
  if [[ $ZSH_THEME == "pure" ]]; then
    PROMPT=$(echo $PROMPT | tr "❯" "›")
  fi
fi
