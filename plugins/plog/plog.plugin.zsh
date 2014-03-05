#!/usr/bin/env zsh

# Create psyrendust log symlinks
# ----------------------------------------------------------
if [[ ! -d "/usr/local/bin" ]]; then
  mkdir -p "/usr/local/bin"
fi
ln -sf "$HOME/.oh-my-zsh-psyrendust/plugins/plog/plog-log.zsh" "/usr/local/bin/plog"

# Install man page
# --------------------------------------------------------
local man_path=$(man -w git)
man_path=${man_path%/*}
if [[ -n "$man_path" ]] && [[ -d "$man_path" ]]; then
  ln -sf "$HOME/.oh-my-zsh-psyrendust/plugins/plog/plog.1" "$man_path/plog.1"
fi
unset man_path
