#!/usr/bin/env zsh
function check_internet() {
  wget -q --tries=10 --timeout=5 http://www.google.com -O /tmp/index.google &> /dev/null && echo 1
}

function get_current_psyrendust_local_sha() {
  cd "$ZSH_CUSTOM"
  echo $(git rev-parse HEAD)
}

function get_current_psyrendust_remote_sha() {
  echo $(git ls-remote $(git config remote.origin.url) HEAD | awk '{print $1}')
}

function update_psyrendust_local_sha() {
  echo "CURRENT_PSYRENDUST_LOCAL_SHA=$(get_current_psyrendust_local_sha)" > "$HOME/.psyrendust-update"
  printf '\033[0;35m%s \033[0;31m%s\033[0m\n' "[$HOME/.psyrendust-update] " "Updated"
}

function upgrade_psyrendust() {
  /usr/bin/env ZSH=$ZSH ZSH_CUSTOM=$ZSH_CUSTOM zsh $ZSH_CUSTOM/plugins/psyrendust-auto-update/upgrade.zsh
  # update the psyrendust file
  update_psyrendust_local_sha
}

function check_for_upgrade() {
  # Check and see if we have internet first before continuing on
  if [[ -n $(check_internet) ]]; then

    if [[ -f "$HOME/.psyrendust-update" ]]; then
      source ~/.psyrendust-update

      if [[ -z "$CURRENT_PSYRENDUST_LOCAL_SHA" ]]; then
        update_psyrendust_local_sha && return 0;
      fi

      if [[ $CURRENT_PSYRENDUST_LOCAL_SHA != $(get_current_psyrendust_remote_sha) ]]; then
        printf '\033[0;35m%s \033[0;33m%s\033[0m\n' "[Oh My Zsh Psyrendust]" "Updates found..."
        upgrade_psyrendust
      fi
    else
      # create the psyrendust file
      update_psyrendust_local_sha
    fi
  fi
}

check_for_upgrade
