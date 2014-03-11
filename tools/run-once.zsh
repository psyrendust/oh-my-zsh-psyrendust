#!/usr/bin/env zsh

# Run any post-update scripts if they exist
# ------------------------------------------------------------------------------
# "$PSY_RUN_ONCE/post-update-${psyrendust_au_name_space}.zsh"
for psyrendust_run_once in $(ls "$PSY_RUN_ONCE/"); do
  source "$PSY_RUN_ONCE/$psyrendust_run_once"
  # Sourcing helper script to call all procedure functions in this script
  # ------------------------------------------------------------------------------
  if [[ -s "$PSY_SRC_TOOLS/psyrendust-procedure-init.zsh" ]]; then
    source "$PSY_SRC_TOOLS/psyrendust-procedure-init.zsh" "$PSY_RUN_ONCE/$psyrendust_run_once"
  fi
done
unset psyrendust_run_once
