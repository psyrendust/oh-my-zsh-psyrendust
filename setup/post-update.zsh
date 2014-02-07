#!/usr/bin/env zsh
# name: post-update.zsh
# author: Larry Gordon
#
# My post update script
# ----------------------------------------------------------

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
    [[ -d "/cygdrive/z/.gitconfig-includes" ]] && rm "/cygdrive/z/.gitconfig-includes"
    ln -sf "/cygdrive/z/.gitconfig-includes" "$HOME/.gitconfig-includes"
  fi

  # Copy over gitconfig templates
  [[ -s "$ZSH_CUSTOM/templates/core.gitconfig" ]] && cp "$ZSH_CUSTOM/templates/core.gitconfig" "$HOME/.gitconfig-includes/core.gitconfig"
  [[ -s "$ZSH_CUSTOM/templates/diff.gitconfig" ]] && cp "$ZSH_CUSTOM/templates/diff.gitconfig" "$HOME/.gitconfig-includes/diff.gitconfig"

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
