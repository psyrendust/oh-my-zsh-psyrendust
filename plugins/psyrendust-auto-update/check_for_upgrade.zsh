#!/usr/bin/env zsh
function _check-internet() {
  wget -q --tries=10 --timeout=5 http://www.google.com -O /tmp/index.google &> /dev/null && echo 1
}

function _get-current-psyrendust-local-sha() {
  cd "$ZSH_CUSTOM"
  echo $(git rev-parse HEAD)
}

function _get-current-psyrendust-remote-sha() {
  cd "$ZSH_CUSTOM"
  echo $(git ls-remote $(git config remote.origin.url) HEAD | awk '{print $1}')
}

function _update-psyrendust-local-sha() {
  echo "current_psyrendust_local_sha=$(_get-current-psyrendust-local-sha)" > "$HOME/.psyrendust-update"
  printf '\033[0;35m%s \033[0;33m%s\033[0m\n' "[$HOME/.psyrendust-update] " "Updated"
}

function _upgrade-psyrendust() {
  /usr/bin/env ZSH=$ZSH ZSH_CUSTOM=$ZSH_CUSTOM zsh $ZSH_CUSTOM/plugins/psyrendust-auto-update/upgrade.zsh
  # update the psyrendust file
  _update-psyrendust-local-sha
}

# Check and see if we have internet first before continuing on
if [[ -n _check-internet ]]; then

  if [[ -f "$HOME/.psyrendust-update" ]]; then
    source ~/.psyrendust-update

    if [[ -z "$current_psyrendust_local_sha" ]]; then
      _update-psyrendust-local-sha && return 0;
    fi

    if [[ $current_psyrendust_local_sha != _get-current-psyrendust-remote-sha ]]; then
      printf '\033[0;35m%s \033[0;33m%s\033[0m\n' "[Oh My Zsh Psyrendust]" "Updates found..."
      _upgrade-psyrendust
    fi
  else
    # create the psyrendust file
    _update-psyrendust-local-sha
  fi
fi
