#!/usr/bin/env zsh
# name: post-update.zsh
# author: Larry Gordon
#
# Post update script
# ------------------------------------------------------------------------------



# Create ZSH backup folder
# ------------------------------------------------------------------------------
export PSY_BACKUP_FOLDER="$PSY_BACKUP/$(date '+%Y%m%d')"
[[ -d "$PSY_BACKUP_FOLDER" ]] || mkdir -p "$PSY_BACKUP_FOLDER"



# Starting post-update
# ------------------------------------------------------------------------------
_psyrendust-procedure-start() {
  pplightblue -i "[oh-my-zsh-psyrendust] Post update: "
}



# Replace config/git
# ------------------------------------------------------------------------------
_psyrendust-procedure-replace-config-git() {
  cp -aR "$PSY_SRC_TEMPLATES_CONFIG/git/." "$PSY_CONFIG_GIT/"
}



# Replace config/win
# ------------------------------------------------------------------------------
_psyrendust-procedure-replace-config-win() {
  cp -aR "$PSY_SRC_TEMPLATES_CONFIG/win/." "$PSY_CONFIG_WIN/"
}



# Replace home
# ------------------------------------------------------------------------------
_psyrendust-procedure-replace-home() {
  cp -aR "$PSY_SRC_TEMPLATES/home/." "$HOME/"
}



# Restart shell, and kill the current pprocess status
# ------------------------------------------------------------------------------
_psyrendust-procedure-source-shell() {
  if [[ -f "$PSY_VERSION/psyrendust.info" ]]; then
    # Remove the previous version file so that it can get recreated after
    # the shell restarts
    rm "$PSY_VERSION/psyrendust.info"
  fi
  {
    sleep 1
    pprocess -x "post-update-run-once-oh-my-zsh-psyrendust"
    psy restartshell
  } &!
}



# Waiting for shell restart completion
# ------------------------------------------------------------------------------
_psyrendust-procedure-waiting() {
  sleep 5
}



# Migrate any legacy gitconfig-includes
# ------------------------------------------------------------------------------
_psyrendust-procedure-migrate-existing-gitconfig-includes() {
  if [[ -d "$HOME/.gitconfig-includes" ]]; then
    [[ -s "$HOME/.gitconfig-includes/user.gitconfig" ]] && cp -aR "$HOME/.gitconfig-includes/user.gitconfig" "$PSY_CONFIG_GIT/user.gitconfig"
    [[ -s "$HOME/.gitconfig-includes/github-xero-username.conf" ]] && cp -aR "$HOME/.gitconfig-includes/github-xero-username.conf" "$PSY_CONFIG_GIT/xero-username.zsh"
    mv "$HOME/.gitconfig-includes" "$PSY_BACKUP_FOLDER/.gitconfig-includes"
  fi
}



# Install .gitconfig
# ------------------------------------------------------------------------------
_psyrendust-procedure-update-gitconfig() {
  [[ -f "$HOME/.gitconfig" ]] && mv "$HOME/.gitconfig" "$PSY_BACKUP_FOLDER/.gitconfig"
  if [[ -n $SYSTEM_IS_CYGWIN ]]; then
    local system_os="win"
  else
    local system_os="mac"
  fi
  cp -aR "$PSY_SRC_TEMPLATES/home-${system_os}/." "$HOME/"
}



# Install git config templates
# ------------------------------------------------------------------------------
_psyrendust-procedure-install-git-config-templates() {
  if [[ -z $SYSTEM_IS_VM ]]; then
    # Replace git configs
    cp -aR "$PSY_SRC_TEMPLATES_CONFIG/git/." "$PSY_CONFIG_GIT/"
    cp -an "$PSY_SRC_TEMPLATES_CONFIG/blank/custom-"{mac,win}.gitconfig "$PSY_CONFIG_GIT/"
  fi
}



# Check to see if config/git/user has been created
# ------------------------------------------------------------------------------
_psyrendust-procedure-oh-my-zsh-psyrendust-updates() {
  cp -an "$PSY_SRC_TEMPLATES_CONFIG/blank/user.gitconfig" "$PSY_CONFIG_GIT/user.gitconfig"
}



# Check to see if a Git global user.name has been set
# ------------------------------------------------------------------------------
_psyrendust-procedure-git-user-name() {
  psyrendust_config_git_user="$PSY_CONFIG_GIT/user.gitconfig"
  if [[ -d $PSY_CUSTOM ]] && [[ $(git config user.name) == "" ]]; then
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
  psyrendust_config_git_user="$PSY_CONFIG_GIT/user.gitconfig"
  # Check to see if a Git global user.email has been set
  if [[ -d $PSY_CUSTOM ]] && [[ $(git config user.email) == "" ]]; then
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
