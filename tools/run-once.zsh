#!/usr/bin/env zsh

# Run any post-update scripts if they exist
# ------------------------------------------------------------------------------
for psyrendust_run_once in $(ls "$PSYRENDUST_CONFIG_BASE_PATH/" | grep "^post-update-run-once.*zsh$"); do
  source "$PSYRENDUST_CONFIG_BASE_PATH/$psyrendust_run_once"
  # Sourcing helper script to call all procedure functions in this script
  # ------------------------------------------------------------------------------
  if [[ -s "$ZSH_CUSTOM/tools/psyrendust-procedure-init.zsh" ]]; then
    source "$ZSH_CUSTOM/tools/psyrendust-procedure-init.zsh" "$PSYRENDUST_CONFIG_BASE_PATH/$psyrendust_run_once"
  fi
done
unset psyrendust_run_once
