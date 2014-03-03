#!/usr/bin/env zsh

# Add some cygwin related functions
# ------------------------------------------------------------------------------
if [[ -n $SYSTEM_IS_CYGWIN ]]; then
  psyrendust-mkcygwin() {
    echo "echo off" > $1
    echo -n "%1 -q -P " >> $1
    echo $(echo $(cygcheck -c -d | sed -e "1,2d" -e 's/ .*$//') | tr " " ",") >> $1
  }
fi

# Force run the auto-update script
# ------------------------------------------------------------------------------
psyrendust-update() {
  [[ -f "$PSYRENDUST_CONFIG_BASE_PATH/auto-update-last-run" ]] && rm "$PSYRENDUST_CONFIG_BASE_PATH/auto-update-last-run";
  [[ -f "$PSYRENDUST_CONFIG_BASE_PATH/pprocess-post-update" ]] && rm "$PSYRENDUST_CONFIG_BASE_PATH/pprocess-post-update";
  [[ -f "$PSYRENDUST_CONFIG_BASE_PATH/post-update-procedure-result.conf" ]] && rm "$PSYRENDUST_CONFIG_BASE_PATH/post-update-procedure-result.conf";
  [[ -f "$PSYRENDUST_CONFIG_BASE_PATH/post-update-progress.conf" ]] && rm "$PSYRENDUST_CONFIG_BASE_PATH/post-update-progress.conf";
  psyrendust source "$ZSH_CUSTOM/plugins/prprompt/prprompt.plugin.zsh";
  psyrendust source "$ZSH_CUSTOM/tools/auto-update.zsh"
}
