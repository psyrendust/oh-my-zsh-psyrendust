#!/usr/bin/env zsh

if [[ -n $SYSTEM_IS_CYGWIN ]]; then
  ln -sf "$ZSH_CUSTOM/plugins/kdiff3/kdiff3.zsh" "/usr/local/bin/kdiff3"
fi
