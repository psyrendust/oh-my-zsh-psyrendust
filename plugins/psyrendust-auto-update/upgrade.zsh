#!/usr/bin/env zsh

function _has-internet() {
  wget -q --tries=10 --timeout=5 http://www.google.com -O /tmp/index.google &> /dev/null && echo 1
}

function _get-current-repo-remote-sha() {
  cd "${1}"
  result=$(git ls-remote $(git config remote.origin.url) HEAD | awk '{print $1}')
  if [[ $result == *fatal* ]]; then
    echo $(_set-last-repo-update)
  else
    echo $result
  fi
}

function _set-last-repo-update() {
  cd "${1}"
  echo "current_local_sha=$(git rev-parse HEAD)" > "$HOME/.psyrendust/last-repo-update-${2}"
  printf '\033[0;35m%s \033[0;33m%s\033[0m\n' "[$HOME/.psyrendust/last-repo-update-${2}] " "Updated"
}

function _is-git-repo() {
  cd "${1}"
  # check if we're in a git repo
  if [[ -d "./.git" ]]; then
    if [[ $(git rev-parse --is-inside-work-tree) == "true" ]]; then
      echo 1;
    fi
  fi
}

function _cleanup() {
  # check if it's dirty and reset it back to HEAD
  if [[ -n $(git diff --ignore-submodules HEAD) ]]; then
    git reset HEAD --hard
  fi
}

function _update-repo() {
  # Check if the folder exists
  if [[ -d $1 ]]; then
    cd $1
    _cleanup
    if git pull --rebase origin master; then
      echo 1
    fi
  fi
}


# Post process update scripts
# ----------------------------------------------------------
function _oh-my-zsh-psyrendust-post-update() {
  [[ -f "$HOME/.oh-my-zsh-psyrendust/setup/post-update.zsh" ]] && source "$HOME/.oh-my-zsh-psyrendust/setup/post-update.zsh"
  _set-last-repo-update $@
}

function _oh-my-zsh-post-update() {
  ppsuccess "Oh My Zsh has been updated!"
  _set-last-repo-update $@
}

function _pure-theme-post-update() {
  if [[ -d $PURE_THEME ]]; then
    ln -sf "$HOME/.pure-theme/pure.zsh" "$ZSH_CUSTOM/themes/pure.zsh-theme"
  fi
  ppsuccess "Pure Theme has been updated!"
  _set-last-repo-update $@
}

function _zshrc-personal-post-update() {
  ppsuccess "zshrc personal has been updated!"
  _set-last-repo-update $@
}

function _zshrc-work-post-update() {
  ppsuccess "zshrc work has been updated!"
  _set-last-repo-update $@
}


# List repos we want to check and update
# ----------------------------------------------------------
while getopts ":a" opt; do
  [[ $opt == "a" ]] && has_option=1
done
if [[ -n $has_option ]]; then
  repos=(
    "Oh My Zsh Psyrendust"
    "Oh My Zsh"
    "Pure Theme"
    "zshrc Personal"
    "zshrc Work"
  )
else
  repos=(
    "Oh My Zsh Psyrendust"
    "zshrc Personal"
    "zshrc Work"
  )
fi



# Get the show going!
# ----------------------------------------------------------
if [[ -n $SYSTEM_IS_CYGWIN ]] && [[ -d "/cygdrive/z/.oh-my-zsh-psyrendust" ]]; then
  # Don't process updates for CYGWIN because we are in
  # Parallels and symlinking those folders to the this
  # users home directory
  _oh-my-zsh-psyrendust-post-update
  _oh-my-zsh-post-update
  _pure-theme-post-update
  _zshrc-personal-post-update
  _zshrc-work-post-update
  update_found=1
else
  # Check and see if we have internet first before continuing on
  if [[ -n $(_has-internet) ]]; then

    # Source Pretty Print
    [[ -f $ZSH_CUSTOM/plugins/pretty-print/pretty-print.plugin.zsh ]] && source $ZSH_CUSTOM/plugins/pretty-print/pretty-print.plugin.zsh

    pppurple -i "Checking for updates"
    for repo in $repos; do
      # Create local variables to hold the namespace and the repo's root
      name_space="$(echo $repo | tr '[:upper:]' '[:lower:]' | tr ' ' '-')"
      repo_root="$HOME/.${name_space}"

      pplightpurple -i "."

      # Check if the repo folder exists
      if [[ -d $repo_root ]]; then

        # Check if we are in a repo
        if [[ -n $(_is-git-repo "$repo_root") ]]; then

          # Check if the last-repo-update file exists
          if [[ -f "$HOME/.psyrendust/last-repo-update-${name_space}" ]]; then
            source "$HOME/.psyrendust/last-repo-update-${name_space}"

            # Set the current_local_sha if it doesn't exist
            if [[ -z "$current_local_sha" ]]; then
              _set-last-repo-update "$repo_root" "$name_space" && return 0;
            fi

            # Compare the local sha against the remote
            if [[ $current_local_sha != $(_get-current-repo-remote-sha $repo_root) ]]; then
              ppemphasis -i "[$repo] "
              ppyellow "Updates found..."
              update_successful=$(_update-repo "$repo_root")

              if [[ -n $update_successful ]]; then
                # Run any repo specific updates
                _${name_space}-post-update "$repo_root" "$name_space"
              else
                ppdanger " - There was an error updating $repo."
              fi

              unset update_successful
            fi

          else
            # Set last repo update
            ppdanger "last-repo-update file does not exists"
            _set-last-repo-update "$repo_root" "$name_space"
          fi

        fi

      fi
      unset name_space
      unset repo_root
    done

  fi
fi
