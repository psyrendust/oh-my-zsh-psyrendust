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


# Settings for zsh-syntax-highlighting plugin
if [[ -n $SYSTEM_IS_MAC ]]; then
  # Set highlighters.
  zstyle -a ':psyrendust:module:syntax-highlighting' highlighters 'ZSH_HIGHLIGHT_HIGHLIGHTERS'
  if (( ${#ZSH_HIGHLIGHT_HIGHLIGHTERS[@]} == 0 )); then
    ZSH_HIGHLIGHT_HIGHLIGHTERS=(main)
  fi

  # Set highlighting styles.
  typeset -A syntax_highlighting_styles
  zstyle -a ':prezto:module:syntax-highlighting' styles 'syntax_highlighting_styles'
  for syntax_highlighting_style in "${(k)syntax_highlighting_styles[@]}"; do
    ZSH_HIGHLIGHT_STYLES[$syntax_highlighting_style]="$syntax_highlighting_styles[$syntax_highlighting_style]"
  done
  unset syntax_highlighting_style{s,}
fi


# ------------------------------------------------------------------------------
# Apply psyrendust's own completion.
# ------------------------------------------------------------------------------
psy apply
