#!/usr/bin/env zsh
# name: post-update.zsh
# author: Larry Gordon
#
# Post update script
# ------------------------------------------------------------------------------


# Sourcing pretty-print helpers
#  ppsuccess - green
#     ppinfo - light cyan
#  ppwarning - brown
#   ppdanger - red
# ppemphasis - purple
#  ppverbose - prints out message if PRETTY_PRINT_IS_VERBOSE="true"
# ------------------------------------------------------------------------------
psyrendust source "$ZSH_CUSTOM/plugins/pretty-print/pretty-print.plugin.zsh"



# Replace .zshrc
# ------------------------------------------------------------------------------
export PSYRENDUST_BACKUP_FOLDER="$ZSHRC_PERSONAL/backup/$(date '+%Y%m%d')"
mkdir -p "$PSYRENDUST_BACKUP_FOLDER"



# Starting post-update
# ------------------------------------------------------------------------------
_psyrendust-procedure-start() {
  pplightblue -i "[oh-my-zsh-psyrendust] Post update: "
}



# Check to see if config path has been created
# ------------------------------------------------------------------------------
_psyrendust-procedure-update-config-path() {
  [[ -d $PSYRENDUST_CONFIG_BASE_PATH ]] || mkdir -p $PSYRENDUST_CONFIG_BASE_PATH
  [[ -n $SYSTEM_IS_VM ]] || mkdir -p $PSYRENDUST_CONFIG_BASE_PATH/config/{git,win}
  # if [[ -n $SYSTEM_IS_VM ]]; then
  #   Symlink config path
  #   Don't process this for now. Use the link extension to create symlinks
  #   [[ -d "$SYSTEM_VM_HOME/.psyrendust/config" ]] && ln -sf "$SYSTEM_VM_HOME/.psyrendust/config" "$PSYRENDUST_CONFIG_BASE_PATH/config"
  # fi
}



# Migrate any legacy gitconfig-includes
# ------------------------------------------------------------------------------
_psyrendust-procedure-migrate-existing-gitconfig-includes() {
  if [[ -d "$HOME/.gitconfig-includes" ]]; then
    [[ -s "$HOME/.gitconfig-includes/user.gitconfig" ]] && cp "$HOME/.gitconfig-includes/user.gitconfig" "$PSYRENDUST_CONFIG_BASE_PATH/config/git/user.gitconfig"
    [[ -s "$HOME/.gitconfig-includes/github-xero-username.conf" ]] && cp "$HOME/.gitconfig-includes/github-xero-username.conf" "$PSYRENDUST_CONFIG_BASE_PATH/config/git/xero-username"
    mv "$HOME/.gitconfig-includes" "$PSYRENDUST_BACKUP_FOLDER/.gitconfig-includes"
  fi
}



# Install .gitconfig
# ------------------------------------------------------------------------------
_psyrendust-procedure-update-gitconfig() {
  [[ -f "$HOME/.gitconfig" ]] && mv "$HOME/.gitconfig" "$PSYRENDUST_BACKUP_FOLDER/.gitconfig"
  if [[ -n $SYSTEM_IS_CYGWIN ]]; then
    # Replace win .gitconfig
    cp "$ZSH_CUSTOM/templates/config/git/win.gitconfig" "$HOME/.gitconfig"
  else
    # Replace mac .gitconfig
    cp "$ZSH_CUSTOM/templates/config/git/mac.gitconfig" "$HOME/.gitconfig"
  fi
}



# Replace dotfiles
# ------------------------------------------------------------------------------
_psyrendust-procedure-update-dotfiles() {
  cp "$ZSH_CUSTOM/templates/.gemrc" "$HOME/.gemrc"
  cp "$ZSH_CUSTOM/templates/.gitignore_global" "${HOME}/.gitignore_global"
  cp "$ZSH_CUSTOM/templates/.zshrc" "$HOME/.zshrc"
}



# Install git config templates
# ------------------------------------------------------------------------------
_psyrendust-procedure-install-git-config-templates() {
  if [[ -z $SYSTEM_IS_VM ]]; then
    # Replace git configs
    [[ -f "$ZSH_CUSTOM/templates/config/git/core.gitconfig" ]] && cp "$ZSH_CUSTOM/templates/config/git/core.gitconfig" "$PSYRENDUST_CONFIG_BASE_PATH/config/git/core.gitconfig"
    [[ -f "$ZSH_CUSTOM/templates/config/git/diff.gitconfig" ]] && cp "$ZSH_CUSTOM/templates/config/git/diff.gitconfig" "$PSYRENDUST_CONFIG_BASE_PATH/config/git/diff.gitconfig"
    [[ -f "$ZSH_CUSTOM/templates/config/git/windows.gitconfig" ]] && cp "$ZSH_CUSTOM/templates/config/git/windows.gitconfig" "$PSYRENDUST_CONFIG_BASE_PATH/config/git/windows.gitconfig"
    if [[ -n $SYSTEM_IS_CYGWIN ]]; then
      [[ -f "$PSYRENDUST_CONFIG_BASE_PATH/config/git/custom-win.gitconfig" ]] || cp "$ZSH_CUSTOM/templates/config/git/custom-win.gitconfig" "$PSYRENDUST_CONFIG_BASE_PATH/config/git/custom-win.gitconfig"
    else
      [[ -f "$PSYRENDUST_CONFIG_BASE_PATH/config/git/custom-mac.gitconfig" ]] || cp "$ZSH_CUSTOM/templates/config/git/custom-mac.gitconfig" "$PSYRENDUST_CONFIG_BASE_PATH/config/git/custom-mac.gitconfig"
    fi
  fi
}



# Check to see if config/git/user has been created
# ------------------------------------------------------------------------------
_psyrendust-procedure-oh-my-zsh-psyrendust-updates() {
  if [[ ! -s "$PSYRENDUST_CONFIG_BASE_PATH/config/git/user.gitconfig" ]]; then
    cp "$ZSH_CUSTOM/templates/config/git/user.gitconfig" "$PSYRENDUST_CONFIG_BASE_PATH/config/git/user.gitconfig"
  fi
}



# Check to see if a Git global user.name has been set
# ------------------------------------------------------------------------------
_psyrendust-procedure-git-user-name() {
  psyrendust_config_git_user="$PSYRENDUST_CONFIG_BASE_PATH/config/git/user.gitconfig"
  if [[ -d $ZSH_CUSTOM ]] && [[ $(git config user.name) == "" ]]; then
    echo
    ppinfo -i "We need to configure your "
    pplightpurple "Git Global user.name"
    ppinfo -i "Please enter your first and last name ["
    pplightpurple -i "Firstname Lastname"
    ppinfo -i "]: "
    read git_user_name_first git_user_name_last
    echo "  name = ${git_user_name_first} ${git_user_name_last}" >> "$psyrendust_config_git_user"
    ppinfo -i "Git config user.name saved to: "
    pplightcyan "$psyrendust_config_git_user"
    unset git_user_name_first
    unset git_user_name_last
    echo
  fi
}



# Check to see if a Git global user.email has been set
# ------------------------------------------------------------------------------
_psyrendust-procedure-git-user-email() {
  psyrendust_config_git_user="$PSYRENDUST_CONFIG_BASE_PATH/config/git/user.gitconfig"
  # Check to see if a Git global user.email has been set
  if [[ -d $ZSH_CUSTOM ]] && [[ $(git config user.email) == "" ]]; then
    echo
    ppinfo -i "We need to configure your "
    pplightpurple "Git Global user.email"
    ppinfo -i "Please enter your work email address ["
    pplightpurple -i "first.last@domain.com"
    ppinfo -i "]: "
    read git_user_email
    echo "  email = ${git_user_email}" >> "$psyrendust_config_git_user"
    ppinfo -i "Git config user.email saved to: "
    pplightcyan "$psyrendust_config_git_user"
    unset git_user_email
    echo
  fi
}


