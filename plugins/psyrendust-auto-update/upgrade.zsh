#!/usr/bin/env zsh
function _is-git-repo() {
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
    # Check if we're in a git repo
    if [[ -n $(_is-git-repo) ]]; then
      _cleanup
      if git pull --rebase origin master; then
        # Run any repo specific updates
        callback_function="${2:-}"
        [[ $callback_function == '' ]] || $($2)
        unset callback_function
        echo 1
      fi
    else
      echo 2
    fi
  else
    echo 2
  fi
}

function _update-psyrendust() {
  # Run custom updates
  if [[ -d $ZSH_CUSTOM ]]; then
    cp "$ZSH_CUSTOM/templates/.zshrc" "$HOME/.zshrc"

    if [[ -n $SYSTEM_IS_MAC ]]; then
      # Replace .gitconfig
      [[ -s "$ZSH_CUSTOM/templates/.gitconfig_mac" ]] && cp "$ZSH_CUSTOM/templates/.gitconfig_mac" "$HOME/.gitconfig"
      # Check to see if .gitconfig-includes has been created
      [[ -d "$HOME/.gitconfig-includes" ]] || mkdir "$HOME/.gitconfig-includes"
    fi

    if [[ -n $SYSTEM_IS_CYGWIN ]]; then
      # Replace .gitconfig
      [[ -s "$ZSH_CUSTOM/templates/.gitconfig_win" ]] && cp "$ZSH_CUSTOM/templates/.gitconfig_win" "$HOME/.gitconfig"
      # Check to see if .gitconfig-includes has been symlinked in cygwin
      [[ -d "$HOME/.gitconfig-includes" ]] && ln -sf "/cygdrive/z/.gitconfig-includes" "$HOME/.gitconfig-includes"
    fi

    # Copy over gitconfig templates
    [[ -s "$ZSH_CUSTOM/templates/core.gitconfig" ]] || cp "$ZSH_CUSTOM/templates/core.gitconfig" "$HOME/.gitconfig-includes/core.gitconfig"
    [[ -s "$ZSH_CUSTOM/templates/diff.gitconfig" ]] || cp "$ZSH_CUSTOM/templates/diff.gitconfig" "$HOME/.gitconfig-includes/diff.gitconfig"

    # Check to see if user.gitconfig has been created
    if [[ ! -s "$HOME/.gitconfig-includes/user.gitconfig" ]]; then
      [[ -s "$ZSH_CUSTOM/templates/user.gitconfig" ]] && cp "$ZSH_CUSTOM/templates/user.gitconfig" "$HOME/.gitconfig-includes/user.gitconfig"
    fi

    # Check to see if a Git global user.name has been set
    if [[ $(git config user.name) == "" ]]; then
      printf '\033[0;31m%s\033[0m\n' "One time setup to configure your Git user.name"
      printf '\033[0;35m%s\033[0;31m%s\033[0m\n' "Please enter your first and last name " "[First Last]: "
      read GIT_USER_NAME_FIRST GIT_USER_NAME_LAST
      echo "  name = ${GIT_USER_NAME_FIRST} ${GIT_USER_NAME_LAST}" >> "$HOME/.gitconfig-includes/user.gitconfig"
      printf '\033[0;35m%s\033[0;36m%s\033[0m\n' "Git config user.name saved to: " "$HOME/.gitconfig-includes/user.gitconfig"
    fi

    # Check to see if a Git global user.email has been set
    if [[ $(git config user.email) == "" ]]; then
      printf '\033[0;31m%s\033[0m\n' "One time setup to configure your Git user.email"
      printf '\033[0;35m%s\033[0;31m%s\033[0m\n' "Please enter your work email address " "[first.last@domain.com]: "
      read GIT_USER_EMAIL
      echo "  email = ${GIT_USER_EMAIL}" >> "$HOME/.gitconfig-includes/user.gitconfig"
      printf '\033[0;35m%s\033[0;36m%s\033[0m\n' "Git config user.email saved to: " "$HOME/.gitconfig-includes/user.gitconfig"
    fi
  fi
}

function _update-pure-theme() {
  # Run custom updates
  if [[ -d $PURE_THEME ]]; then
    ln -sf "$HOME/.pure-theme/pure.zsh" "$ZSH_CUSTOM/themes/pure.zsh-theme"
  fi
}

function _update-zshrc-personal() {
  # Run custom updates
  [[ -d $ZSHRC_PERSONAL ]]
}

function _update-zshrc-work() {
  # Run custom updates
  [[ -d $ZSHRC_WORK ]]
}

function _process-update() {
  printf '\033[0;35m%s\033[0m\n' "Processing updates..."

  [[ -d "$ZSH_CUSTOM" ]] && printf '\033[0;35m%s\033[0m\n' "Oh My Zsh Psyrendust"
  success_update_psyrendust=$(_update-repo "$ZSH_CUSTOM" _update-psyrendust)

  [[ -d "$PURE_THEME" ]] && printf '\033[0;35m%s\033[0m\n' "Pure Theme"
  success_update_pure_theme=$(_update-repo "$PURE_THEME" _update-pure-theme)

  [[ -d "$ZSHRC_PERSONAL" ]] && printf '\033[0;35m%s\033[0m\n' "Personal zshrc"
  success_update_zshrc_personal=$(_update-repo "$ZSHRC_PERSONAL" _update-zshrc-personal)

  [[ -d "$ZSHRC_WORK" ]] && printf '\033[0;35m%s\033[0m\n' "Work zshrc"
  success_update_zshrc_work=$(_update-repo "$ZSHRC_WORK" _update-zshrc-work)

  [[ -n $success_update_psyrendust ]]    || printf '\033[0;31m%s\033[0m\n' ' - There was an error updating Oh My Zsh Psyrendust.'
  [[ -n $success_update_pure_theme ]]     || printf '\033[0;31m%s\033[0m\n' ' - There was an error updating Pure Theme.'
  [[ -n $success_update_zshrc_personal ]] || printf '\033[0;31m%s\033[0m\n' ' - There was an error updating zshrc-personal.'
  [[ -n $success_update_zshrc_work ]]     || printf '\033[0;31m%s\033[0m\n' ' - There was an error updating zshrc-work.'


  if [[ -n $success_update_psyrendust && -n $success_update_pure_theme && -n $success_update_zshrc_personal && -n $success_update_zshrc_work ]]; then
    printf '\033[0;35m%s\033[0m\n' '       __                            __                                    __         __  '
    printf '\033[0;35m%s\033[0m\n' ' ___  / /     __ _  __ __   ___ ___ / /     ___  ___ __ _________ ___  ___/ /_ _____ / /_ '
    printf '\033[0;35m%s\033[0m\n' '/ _ \/ _ \   /  ` \/ // /  /_ /(_-</ _ \   / _ \(_-</ // / __/ -_) _ \/ _  / // (_-</ __/ '
    printf '\033[0;35m%s\033[0m\n' '\___/_//_/  /_/_/_/\_, /   /__/___/_//_/  / .__/___/\_, /_/  \__/_//_/\_,_/\_,_/___/\__/  '
    printf '\033[0;35m%s\033[0m\n' '                  /___/                  /_/       /___/                                  '
    printf '\033[0;35m%s\033[0m\n' 'Hooray!'
  else
    printf '\033[0;31m%s\033[0m\n' 'Please try again later.'
  fi


  unset success_update_psyrendust;
  unset success_update_pure_theme;
  unset success_update_zshrc_personal;
  unset success_update_zshrc_work;
}

if [[ -n $SYSTEM_IS_CYGWIN ]] && [[ -d "/cygdrive/z/.oh-my-zsh-psyrendust" ]]; then
  # Don't process updates for CYGWIN because we are in
  # Parallels and symlinking those folders to the this
  # users home directory
  _update-psyrendust
  _update-pure-theme
  _update-zshrc-personal
  _update-zshrc-work
else
  _process-update
fi
