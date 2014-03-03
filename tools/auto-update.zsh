#!/usr/bin/env zsh


source "$ZSH_CUSTOM/tools/init-system.zsh"


# Sourcing pretty-print helpers
#  ppsuccess - green
#     ppinfo - light cyan
#  ppwarning - brown
#   ppdanger - red
# ppemphasis - purple
#  ppverbose - prints out message if PRETTY_PRINT_IS_VERBOSE="true"
# ------------------------------------------------------------------------------
psyrendust source "$ZSH_CUSTOM/plugins/pretty-print/pretty-print.plugin.zsh"



# Log helper functions
# ------------------------------------------------------------------------------
function _psyrendust-au-log() {
  plog "auto-update" "$1"
}

function _psyrendust-au-log-error() {
  plog -e "auto-update" "$1"
}

function _psyrendust-au-log-delete() {
  plog -d "auto-update"
}



# Internet check helper function
# ------------------------------------------------------------------------------
function _psyrendust-au-has-internet() {
  wget -q --tries=10 --timeout=5 http://www.google.com -O /tmp/index.google &> /dev/null && echo 1
}



# Git helper functions
# ------------------------------------------------------------------------------
function _psyrendust-au-get-current-git-branch() {
  ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  echo "${ref#refs/heads/}"
}

function _psyrendust-au-get-current-git-remote-sha() {
  _psyrendust-au-log "  - _psyrendust-au-get-current-git-remote-sha"
  _psyrendust-au-log "  - cd: ${1}"
  cd "${1}"
  result=$(git ls-remote $(git config remote.origin.url) HEAD 2>&1 | awk '{print $1}')
  _psyrendust-au-log "  - result: $result"
  if [[ $result == *fatal* ]]; then
    _psyrendust-au-log "  - result: is fatal"
    echo $(_psyrendust-au-set-last-git-update)
  else
    _psyrendust-au-log "  - result: success"
    echo $result
  fi
}

function _psyrendust-au-set-last-git-update() {
  cd "${1}"
  result="psyrendust_au_current_local_sha=$(git rev-parse HEAD)"
  echo "$result" > "$PSYRENDUST_CONFIG_BASE_PATH/last-repo-update-${2}"
}

function _psyrendust-au-is-git-repo() {
  _psyrendust-au-log "  - _psyrendust-au-is-git-repo"
  _psyrendust-au-log "  - cd: ${1}"
  cd "${1}"
  # check if we're in a git repo
  if [[ -d "./.git" ]]; then
    if [[ $(git rev-parse --is-inside-work-tree) == "true" ]]; then
      echo 1;
    fi
  fi
}

function _psyrendust-au-git-cleanup() {
  _psyrendust-au-log "  - _psyrendust-au-git-cleanup"
  # check if it's dirty and reset it back to HEAD
  if [[ -n $(git diff --ignore-submodules HEAD) ]]; then
    _psyrendust-au-log "  - git reset"
    # result=$(git reset HEAD --hard 2>&1)
    git reset HEAD --hard
  fi
}

function _psyrendust-au-git-update() {
  _psyrendust-au-log "  - _psyrendust-au-is-git-update"
  # Check if the folder exists
  if [[ -d $1 ]]; then
    _psyrendust-au-log "  - cd: ${1}"
    cd "${1}"
    _psyrendust-au-git-cleanup
    result=git pull --rebase origin $(_psyrendust-au-get-current-git-branch) 2>&1
    if [[ -n $result ]]; then
      _psyrendust-au-log "  - git pull successful"
      echo 1
    fi
  fi
}



if [[ -n $(which prprompt | grep "not found") ]]; then
  alias prprompt="_psyrendust-au-log-error \"prprompt not found\""
fi



# List repos we want to check and update
# ------------------------------------------------------------------------------
while getopts ":a" opt; do
  [[ $opt == "a" ]] && has_option=1
done
if [[ -n $has_option ]]; then
  repos=(
    "Oh My Zsh Psyrendust"
    "Oh My Zsh"
    "zshrc Personal"
    "zshrc Work"
  )
else
  repos=(
    "Oh My Zsh Psyrendust"
    "Oh My Zsh"
    "zshrc Personal"
    "zshrc Work"
  )
fi



# Check to see if cygwin-start has been created
# ------------------------------------------------------------------------------
if [[ -n $SYSTEM_IS_CYGWIN ]]; then
  psyrendust_au_cygwin_start_bat="$PSYRENDUST_CONFIG_BASE_PATH/config/win/cygwin-start.bat"
  psyrendust_au_cygwin_start_vbs="$PSYRENDUST_CONFIG_BASE_PATH/config/win/cygwin-start.vbs"
  psyrendust_au_cygwin_start_bat_src="$ZSH_CUSTOM/templates/config/win/cygwin-start.bat"
  psyrendust_au_cygwin_start_vbs_src="$ZSH_CUSTOM/templates/config/win/cygwin-start.vbs"
  if [[ ! -d "$PSYRENDUST_CONFIG_BASE_PATH/config/win" ]]; then
    mkdir "$PSYRENDUST_CONFIG_BASE_PATH/config/win"
  fi
  if [[ ! -f "$psyrendust_au_cygwin_start_vbs" ]]; then
    sed "s/CURRENT_USER_NAME/$(whoami)/g" "$psyrendust_au_cygwin_start_vbs_src" > "$psyrendust_au_cygwin_start_vbs"
  fi
  if [[ ! -f "$psyrendust_au_cygwin_start_bat" ]]; then
    sed "s/CURRENT_USER_NAME/$(whoami)/g" "$psyrendust_au_cygwin_start_bat_src" > "$psyrendust_au_cygwin_start_bat"
  fi
  unset -m psyrendust_au_cygwin_start_bat
  unset -m psyrendust_au_cygwin_start_bat_src
  unset -m psyrendust_au_cygwin_start_vbs
  unset -m psyrendust_au_cygwin_start_vbs_src
fi



# Reset logs
# ------------------------------------------------------------------------------
_psyrendust-au-log-delete



# ------------------------------------------------------------------------------
# Get the show going!
# ------------------------------------------------------------------------------
# Process updates
# ------------------------------------------------------------------------------
# Don't process updates for CYGWIN if we are in Parallels. We are symlinking
# those folders to the this users home directory. Only run the post update
# scripts.
# ------------------------------------------------------------------------------
if [[ -n $SYSTEM_IS_VM ]]; then
  _psyrendust-au-log "System is a VM"
else
  _psyrendust-au-log "System is native"
fi
prprompt -p $(((${#repos}*6)+1))
# Check and see if we have internet first before continuing on
# ------------------------------------------------------------------------------
if [[ -n $(_psyrendust-au-has-internet) ]]; then
  {
    sleep 1
    for repo in $repos; do
      _psyrendust-au-log "[$repo] Processing"
      prprompt -P
      # Slow things down since we are only doing file copies
      [[ -n $SYSTEM_IS_VM ]] && sleep 1


      # Create local variables to hold the namespace and the repo's root
      # ------------------------------------------------------------------------
      psyrendust_au_name_space="$(echo $repo | tr '[:upper:]' '[:lower:]' | tr ' ' '-')"
      psyrendust_au_git_root="$HOME/.${psyrendust_au_name_space}"
      psyrendust_au_last_repo_update="$PSYRENDUST_CONFIG_BASE_PATH/last-repo-update-${psyrendust_au_name_space}"
      psyrendust_au_post_update="$psyrendust_au_git_root/tools/post-update.zsh"
      psyrendust_au_post_update_run_once="$PSYRENDUST_CONFIG_BASE_PATH/post-update-run-once-${psyrendust_au_name_space}.zsh"
      _psyrendust-au-log "[$repo] Creating psyrendust_au_name_space=$psyrendust_au_name_space"
      _psyrendust-au-log "[$repo] Creating psyrendust_au_git_root=$psyrendust_au_git_root"
      _psyrendust-au-log "[$repo] Creating psyrendust_au_last_repo_update=$psyrendust_au_last_repo_update"
      _psyrendust-au-log "[$repo] Creating psyrendust_au_post_update=$psyrendust_au_post_update"
      _psyrendust-au-log "[$repo] Creating psyrendust_au_post_update_run_once=$psyrendust_au_post_update_run_once"


      # Check if the repo folder exists
      # ------------------------------------------------------------------------
      if [[ -d $psyrendust_au_git_root ]]; then
        _psyrendust-au-log "[$repo] Folder exists"
        prprompt -P


        # Check if we are in a repo
        # ----------------------------------------------------------------------
        if [[ -n $(_psyrendust-au-is-git-repo "$psyrendust_au_git_root") ]]; then
          _psyrendust-au-log "[$repo] Is a git repo"
          prprompt -P

          # Check if the last-repo-update file exists
          # --------------------------------------------------------------------
          if [[ -f "$psyrendust_au_last_repo_update" ]]; then
            _psyrendust-au-log "[$repo] Has $psyrendust_au_last_repo_update"
          else
            # Set last repo update
            _psyrendust-au-log "[$repo] Creating $psyrendust_au_last_repo_update"
            _psyrendust-au-set-last-git-update "$psyrendust_au_git_root" "$psyrendust_au_name_space"
          fi
          source "$psyrendust_au_last_repo_update"


          # Set the psyrendust_au_current_local_sha if it doesn't exist
          # --------------------------------------------------------------------
          if [[ -z "$psyrendust_au_current_local_sha" ]]; then
            _psyrendust-au-log "[$repo] \$psyrendust_au_current_local_sha does not exist"
            _psyrendust-au-set-last-git-update "$psyrendust_au_git_root" "$psyrendust_au_name_space";
            source "$psyrendust_au_last_repo_update"
          fi

          _psyrendust-au-log "[$repo] local SHA: $psyrendust_au_current_local_sha"


          # Get the current remote SHA
          # --------------------------------------------------------------------
          if [[ -n $SYSTEM_IS_VM ]]; then
            psyrendust_au_current_remote_sha=$(cd "$psyrendust_au_git_root" && git rev-parse HEAD)
            _psyrendust-au-log "[$repo] remote VM SHA: $psyrendust_au_current_remote_sha"
          else
            psyrendust_au_current_remote_sha=$(_psyrendust-au-get-current-git-remote-sha $psyrendust_au_git_root)
            _psyrendust-au-log "[$repo] remote SHA: $psyrendust_au_current_remote_sha"
          fi


          # Compare the local sha against the remote
          # --------------------------------------------------------------------
          if [[ $psyrendust_au_current_local_sha != $psyrendust_au_current_remote_sha ]]; then
            _psyrendust-au-log "[$repo] Fetching updates..."
            prprompt -P
            if [[ -n $SYSTEM_IS_VM ]]; then
              psyrendust_au_git_update_successful=1
            else
              psyrendust_au_git_update_successful=$(_psyrendust-au-git-update "$psyrendust_au_git_root")
            fi

            if [[ -n $psyrendust_au_git_update_successful ]]; then
              # Updates are complete
              # ----------------------------------------------------------------
              if [[ -f "$psyrendust_au_post_update" ]]; then
                _psyrendust-au-log "[$repo] Creating post-update-run"
                cp "$psyrendust_au_post_update" "$psyrendust_au_post_update_run_once"
                prprompt -P
              else
                _psyrendust-au-log "[$repo] No post-update-run found"
                prprompt -w
              fi
              _psyrendust-au-log "[$repo] Update successful"
              prprompt -P
              _psyrendust-au-set-last-git-update "$psyrendust_au_git_root" "$psyrendust_au_name_space"
              # Slow things down since we are only doing file copies
              [[ -n $SYSTEM_IS_VM ]] && sleep 1
            else
              _psyrendust-au-log-error "[$repo] Update error"
              prprompt -E
              prprompt -E
            fi
            unset psyrendust_au_git_update_successful
          else
            _psyrendust-au-log "[$repo] Already up-to-date"
            prprompt -P
            prprompt -P
            prprompt -P
          fi
        else
          _psyrendust-au-log "[$repo] Is not a git repo"
          prprompt -w
          prprompt -w
          prprompt -w
          prprompt -w
        fi
      else
        _psyrendust-au-log "[$repo] Folder does not exist"
        prprompt -w
        prprompt -w
        prprompt -w
        prprompt -w
        prprompt -w
      fi
      unset psyrendust_au_current_local_sha
      unset psyrendust_au_current_remote_sha
      unset psyrendust_au_git_root
      unset psyrendust_au_last_repo_update
      unset psyrendust_au_name_space
    done

    # echo out "string, " for each repo
    # results: "string1, string2, string3, "
    # Then use Substring Removal ${string%substring} to delete the shortest match from the end
    # Let's get rid of the trailing comma space ", " - ${string%", "}
    # results: "Checked repos: (string1, string2, string3)"
    _psyrendust-au-log "Checked repos: (${$(for repo in $repos; do echo -n "$repo, "; done)%", "})"


    if [[ -s $psyrendust_au_log_error ]]; then
      # Display an error message
      _psyrendust-au-log "Display an error message"
      _psyrendust-au-log "Errors were found!"
      _psyrendust-au-log "See log for details...[Psyrendust]"
      _psyrendust-au-log "Error log: $psyrendust_au_log_error"
      prprompt -E
      ppdanger "Errors were found!"
      ppdanger "Opening log for details...[Psyrendust]"
      ppdanger "Error log: $psyrendust_au_log_error"
      sbl $psyrendust_au_log_error
    else
      # Display a success message
      _psyrendust-au-log "Display a success message"
      _psyrendust-au-log "All updates complete!"
      prprompt -P
    fi
    prprompt -x
    sleep 1
    if [[ -n $SYSTEM_IS_MAC ]]; then
      # If we are running OS X we can use applescript to create a new tab and
      # close the current tab we are on
      osascript &>/dev/null <<EOF
tell application "iTerm"
activate
tell application "System Events"
  keystroke "t" using command down
  key code 123 using {command down, option down}
  keystroke "w" using command down
  key code 124 using {command down, option down}
end tell
end tell
EOF
    elif [[ -n $SYSTEM_IS_CYGWIN ]] && [[ -f "$psyrendust_au_cygwin_start_vbs" ]]; then
      # If we are running cygwin we can start a new console and exit the
      # previous one
      cygstart "$psyrendust_au_cygwin_start_vbs"
      exit
    fi
  } &!
else
  {
    # Just complete the progress because there is no internet
    # --------------------------------------------------------------------------
    prprompt -x
  } &!
fi

unfunction _psyrendust-au-log-delete
unfunction _psyrendust-au-log
unfunction _psyrendust-au-log-error
unfunction _psyrendust-au-has-internet
unfunction _psyrendust-au-get-current-git-remote-sha
unfunction _psyrendust-au-set-last-git-update
unfunction _psyrendust-au-is-git-repo
unfunction _psyrendust-au-git-cleanup
unfunction _psyrendust-au-git-update
unset -m psyrendust_au_current_local_sha
unset -m psyrendust_au_current_remote_sha
unset -m psyrendust_au_git_root
unset -m psyrendust_au_git_update_successful
unset -m psyrendust_au_last_epoch
unset -m psyrendust_au_last_run
unset -m psyrendust_au_log
unset -m psyrendust_au_log_error
unset -m psyrendust_au_name_space
