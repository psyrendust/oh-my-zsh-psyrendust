#!/usr/bin/env zsh

# Don't run auto update if it's been disabled
# ------------------------------------------------------------------------------
[[ -n $PSYRENDUST_DISABLE_AUTO_UPDATE ]] && return


# Load up the last run for auto-update
# ------------------------------------------------------------------------------
psyrendust epoch --set
psyrendust_au_last_epoch_diff=$(( $(psyrendust epoch --get "auto-update") - $(psyrendust epoch --get) ))

# See if we ran this today already
# ------------------------------------------------------------------------------
if [[ ${psyrendust_au_last_epoch_diff} -gt $PSYRENDUST_UPDATE_DAYS ]]; then
  # Load prprompt script
  # ----------------------------------------------------------------------------
  psyrendust source "$ZSH_CUSTOM/plugins/prprompt/prprompt.plugin.zsh"


  # Run auto-update for oh-my-zsh-psyrendust. Updates run asynchronously in the
  # background. The RPROMPT updates every 1 second to display the real-time
  # progress of the auto-update.
  # ----------------------------------------------------------------------------
  psyrendust source "$ZSH_CUSTOM/tools/auto-update.zsh"


  # Update last epoch
  # ----------------------------------------------------------------------------
  psyrendust epoch --set "auto-update"
else
  # Run any post-update scripts if they exist
  # ----------------------------------------------------------------------------
  psyrendust source "$ZSH_CUSTOM/tools/run-once.zsh"
fi
unset psyrendust_au_last_epoch_diff
