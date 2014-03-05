#!/usr/bin/env zsh

# Create psyrendust log symlinks
# ----------------------------------------------------------
ln -sf "$HOME/.oh-my-zsh-psyrendust/plugins/plog/plog-log.zsh" "/usr/local/bin/plog"

# Install man page
# --------------------------------------------------------
for mp in ${manpath}; do
  if [[ -d "$mp" ]]; then
    ln -sf "$HOME/.oh-my-zsh-psyrendust/plugins/plog/plog.1" "$(echo ${mp})/man1/plog.1"
    break
  fi
done
