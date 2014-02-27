#!/usr/bin/env zsh
# name: post-update.zsh
# author: Larry Gordon
#
# My post update script
# ------------------------------------------------------------------------------



# Sourcing pretty-print helpers
#  ppsuccess - green
#     ppinfo - light cyan
#  ppwarning - brown
#   ppdanger - red
# ppemphasis - purple
#  ppverbose - prints out message if PRETTY_PRINT_IS_VERBOSE="true"
# ------------------------------------------------------------------------------
if [[ -s $HOME/.oh-my-zsh-psyrendust/plugins/pretty-print/pretty-print.plugin.zsh ]]; then
  source $HOME/.oh-my-zsh-psyrendust/plugins/pretty-print/pretty-print.plugin.zsh
fi



# Setup base config path
# ------------------------------------------------------------------------------
[[ -d "$PSYRENDUST_CONFIG_BASE_PATH" ]] || mkdir -p "$PSYRENDUST_CONFIG_BASE_PATH"



# Replace .zshrc
# ------------------------------------------------------------------------------
export PSYRENDUST_BACKUP_FOLDER="$ZSHRC_PERSONAL/backup/$(date '+%Y%m%d_%H')00"
[[ -d "$PSYRENDUST_BACKUP_FOLDER" ]] || mkdir -p "$PSYRENDUST_BACKUP_FOLDER"



# Starting post-update
# ------------------------------------------------------------------------------
_psyrendust-procedure-start() {
  pplightblue -i "[oh-my-zsh-psyrendust] Post update: "
}



# Check to see if base path has been created
# ------------------------------------------------------------------------------
_psyrendust-procedure-update-base-path() {
  [[ -d "$PSYRENDUST_CONFIG_BASE_PATH" ]] || mkdir -p "$PSYRENDUST_CONFIG_BASE_PATH"
}



# Check to see if config path has been created
# ------------------------------------------------------------------------------
_psyrendust-procedure-update-config-path() {
  if [[ -n $SYSTEM_IS_VM ]]; then
    # Symlink config path
    # Don't process this for now. Use the link extension to create symlinks
    # [[ -d "$SYSTEM_VM_HOME/.psyrendust/config" ]] && ln -sf "$SYSTEM_VM_HOME/.psyrendust/config" "$PSYRENDUST_CONFIG_BASE_PATH/config"
  else
    [[ -d "$PSYRENDUST_CONFIG_BASE_PATH/config" ]] || mkdir -p "$PSYRENDUST_CONFIG_BASE_PATH/config"
  fi
}



# Check to see if config/git path has been created
# ------------------------------------------------------------------------------
_psyrendust-procedure-update-config-git-path() {
  if [[ ! -d "$PSYRENDUST_CONFIG_BASE_PATH/config/git" ]]; then
    mkdir "$PSYRENDUST_CONFIG_BASE_PATH/config/git"
  fi
}



# Migrate any legacy gitconfig-includes
# ------------------------------------------------------------------------------
_psyrendust-procedure-migrate-existing-gitconfig-includes() {
  if [[ -d "$HOME/.gitconfig-includes" ]]; then
    [[ -s "$HOME/.gitconfig-includes/user.gitconfig" ]] && cp "$HOME/.gitconfig-includes/user.gitconfig" "$PSYRENDUST_CONFIG_BASE_PATH/config/git/user"
    [[ -s "$HOME/.gitconfig-includes/github-xero-username.conf" ]] && cp "$HOME/.gitconfig-includes/github-xero-username.conf" "$PSYRENDUST_CONFIG_BASE_PATH/config/git/github-username"
    mv "$HOME/.gitconfig-includes" "$PSYRENDUST_BACKUP_FOLDER/.gitconfig-includes"
  fi
}



# Install .gitconfig
# ------------------------------------------------------------------------------
_psyrendust-procedure-update-gitconfig() {
  [[ -f "$HOME/.gitconfig" ]] && mv "$HOME/.gitconfig" "$PSYRENDUST_BACKUP_FOLDER/.gitconfig"
  if [[ -n $SYSTEM_IS_CYGWIN ]]; then
    # Replace win .gitconfig
    [[ -s "$ZSH_CUSTOM/templates/config/git/gitconfig-win" ]] && cp "$ZSH_CUSTOM/templates/config/git/gitconfig-win" "$HOME/.gitconfig"
  else
    # Replace mac .gitconfig
    [[ -s "$ZSH_CUSTOM/templates/config/git/gitconfig-mac" ]] && cp "$ZSH_CUSTOM/templates/config/git/gitconfig-mac" "$HOME/.gitconfig"
  fi
}



# Replace dotfiles
# ------------------------------------------------------------------------------
_psyrendust-procedure-update-dotfiles() {
  [[ -f "$ZSH_CUSTOM/templates/.gemrc" ]] && cp "$ZSH_CUSTOM/templates/.gemrc" "$HOME/.gemrc"
  [[ -f "$ZSH_CUSTOM/templates/.gitignore_global" ]] && cp "$ZSH_CUSTOM/templates/.gitignore_global" "${HOME}/.gitignore_global"
  [[ -f "$ZSH_CUSTOM/templates/.zshrc" ]] && cp "$ZSH_CUSTOM/templates/.zshrc" "$HOME/.zshrc"
}



# Install git config templates
# ------------------------------------------------------------------------------
_psyrendust-procedure-install-git-config-templates() {
  if [[ -z $SYSTEM_IS_VM ]]; then
    # Replace git configs
    [[ -f "$ZSH_CUSTOM/templates/config/git/core" ]] && cp "$ZSH_CUSTOM/templates/config/git/core" "$PSYRENDUST_CONFIG_BASE_PATH/config/git/core"
    [[ -f "$ZSH_CUSTOM/templates/config/git/diff" ]] && cp "$ZSH_CUSTOM/templates/config/git/diff" "$PSYRENDUST_CONFIG_BASE_PATH/config/git/diff"
    [[ -f "$ZSH_CUSTOM/templates/config/git/windows" ]] && cp "$ZSH_CUSTOM/templates/config/git/windows" "$PSYRENDUST_CONFIG_BASE_PATH/config/git/windows"
    if [[ -n $SYSTEM_IS_CYGWIN ]]; then
      [[ ! -f "$PSYRENDUST_CONFIG_BASE_PATH/config/git/custom-win" ]] && cp "$ZSH_CUSTOM/templates/config/git/custom-win" "$PSYRENDUST_CONFIG_BASE_PATH/config/git/custom-win"
    else
      [[ ! -f "$PSYRENDUST_CONFIG_BASE_PATH/config/git/custom-mac" ]] && cp "$ZSH_CUSTOM/templates/config/git/custom-mac" "$PSYRENDUST_CONFIG_BASE_PATH/config/git/custom-mac"
    fi
  fi
}



# Check to see if config/git/user has been created
# ------------------------------------------------------------------------------
_psyrendust-procedure-oh-my-zsh-psyrendust-updates() {
  if [[ ! -s "$PSYRENDUST_CONFIG_BASE_PATH/config/git/user" ]]; then
    cp "$ZSH_CUSTOM/templates/config/git/user" "$PSYRENDUST_CONFIG_BASE_PATH/config/git/user"
  fi
}



# Check to see if a Git global user.name has been set
# ------------------------------------------------------------------------------
_psyrendust-procedure-git-user-name() {
  if [[ -d $ZSH_CUSTOM ]] && [[ $(git config user.name) == "" ]]; then
    echo
    ppinfo -i "We need to configure your "
    pplightpurple "Git Global user.name"
    ppinfo -i "Please enter your first and last name ["
    pplightpurple -i "Firstname Lastname"
    ppinfo -i "]: "
    read git_user_name_first git_user_name_last
    echo "  name = ${git_user_name_first} ${git_user_name_last}" >> "$PSYRENDUST_CONFIG_BASE_PATH/config/git/user"
    ppinfo -i "Git config user.name saved to: "
    pplightcyan "$PSYRENDUST_CONFIG_BASE_PATH/config/git/user"
    unset git_user_name_first
    unset git_user_name_last
    echo
  fi
}



# Check to see if a Git global user.email has been set
# ------------------------------------------------------------------------------
_psyrendust-procedure-git-user-email() {
  # Check to see if a Git global user.email has been set
  if [[ -d $ZSH_CUSTOM ]] && [[ $(git config user.email) == "" ]]; then
    echo
    ppinfo -i "We need to configure your "
    pplightpurple "Git Global user.email"
    ppinfo -i "Please enter your work email address ["
    pplightpurple -i "first.last@domain.com"
    ppinfo -i "]: "
    read git_user_email
    echo "  email = ${git_user_email}" >> "$PSYRENDUST_CONFIG_BASE_PATH/config/git/user"
    ppinfo -i "Git config user.email saved to: "
    pplightcyan "$PSYRENDUST_CONFIG_BASE_PATH/config/git/user"
    unset git_user_email
    echo
  fi
}


