#!/usr/bin/env zsh

# Don't run auto update if it's been disabled
# ------------------------------------------------------------------------------
[[ -n $PSYRENDUST_DISABLE_AUTO_UPDATE ]] && return

# Last run helper functions
# ------------------------------------------------------------------------------
_psyrendust_au_last_run="$PSYRENDUST_CONFIG_BASE_PATH/auto-update-last-run"

# Load up the last run for auto-update
# ------------------------------------------------------------------------------
if [[ -f "${_psyrendust_au_last_run}" ]]; then
  source "${_psyrendust_au_last_run}"
fi
if [[ -z "${_psyrendust_au_last_epoch}" ]]; then
  _psyrendust-au-set-current-epoch
  source "${_psyrendust_au_last_run}"
fi
_psyrendust_au_last_epoch_diff=$(($(psyrendust currentepoch --get) - ${_psyrendust_au_last_epoch}))

# See if we ran this today already
# ------------------------------------------------------------------------------
if [[ ${_psyrendust_au_last_epoch_diff} -gt 1 ]]; then
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
  psyrendust currentepoch --set
else
  # Run any post-update scripts if they exist
  # ----------------------------------------------------------------------------
  psyrendust source "$ZSH_CUSTOM/tools/run-once.zsh"
fi
unset _psyrendust_au_last_run
