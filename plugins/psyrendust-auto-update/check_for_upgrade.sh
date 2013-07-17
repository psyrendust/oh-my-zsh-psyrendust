#!/bin/sh

function _current_psyrendust_epoch() {
  echo $(($(date +%s) / 60 / 60 / 24))
}

function _update_psyrendust_update() {
  echo "LAST_PSYRENDUST_EPOCH=$(_current_psyrendust_epoch)" > $ZSH_CUSTOM/.psyrendust-update
}

function _upgrade_psyrendust() {
  /usr/bin/env ZSH=$ZSH /bin/sh $ZSH_CUSTOM/plugins/psyrendust-auto-update/upgrade.sh
  # update the psyrendust file
  _update_psyrendust_update
}

epoch_psyrendust_target=$UPDATE_PSYRENDUST_DAYS
if [[ -z "$epoch_psyrendust_target" ]]; then
  # Default to old behavior
  epoch_psyrendust_target=13
fi

if [ -f $ZSH_CUSTOM/.psyrendust-update ]
then
  . $ZSH_CUSTOM/.psyrendust-update

  if [[ -z "$LAST_PSYRENDUST_EPOCH" ]]; then
    _update_psyrendust_update && return 0;
  fi

  epoch_psyrendust_diff=$(($(_current_psyrendust_epoch) - $LAST_PSYRENDUST_EPOCH))
  if [ $epoch_psyrendust_diff -gt $epoch_psyrendust_target ]
  then
    if [ "$DISABLE_UPDATE_PROMPT" = "true" ]
    then
      _upgrade_psyrendust
    else
      echo "[Oh My Zsh Psyrendust] Would you like to check for updates?"
      echo "Type Y to update oh-my-zsh-psyrendust: \c"
      read line
      if [ "$line" = Y ] || [ "$line" = y ]; then
        _upgrade_psyrendust
      else
        _update_psyrendust_update
      fi
    fi
  fi
else
  # create the psyrendust file
  _update_psyrendust_update
fi

