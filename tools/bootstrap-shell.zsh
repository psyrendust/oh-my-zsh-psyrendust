#!/usr/bin/env zsh
# name: bootstrap-shell.zsh
# author: Larry Gordon
#
# My starter script for bootstraping your shell environment!
# ------------------------------------------------------------------------------



# Path to your oh-my-zsh configuration
# ----------------------------------------------------------
ZSH="$HOME/.oh-my-zsh"

# Set the location of oh-my-zsh-psyrendust
# ------------------------------------------------------------------------------
export ZSH_CUSTOM="$HOME/.oh-my-zsh-psyrendust"

# Set the location of our work zshrc location
# ------------------------------------------------------------------------------
export ZSHRC_WORK="$HOME/.zshrc-work"

# Set the location of our personal zshrc location
# ------------------------------------------------------------------------------
export ZSHRC_PERSONAL="$HOME/.zshrc-personal"

# Make a backup folder if it doesn't exist
# ------------------------------------------------------------------------------
export PSYRENDUST_BACKUP_FOLDER="$ZSHRC_PERSONAL/backup/$(date '+%Y%m%d_%H')00"
[[ -d "$PSYRENDUST_BACKUP_FOLDER" ]] || mkdir -p "$PSYRENDUST_BACKUP_FOLDER"

# Ensure we have a temp folder to work with
# ------------------------------------------------------------------------------
export PSYRENDUST_CONFIG_BASE_PATH="$HOME/.psyrendust"
if [[ ! -d $PSYRENDUST_CONFIG_BASE_PATH ]]; then
  mkdir -p "$PSYRENDUST_CONFIG_BASE_PATH/config"
fi

# ------------------------------------------------------------------------------
# Download a local copy of oh-my-zsh-psyrendust to help get us started
# ------------------------------------------------------------------------------
[[ -d "$HOME/.oh-my-zsh-psyrendust" ]] && mv "$HOME/.oh-my-zsh-psyrendust-old"
git clone https://github.com/psyrendust/oh-my-zsh-psyrendust.git "$HOME/.oh-my-zsh-psyrendust"



# ------------------------------------------------------------------------------
# Load up some defaults
# ------------------------------------------------------------------------------
# Init system
if [[ -f "$ZSH_CUSTOM/tools/init-system.zsh" ]]; then
  source "$ZSH_CUSTOM/tools/init-system.zsh"
fi
# Init paths
if [[ -f "$ZSH_CUSTOM/tools/init-paths.zsh" ]]; then
  source "$ZSH_CUSTOM/tools/init-paths.zsh"
fi





# Helper function to check if a formula is installed in homebrew
# ------------------------------------------------------------------------------
_brew-is-installed() {
  echo $(brew list | grep "^${1}$")
}


# Helper function to check if a formula is tapped in homebrew
# ------------------------------------------------------------------------------
_brew-is-tapped() {
  echo $(brew tap | grep "^${1}$")
}


# Helper function that will kill a process by name
# ------------------------------------------------------------------------------
_killname() {
  process_name=$1
  len=${#process_name}
  new_process_name="[${process_name:0:1}]${process_name:1:$len}"
  processes=$(ps -A | grep -i $new_process_name)
  if [[ -n $processes ]]; then
    awk '{print $1}' <(processes) | xargs kill -9
  fi
}



# ------------------------------------------------------------------------------
# Let's get started
# ------------------------------------------------------------------------------



# Symlink some folders to get us started in Virtualized Windows
# ------------------------------------------------------------------------------
_psyrendust-procedure-init-vm() {
  if [[ -n $SYSTEM_IS_VM ]]; then
    # Remove any previous symlinks
    [[ -d "$HOME/.oh-my-zsh-psyrendust" ]] && rm -rf "$HOME/.oh-my-zsh-psyrendust"
    [[ -d "$HOME/.ssh" ]] && rm -rf "$HOME/.ssh"
    [[ -d "$HOME/.zshrc-personal" ]] && rm -rf "$HOME/.zshrc-personal"
    [[ -d "$HOME/.zshrc-work" ]] && rm -rf "$HOME/.zshrc-work"
    # Create symlinks
    ln -sf "$SYSTEM_VM_HOME/.oh-my-zsh-psyrendust" "$HOME/.oh-my-zsh-psyrendust"
    ln -sf "$SYSTEM_VM_HOME/.ssh" "$HOME/.ssh"
    ln -sf "$SYSTEM_VM_HOME/.zshrc-personal" "$HOME/.zshrc-personal"
    ln -sf "$SYSTEM_VM_HOME/.zshrc-work" "$HOME/.zshrc-work"
  fi
}



# Backup your current configuration stuff in
# "$ZSHRC_PERSONAL/backup/".
# ------------------------------------------------------------------------------
_psyrendust-procedure-backup-configs() {
  ppinfo 'Backup your current configuration stuff'
  [[ -s $HOME/.gemrc ]] && mv $HOME/.gemrc $PSYRENDUST_BACKUP_FOLDER/.gemrc
  [[ -s $HOME/.gitconfig ]] && mv $HOME/.gitconfig $PSYRENDUST_BACKUP_FOLDER/.gitconfig
  [[ -s $HOME/.gitignore_global ]] && mv $HOME/.gitignore_global $PSYRENDUST_BACKUP_FOLDER/.gitignore_global
  [[ -s $HOME/.zshrc ]] && mv $HOME/.zshrc $PSYRENDUST_BACKUP_FOLDER/.zshrc
  [[ -d $HOME/.gitconfig-includes ]] && mv $HOME/.gitconfig-includes $PSYRENDUST_BACKUP_FOLDER/.gitconfig-includes
  [[ -d $PSYRENDUST_CONFIG_BASE_PATH ]] && mv $PSYRENDUST_CONFIG_BASE_PATH $PSYRENDUST_BACKUP_FOLDER/.psyrendust
  [[ -s /etc/hosts ]] && cp /etc/hosts $PSYRENDUST_BACKUP_FOLDER/hosts
  [[ -s /etc/auto_master ]] && cp /etc/auto_master $PSYRENDUST_BACKUP_FOLDER/auto_master
  [[ -s /etc/auto_smb ]] && cp /etc/auto_smb $PSYRENDUST_BACKUP_FOLDER/auto_smb
  # a little cleanup
  [[ -s $HOME/.zlogin ]] && mv $HOME/.zlogin $PSYRENDUST_BACKUP_FOLDER/.zlogin
  [[ -s $HOME/.zsh-update ]] && mv $HOME/.zsh-update $PSYRENDUST_BACKUP_FOLDER/.zsh-update
  [[ -s $HOME/.zsh_history ]] && mv $HOME/.zsh_history $PSYRENDUST_BACKUP_FOLDER/.zsh_history
  rm $HOME/.zcompdump*
  rm $HOME/NUL
}



# See if we already have some user data
# ------------------------------------------------------------------------------
_psyrendust-procedure-load-user-data() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  if [[ -f "$psyrendust_pi_config_user_info" ]]; then
    source "$psyrendust_pi_config_user_info"
  fi
}



# Would you like to replace your hosts file [y/n]?
# ------------------------------------------------------------------------------
_psyrendust-procedure-ask-replace-hosts-file() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  if [[ -n "$psyrendust_replace_hosts_file" ]]; then
    ppinfo "Would you like to replace your hosts file [y/n]? "
    read psyrendust_replace_hosts_file
    echo "psyrendust_replace_hosts_file=$psyrendust_replace_hosts_file" >> $psyrendust_pi_config_user_info
  fi
}



# Copy over git config templates from oh-my-zsh-psyrendust
# ------------------------------------------------------------------------------
_psyrendust-procedure-git-config-templates() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  cp "$ZSH_CUSTOM/templates/config/git/core" "$PSYRENDUST_CONFIG_BASE_PATH/config/git/core"
  cp "$ZSH_CUSTOM/templates/config/git/diff" "$PSYRENDUST_CONFIG_BASE_PATH/config/git/diff"
  cp "$ZSH_CUSTOM/templates/config/git/windows" "$PSYRENDUST_CONFIG_BASE_PATH/config/git/windows"
}



# Check to see if config/git/user has been created
# ------------------------------------------------------------------------------
_psyrendust-procedure-config-git-user() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  if [[ ! -s "$PSYRENDUST_CONFIG_BASE_PATH/config/git/user" ]]; then
    cp "$ZSH_CUSTOM/templates/config/git/user" "$PSYRENDUST_CONFIG_BASE_PATH/config/git/user"
  fi
}



# Check to see if a Git global user.name has been set
# ------------------------------------------------------------------------------
_psyrendust-procedure-git-user-name() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  if [[ $(git config user.name) == "" ]]; then
    echo
    ppinfo -i "We need to configure your " && pplightpurple "Git Global user.name"
    ppinfo -i "Please enter your first and last name ["
    pplightpurple -i "Firstname Lastname"
    ppinfo -i "]: "
    read git_user_name_first git_user_name_last
    echo "  name = ${git_user_name_first} ${git_user_name_last}" >> "$PSYRENDUST_CONFIG_BASE_PATH/config/git/user"
    unset git_user_name_first
    unset git_user_name_last
    echo
  fi
}



# Check to see if a Git global user.email has been set
# ------------------------------------------------------------------------------
_psyrendust-procedure-git-user-email() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  if [[ $(git config user.email) == "" ]]; then
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



# Install Homebrew
# ------------------------------------------------------------------------------
_psyrendust-procedure-install-homebrew() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  ppinfo "Checking for homebrew..."
  if [[ $(which -s brew) != 0 ]]; then
    ppdanger "Homebrew missing. Installing Homebrew..."
    # https://github.com/mxcl/homebrew/wiki/installation
    ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
  else
    ppsuccess "Homebrew already installed!"
  fi
}



# Check with brew doctor
# ------------------------------------------------------------------------------
_psyrendust-procedure-brew-doctor() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  ppinfo "Check with brew doctor"
  brew doctor
}



# Make sure we’re using the latest Homebrew
# ------------------------------------------------------------------------------
_psyrendust-procedure-latest-homebrew() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  ppinfo "Make sure we’re using the latest Homebrew"
  brew update
}



# Upgrade any already-installed formulae
# ------------------------------------------------------------------------------
_psyrendust-procedure-brew-upgrade() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  ppinfo "Upgrade any already-installed formulae"
  brew upgrade
}



# Install GNU core utilities (those that come with OS X are outdated)
# ------------------------------------------------------------------------------
_psyrendust-procedure-brew-install-coreutils() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  if [[ -n $(_brew-is-installed "coreutils") ]]; then
    ppinfo "Install GNU core utilities (those that come with OS X are outdated)"
    brew install coreutils
    ppemphasis "Don’t forget to add \$(brew --prefix coreutils)/libexec/gnubin to \$PATH"
  fi
}



# Install GNU find, locate, updatedb, and xargs, g-prefixed
# ------------------------------------------------------------------------------
_psyrendust-procedure-brew-install-findutils() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  if [[ -n $(_brew-is-installed "findutils") ]]; then
    ppinfo "Install GNU find, locate, updatedb, and xargs, g-prefixed"
    brew install findutils
  fi
}



# Install the latest Bash
# ------------------------------------------------------------------------------
_psyrendust-procedure-brew-install-bash() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  if [[ -n $(_brew-is-installed "bash") ]]; then
    ppinfo "Install the latest Bash"
    brew install bash
  fi
}



# Install the latest Zsh
# ------------------------------------------------------------------------------
_psyrendust-procedure-brew-install-zsh() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  if [[ -n $(_brew-is-installed "zsh") ]]; then
    ppinfo "Install the latest Zsh"
    brew install zsh
  fi
}



# Add bash to the allowed shells list if it's not already there
# ------------------------------------------------------------------------------
_psyrendust-procedure-bash-shells() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  ppinfo "Add bash to the allowed shells list if it's not already there"
  if [[ -z $(cat /private/etc/shells | grep "/usr/local/bin/bash") ]]; then
    sudo bash -c "echo /usr/local/bin/bash >> /private/etc/shells"
  fi
}



# Add zsh to the allowed shells list if it's not already there
# ------------------------------------------------------------------------------
_psyrendust-procedure-zsh-shells() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  ppinfo "Add zsh to the allowed shells list if it's not already there"
  if [[ -z $(cat /private/etc/shells | grep "/usr/local/bin/zsh") ]]; then
    sudo bash -c "echo /usr/local/bin/zsh >> /private/etc/shells"
  fi
}



# Change root shell to the new zsh
# ------------------------------------------------------------------------------
_psyrendust-procedure-sudo-chsh-zsh() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  ppinfo "Change root shell to the new zsh"
  sudo chsh -s /usr/local/bin/zsh
}



# Change local shell to the new zsh
# ------------------------------------------------------------------------------
_psyrendust-procedure-chsh-zsh() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  ppinfo "Change local shell to the new zsh"
  chsh -s /usr/local/bin/zsh
}



# Make sure that everything went well
# ------------------------------------------------------------------------------
_psyrendust-procedure-check-shell() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  ppinfo "Making sure that everything went well"
  ppinfo "Checking \$SHELL"
  if [[ "$SHELL" == "/usr/local/bin/zsh" ]]; then
    ppinfo "Great! Running $(zsh --version)"
  else
    ppdanger "\$SHELL is not /usr/local/bin/zsh"
    exit
  fi
}



# Install wget with IRI support
# ------------------------------------------------------------------------------
_psyrendust-procedure-brew-install-wget() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  if [[ -n $(_brew-is-installed "wget") ]]; then
    ppinfo "Install wget with IRI support"
    brew install wget --enable-iri
  fi
}



# Tap homebrew/dupes
# ------------------------------------------------------------------------------
_psyrendust-procedure-brew-tap-homebrew-dupes() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  if [[ -n $(_brew-is-tapped "homebrew/dupes") ]]; then
    ppinfo "Tap homebrew/dupes"
    ppinfo "brew tap homebrew/dupes"
    brew tap homebrew/dupes
  fi
}



# Install more recent versions of some OS X tools
# ------------------------------------------------------------------------------
_psyrendust-procedure-brew-install-grep() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  if [[ -n $(_brew-is-installed "grep") ]]; then
    ppinfo "brew install homebrew/dupes/grep --default-names"
    brew install homebrew/dupes/grep --default-names
  fi
}



# brew install ack
# ------------------------------------------------------------------------------
_psyrendust-procedure-brew-install-ack() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  if [[ -n $(_brew-is-installed "ack") ]]; then
    ppinfo "brew install ack"
    brew install ack
  fi
}



# brew install automake
# ------------------------------------------------------------------------------
_psyrendust-procedure-brew-install-automake() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  if [[ -n $(_brew-is-installed "automake") ]]; then
    ppinfo "brew install automake"
    brew install automake
  fi
}



# brew install curl-ca-bundle
# ------------------------------------------------------------------------------
_psyrendust-procedure-curl-ca-bundle() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  if [[ -n $(_brew-is-installed "curl-ca-bundle") ]]; then
    ppinfo "brew install curl-ca-bundle"
    brew install curl-ca-bundle
  fi
}



# brew install fasd
# ------------------------------------------------------------------------------
_psyrendust-procedure-brew-install-fasd() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  if [[ -n $(_brew-is-installed "fasd") ]]; then
    ppinfo "brew install fasd"
    brew install fasd
  fi
}



# brew install git
# ------------------------------------------------------------------------------
_psyrendust-procedure-brew-install-git() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  if [[ -n $(_brew-is-installed "git") ]]; then
    ppinfo "brew install git"
    brew install git
  fi
}



# brew install optipng
# ------------------------------------------------------------------------------
_psyrendust-procedure-brew-install-optipng() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  if [[ -n $(_brew-is-installed "optipng") ]]; then
    ppinfo "brew install optipng"
    brew install optipng
  fi
}



# brew install phantomjs
# ------------------------------------------------------------------------------
_psyrendust-procedure-brew-install-phantomjs() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  if [[ -n $(_brew-is-installed "phantomjs") ]]; then
    ppinfo "brew install phantomjs"
    brew install phantomjs
  fi
}



# brew install rename
# ------------------------------------------------------------------------------
_psyrendust-procedure-brew-install-rename() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  if [[ -n $(_brew-is-installed "rename") ]]; then
    ppinfo "brew install rename"
    brew install rename
  fi
}



# brew install tree
# ------------------------------------------------------------------------------
_psyrendust-procedure-brew-install-tree() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  if [[ -n $(_brew-is-installed "tree") ]]; then
    ppinfo "brew install tree"
    brew install tree
  fi
}



# Remove node if it's not installed by brew
# ------------------------------------------------------------------------------
_psyrendust-procedure-remove-node() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  # Is node installed by brew and if node is installed
  if [[ -n $(_brew-is-installed "node") ]] && [[ -z $(which node | grep "not found") ]]; then
    ppinfo "Remove node because it's not installed by brew"
    lsbom -f -l -s -pf /var/db/receipts/org.nodejs.pkg.bom | while read f; do [[ -f /usr/local/${f} ]] && sudo rm -rf /usr/local/${f}; done
    [[ -f /usr/local/lib/node ]] && sudo rm -rf /usr/local/lib/node /usr/local/lib/node_modules /var/db/receipts/org.nodejs.*
    [[ -d /usr/local/lib/node_modules ]] && sudo rm -rf /usr/local/lib/node_modules /var/db/receipts/org.nodejs.*
    [[ -f /var/db/receipts/org.nodejs.* ]] && sudo rm -rf /var/db/receipts/org.nodejs.*
  fi
}



# Remove npm
# ------------------------------------------------------------------------------
_psyrendust-procedure-remove-npm() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  # Remove npm
  if [[ -z $(which npm | grep "not found") ]]; then
    ppinfo "Remove npm: npm uninstall npm -g"
    npm uninstall npm -g
  fi
  if [[ -f "/usr/local/lib/npm" ]]; then
    ppinfo "Remove npm: rm /usr/local/lib/npm"
    rm -rf "/usr/local/lib/npm"
  fi
}



# brew install node
# ------------------------------------------------------------------------------
_psyrendust-procedure-brew-install-node() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  if [[ -n $(_brew-is-installed "node") ]]; then
    ppinfo "brew install node"
    brew install node
  fi
}



# brew install node
# ------------------------------------------------------------------------------
_psyrendust-procedure-brew-install-link-node() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  ppinfo "brew link node"
  brew link --overwrite node
}



# brew install haskell-platform
# ------------------------------------------------------------------------------
_psyrendust-procedure-brew-install-haskell() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  ppinfo "brew install haskell-platform"
  brew install haskell-platform
}



# cabal update
# ------------------------------------------------------------------------------
_psyrendust-procedure-cabal-update() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  ppinfo "cabal update"
  cabal update
}



# cabal install cabal-install
# ------------------------------------------------------------------------------
_psyrendust-procedure-cabal-install-cabal() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  ppinfo "cabal install cabal-install"
  cabal install cabal-install
}



# cabal install pandoc
# Notes: useful for converting docs
# pandoc -s -w man plog.1.md -o plog.1
# ------------------------------------------------------------------------------
_psyrendust-procedure-cabal-install-pandoc() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  ppinfo "cabal install pandoc"
  cabal install pandoc
}



# Remove outdated versions from the cellar
# ------------------------------------------------------------------------------
_psyrendust-procedure-brew-cleanup() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  ppinfo "Remove outdated versions from the cellar"
  brew cleanup
}



# # Install NVM
# # ------------------------------------------------------------------------------
# _psyrendust-procedure-install-nvm() {
#   if [[ -n $(_brew-is-installed "node") ]]; then
#     ppinfo "Install NVM"
#     curl https://raw.github.com/creationix/nvm/master/install.sh | sh
#   fi
# }



# # nvm install v0.10.25
# # ------------------------------------------------------------------------------
# _psyrendust-procedure-nvm-install() {
#   if [[ -s "$HOME/.nvm/nvm.sh" ]]; then
#     ppinfo "nvm install v0.10.25"
#     nvm install v0.10.25
#   fi
# }



# # nvm alias default 0.10.25
# # ------------------------------------------------------------------------------
# _psyrendust-procedure-nvm-default() {
#   if [[ -s "$HOME/.nvm/nvm.sh" ]]; then
#     ppinfo "nvm alias default 0.10.25"
#     nvm alias default 0.10.25
#   fi
# }



# # nvm use v0.10.25
# # ------------------------------------------------------------------------------
# _psyrendust-procedure-nvm-use() {
#   if [[ -s "$HOME/.nvm/nvm.sh" ]]; then
#     ppinfo "nvm use v0.10.25"
#     nvm use v0.10.25
#   fi
# }



# # Install npm
# # ------------------------------------------------------------------------------
# _psyrendust-procedure-install-npm() {
#   if [[ -s "$HOME/.nvm/nvm.sh" ]]; then
#     ppinfo "Install npm"
#     curl https://npmjs.org/install.sh | sh
#   fi
# }



# Cleanup old zsh dotfiles
# ------------------------------------------------------------------------------
_psyrendust-procedure-cleanup-old-dotfiles() {
  ppinfo "Cleanup old zsh dotfiles"
  rm "$HOME/.zcompdump*"
  rm "$HOME/.zlogin"
  rm "$HOME/.zsh-update"
  rm "$HOME/.zsh_history"
}



# Install oh-my-zsh
# ------------------------------------------------------------------------------
_psyrendust-procedure-install-oh-my-zsh() {
  ppinfo "Install oh-my-zsh"
  git clone https://github.com/robbyrussell/oh-my-zsh.git "$ZSH"
}



# # Clone oh-my-zsh-psyrendust if it's not already there
# # ------------------------------------------------------------------------------
# _psyrendust-procedure-install-oh-my-zsh-psyrendust() {
#   [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
#   ppinfo "Clone oh-my-zsh-psyrendust if it's not already there"
#   git clone https://github.com/psyrendust/oh-my-zsh-psyrendust.git "$HOME/.tmp-oh-my-zsh-psyrendust"
# }



# # Swap out our curled version of oh-my-zsh-psyrendust with the git version
# # ------------------------------------------------------------------------------
# _psyrendust-procedure-swap-oh-my-zsh-psyrendust() {
#   [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
#   ppinfo "Swap out our curled version of oh-my-zsh-psyrendust with the git version"
#   mv "$HOME/.oh-my-zsh-psyrendust" "$PSYRENDUST_BACKUP_FOLDER/.oh-my-zsh-psyrendust"
#   mv "$HOME/.tmp-oh-my-zsh-psyrendust" "$HOME/.oh-my-zsh-psyrendust"
# }



# Copy over template files to your home folder
# ------------------------------------------------------------------------------
_psyrendust-procedure-copy-templates() {
  ppinfo "Copy over template files to your home folder"
  [[ -f "$ZSH_CUSTOM/templates/.gemrc" ]] && cp "$ZSH_CUSTOM/templates/.gemrc" "$HOME/.gemrc"
  [[ -f "$ZSH_CUSTOM/templates/.gitignore_global" ]] && cp "$ZSH_CUSTOM/templates/.gitignore_global" "${HOME}/.gitignore_global"
  [[ -f "$ZSH_CUSTOM/templates/.zlogin" ]] && cp "$ZSH_CUSTOM/templates/.zlogin" "$HOME/.zlogin"
  [[ -f "$ZSH_CUSTOM/templates/.zprofile" ]] && cp "$ZSH_CUSTOM/templates/.zprofile" "$HOME/.zprofile"
  [[ -f "$ZSH_CUSTOM/templates/.zshenv" ]] && cp "$ZSH_CUSTOM/templates/.zshenv" "$HOME/.zshenv"
  [[ -f "$ZSH_CUSTOM/templates/.zshrc" ]] && cp "$ZSH_CUSTOM/templates/.zshrc" "$HOME/.zshrc"
  if [[ -n $SYSTEM_IS_CYGWIN ]]; then
    # Replace win .gitconfig
    [[ -s "$ZSH_CUSTOM/templates/config/git/gitconfig-win" ]] && cp "$ZSH_CUSTOM/templates/config/git/gitconfig-win" "$HOME/.gitconfig"
  else
    # Replace mac .gitconfig
    [[ -s "$ZSH_CUSTOM/templates/config/git/gitconfig-mac" ]] && cp "$ZSH_CUSTOM/templates/config/git/gitconfig-mac" "$HOME/.gitconfig"
  fi
  if [[ -n $SYSTEM_IS_VM ]]; then
    # Symlink git configs
    ln -sf "$SYSTEM_VM_HOME/.psyrendust/config/git" "$PSYRENDUST_CONFIG_BASE_PATH/config/git"
  else
    # Replace git configs
    cp "$ZSH_CUSTOM/templates/config/git/core" "$PSYRENDUST_CONFIG_BASE_PATH/config/git/core"
    cp "$ZSH_CUSTOM/templates/config/git/diff" "$PSYRENDUST_CONFIG_BASE_PATH/config/git/diff"
    cp "$ZSH_CUSTOM/templates/config/git/windows" "$PSYRENDUST_CONFIG_BASE_PATH/config/git/windows"
    if [[ -n $SYSTEM_IS_CYGWIN ]]; then
      cp "$ZSH_CUSTOM/templates/config/git/custom-win" "$PSYRENDUST_CONFIG_BASE_PATH/config/git/custom-win"
    else
      cp "$ZSH_CUSTOM/templates/config/git/custom-mac" "$PSYRENDUST_CONFIG_BASE_PATH/config/git/custom-mac"
    fi
  fi
}



# Install fonts DroidSansMono and Inconsolata
# ------------------------------------------------------------------------------
_psyrendust-procedure-install-mac-fonts() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  ppinfo "Install fonts DroidSansMono and Inconsolata"
  [[ -d "$HOME/Library/Fonts" ]] || mkdir -p "$HOME/Library/Fonts"
  cp "$ZSH_CUSTOM/fonts/DroidSansMono.ttf" "$HOME/Library/Fonts/DroidSansMono.ttf"
  cp "$ZSH_CUSTOM/fonts/Inconsolata.otf" "$HOME/Library/Fonts/Inconsolata.otf"
}



# Install fonts DroidSansMono and ErlerDingbats
# ------------------------------------------------------------------------------
_psyrendust-procedure-install-win-fonts() {
  if [[ -n $SYSTEM_IS_CYGWIN ]]; then
    ppinfo "Install fonts DroidSansMono and ErlerDingbats"
    [[ -d "/cygdrive/c/Windows/Fonts" ]] || mkdir -p "/cygdrive/c/Windows/Fonts"
    [[ -f "$HOME/.oh-my-zsh-psyrendust/fonts/win/DROIDSAM.TTF" ]] && cp "$HOME/.oh-my-zsh-psyrendust/fonts/win/DROIDSAM.TTF" "/cygdrive/c/Windows/Fonts/DROIDSAM.TTF"
    [[ -f "$HOME/.oh-my-zsh-psyrendust/fonts/win/ErlerDingbats.ttf" ]] && cp "$HOME/.oh-my-zsh-psyrendust/fonts/win/ErlerDingbats.ttf" "/cygdrive/c/Windows/Fonts/ErlerDingbats.ttf"
  fi
}



# Clone zshrc-work
# ------------------------------------------------------------------------------
_psyrendust-procedure-install-zsh-work() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  ppinfo "Clone zshrc-work"
  git clone https://github.dev.xero.com/dev-larryg/zshrc-xero.git "$ZSHRC_WORK"
}



# Install zshrc-personal starter template
# ------------------------------------------------------------------------------
_psyrendust-procedure-zshrc-personal-starter() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  ppinfo "Install zshrc-personal starter template"
  [[ -d "$ZSHRC_PERSONAL" ]] && mkdir -p "$ZSHRC_PERSONAL"
  cp "$ZSH_CUSTOM/templates/.zshrc-personal" "$ZSHRC_PERSONAL/.zshrc"
  cp "$ZSH_CUSTOM/templates/.zshrc-personal-custom" "$ZSHRC_PERSONAL/.zshrc-custom"
}



# Create post-updates
# ------------------------------------------------------------------------------
_psyrendust-procedure-create-post-update() {
  ppinfo "Create post-updates"
  [[ -f "$ZSH_CUSTOM/tools/post-update.zsh" ]] && cp "$ZSH_CUSTOM/tools/post-update.zsh" "$PSYRENDUST_CONFIG_BASE_PATH/post-update-run-once-oh-my-zsh-psyrendust.zsh"
  [[ -f "$ZSHRC_PERSONAL/tools/post-update.zsh" ]] && cp "$ZSHRC_PERSONAL/tools/post-update.zsh" "$PSYRENDUST_CONFIG_BASE_PATH/post-update-run-once-zshrc-personal.zsh"
  [[ -f "$ZSHRC_WORK/tools/post-update.zsh" ]] && cp "$ZSHRC_WORK/tools/post-update.zsh" "$PSYRENDUST_CONFIG_BASE_PATH/post-update-run-once-zshrc-work.zsh"
}



# Install iTerm2
# ------------------------------------------------------------------------------
_psyrendust-procedure-install-iterm2() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  if [[ ! -d "/Applications/iTerm.app" ]]; then
    ppinfo "Install iTerm2"
    local url="http://www.iterm2.com/downloads/stable/iTerm2_v1_0_0.zip"
    local zip="${url##http*/}"
    local download_dir="$HOME/Downloads/iterm2-$$"
    mkdir -p "$download_dir"
    curl -L "$url" -o "${download_dir}/${zip}"
    unzip -q "${download_dir}/${zip}" -d /Applications/
    rm -rf "$download_dir"
  fi
}



# Install default settings for iTerm2
# Opening Terminal.app to install iTerm.app preferences
# ------------------------------------------------------------------------------
_psyrendust-procedure-switch-to-terminal() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  if [[ "$TERM_PROGRAM" == "iTerm.app"]]; then
    ppwarning "You seem to be running this script from iTerm.app."
    ppwarning "Opening Terminal.app to install iTerm.app preferences."
    sleep 4
    osascript "$ZSH_CUSTOM/tools/bootstrap-shell-to-term.zsh"
    exit 1
  fi
}



# Assume we are in Teriminal app and install iTerm2 preferences
# ------------------------------------------------------------------------------
_psyrendust-procedure-install-iterm2-preferences() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  if [[ "$TERM_PROGRAM" == "Apple_Terminal"]]; then
    if [[ -f "$ZSH_CUSTOM/templates/com.googlecode.iterm2.plist" ]]; then
      ppinfo "Installing iTerm2 default preference and theme"
      if [[ -d "${HOME}/Library/Preferences" ]]; then
        mkdir -p "${HOME}/Library/Preferences"
      fi
      cp "$ZSHRC_PERSONAL/templates/com.googlecode.iterm2.plist" "${HOME}/Library/Preferences/com.googlecode.iterm2.plist"
    fi
  fi
}



# Open iTerm2 to pick up where we left off
# ------------------------------------------------------------------------------
_psyrendust-procedure-switch-to-iterm2() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  if [[ "$TERM_PROGRAM" == "Apple_Terminal"]]; then
    ppwarning "You seem to be running this script from Terminal.app."
    ppwarning "Opening iTerm.app to pick up where we left off."
    sleep 4
    osascript "$ZSH_CUSTOM/tools/bootstrap-shell-to-iterm.zsh"
    exit 1
  fi
}



# Install a default hosts file
# ------------------------------------------------------------------------------
_psyrendust-procedure-install-hosts-file() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  if [[ $psyrendust_replace_hosts_file = [Yy] ]]; then
    ppinfo 'install a default hosts file'
    sudo cp "$ZSHRC_WORK/templates/hosts" "/etc/hosts"
  fi
}



# add some automount sugar for Parallels
# ------------------------------------------------------------------------------
_psyrendust-procedure-automount-sugar-for-parallels() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  [[ -n $SYSTEM_IS_LINUX ]] && return # Exit if we are in Linux
  ppquestion "Would you like to replace your /etc/auto_smb file with a new one [y/n]: "
  read replaceautosmbfile

  if [[ $replaceautosmbfile = [Yy] ]]; then
    ppinfo 'add some automount sugar for Parallels'
    sudo cp "$ZSHRC_WORK/templates/auto_master" "/private/etc/auto_master"
    sudo cp "$ZSHRC_WORK/templates/auto_smb" "/private/etc/auto_smb"
  fi
}



# let's do some admin type stuff
# add myself to wheel group
# ------------------------------------------------------------------------------
_psyrendust-procedure-add-user-to-wheel() {
  if [[ -n $SYSTEM_IS_MAC ]]; then
    ppinfo "add myself to wheel group"
    sudo dseditgroup -o edit -a $(echo $USER) -t user wheel
  fi
}



# Change ownership of /usr/local
# ------------------------------------------------------------------------------
_psyrendust-procedure-change-ownership-of-usr-local() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  ppinfo "Change ownership of /usr/local"
  sudo chown -R $(echo $USER):staff /usr/local
}



# https://rvm.io
# Install rvm, latest stable ruby, and rails
# ------------------------------------------------------------------------------
_psyrendust-procedure-install-rvm() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  if [[ -z $PSYRENDUST_HAS_RVM ]]; then
    ppinfo "Install rvm, latest stable ruby, and rails"
    curl -sSL https://get.rvm.io | bash -s stable --rails
  fi
}



# To start using RVM you need to run `source "/Users/$USER/.rvm/scripts/rvm"`
# in all your open shell windows, in rare cases you need to reopen all shell windows.
# sourcing rvm
# ------------------------------------------------------------------------------
_psyrendust-procedure-sourcing-rvm() {
  [[ -n $SYSTEM_IS_CYGWIN ]] && return # Exit if we are in Cygwin
  if [[ -f "$HOME/.rvm/scripts/rvm" ]]; then
    ppinfo "sourcing rvm"
    source "$HOME/.rvm/scripts/rvm"
  fi
}



# Update rvm
# ------------------------------------------------------------------------------
_psyrendust-procedure-rvm-get-stable() {
  [[ -n $SYSTEM_IS_CYGWIN ]] && return # Exit if we are in Cygwin
  ppinfo 'Update rvm'
  rvm get stable
}
_psyrendust-procedure-rvm-reload() {
  [[ -n $SYSTEM_IS_CYGWIN ]] && return # Exit if we are in Cygwin
  ppinfo 'Reload the updated version of rvm'
  rvm reload
}
_psyrendust-procedure-rvm-install-ruby() {
  [[ -n $SYSTEM_IS_CYGWIN ]] && return # Exit if we are in Cygwin
  if [[ -n $PSYRENDUST_HAS_RVM ]]; then
    ppinfo 'rvm install 2.1.1'
    rvm install 2.1.1
  fi
}
_psyrendust-procedure-rvm-default() {
  [[ -n $SYSTEM_IS_CYGWIN ]] && return # Exit if we are in Cygwin
  if [[ -n $PSYRENDUST_HAS_RVM ]]; then
    ppinfo 'rvm --default 2.1.1'
    rvm --default 2.1.1
  fi
}
_psyrendust-procedure-rvm-cleanup() {
  [[ -n $SYSTEM_IS_CYGWIN ]] && return # Exit if we are in Cygwin
  ppinfo 'rvm cleanup all'
  rvm cleanup all
}



# Check ruby version
# ------------------------------------------------------------------------------
_psyrendust-procedure-check-ruby-version() {
  ppinfo 'which ruby and version'
  ruby -v
  which ruby
}



# Load up gem helper function
# ------------------------------------------------------------------------------
psyrendust source --cygwin "$ZSH_CUSTOM/tools/init-post-settings.zsh"



# Update and install some gems
# ------------------------------------------------------------------------------
_psyrendust-procedure-gem-update() {
  ppinfo 'gem update --system'
  gem update --system
}
_psyrendust-procedure-gem-install-rails() {
  ppinfo 'gem install rails'
  gem install rails
}
_psyrendust-procedure-gem-install-bundler() {
  ppinfo 'gem install bundler'
  gem install bundler
}
_psyrendust-procedure-gem-install-compass() {
  ppinfo 'gem install compass --pre'
  gem install compass --pre
}
_psyrendust-procedure-gem-install-sass() {
  ppinfo 'gem install sass --pre'
  gem install sass --pre
}



# Install bower
# ------------------------------------------------------------------------------
_psyrendust-procedure-npm-install-bower() {
  ppinfo "Install bower"
  npm install -g bower
}



# Install jshint
# ------------------------------------------------------------------------------
_psyrendust-procedure-npm-install-jshint() {
  ppinfo "Install jshint"
  npm install -g jshint
}



# Install grunt-init
# ------------------------------------------------------------------------------
_psyrendust-procedure-npm-install-grunt-init() {
  ppinfo "Install grunt-init"
  npm install -g grunt-init
}



# Install grunt-cli
# ------------------------------------------------------------------------------
_psyrendust-procedure-npm-install-grunt-cli() {
  ppinfo "Install grunt-cli"
  npm install -g grunt-cli
}



# Remove all grunt-init plugins and start over
# ------------------------------------------------------------------------------
_psyrendust-procedure-remove-grunt-init-plugins() {
  ppinfo "Remove all grunt-init plugins and start over"
  if [[ -d "$HOME/.grunt-init" ]]; then
    gruntinitplugins=$(ls "$HOME/.grunt-init")
    for i in ${gruntinitplugins[@]}
    do
      rm -rf "$HOME/.grunt-init/$i"
    done
  else
    mkdir "$HOME/.grunt-init"
  fi
}



# Add gruntfile plugin for grunt-init
# ------------------------------------------------------------------------------
_psyrendust-procedure-add-grunt-init-gruntfile() {
  ppinfo "Add gruntfile plugin for grunt-init"
  git clone https://github.com/gruntjs/grunt-init-gruntfile.git "${HOME}/.grunt-init/gruntfile"
}



# Add commonjs plugin for grunt-init
# ------------------------------------------------------------------------------
_psyrendust-procedure-add-grunt-init-commonjs() {
  ppinfo "Add commonjs plugin for grunt-init"
  git clone https://github.com/gruntjs/grunt-init-commonjs.git "${HOME}/.grunt-init/commonjs"
}



# Add gruntplugin plugin for grunt-init
# ------------------------------------------------------------------------------
_psyrendust-procedure-add-grunt-init-gruntplugin() {
  ppinfo "Add gruntplugin plugin for grunt-init"
  git clone https://github.com/gruntjs/grunt-init-gruntplugin.git "${HOME}/.grunt-init/gruntplugin"
}



# Add jquery plugin for grunt-init
# ------------------------------------------------------------------------------
_psyrendust-procedure-add-grunt-init-jquery() {
  ppinfo "Add jquery plugin for grunt-init"
  git clone https://github.com/gruntjs/grunt-init-jquery.git "${HOME}/.grunt-init/jquery"
}



# Add node plugin for grunt-init
# ------------------------------------------------------------------------------
_psyrendust-procedure-add-grunt-init-node() {
  ppinfo "Add node plugin for grunt-init"
  git clone https://github.com/gruntjs/grunt-init-node.git "${HOME}/.grunt-init/node"
}



# Install easy_install
# ------------------------------------------------------------------------------
_psyrendust-procedure-install-easy-install() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  if [[ -n $(which easy_install 2>&1 | grep "not found") ]]; then
    ppinfo 'Install easy_install'
    curl http://peak.telecommunity.com/dist/ez_setup.py | python
  fi
}



# for the c alias (syntax highlighted cat)
# ------------------------------------------------------------------------------
_psyrendust-procedure-install-pygments() {
  ppinfo 'Installing Pygments for the c alias (syntax highlighted cat)'
  if [[ -n $SYSTEM_IS_VM ]]; then
    easy_install Pygments
  else
    sudo easy_install Pygments
  fi
}



# Installing pip
# ------------------------------------------------------------------------------
_psyrendust-procedure-install-pip() {
  if [[ -n $SYSTEM_IS_VM ]]; then
    if [[ ! -s "/usr/bin/pip" ]]; then
      ppinfo "Installing pip"
      easy_install pip
    fi
  else
    if [[ ! -s "/usr/local/bin/pip" ]]; then
      ppinfo "Installing pip"
      sudo easy_install pip
    fi
  fi
}



# Installing sciinema https://asciinema.org/
# ------------------------------------------------------------------------------
_psyrendust-procedure-install-asciinema() {
  [[ -n $SYSTEM_IS_VM ]] && return # Exit if we are in a VM
  if [[ ! -s "/usr/local/bin/asciinema" ]]; then
    ppinfo 'Installing asciinema https://asciinema.org/'
    sudo pip install --upgrade asciinema
  fi
}



# All done
# ------------------------------------------------------------------------------
_psyrendust-procedure-all-done() {
  /usr/bin/env zsh
  ppsuccess "We are all done!"
  ppemphasis ""
  ppemphasis "**************************************************"
  ppemphasis "**************** Don't forget to: ****************"
  ppemphasis "1. Setup your Parallels VM to autostart on login."
  ppemphasis "2. Set Parallels Shared Network DHCP Settings."
  ppemphasis "   Start Address: 1.2.3.1"
  ppemphasis "   End Address  : 1.2.3.254"
  ppemphasis "   Subnet Mask  : 255.255.255.0"
  ppemphasis "**************************************************"
  ppemphasis ""
  ppemphasis "**************************************************"
  ppemphasis "***** You should restart your computer now. ******"
  ppemphasis "**************************************************"
}



# ------------------------------------------------------------------------------
# Get down to business
# ------------------------------------------------------------------------------
# Ask for the administrator password upfront
# ------------------------------------------------------------------------------
if [[ -n $SYSTEM_IS_MAC ]]; then
  ppinfo "Ask for the administrator password upfront"
  sudo -v



  # Keep-alive: update existing `sudo` time stamp until
  # `bootstrap-shell.zsh` has finished
  # ----------------------------------------------------------------------------
  ppinfo "Keep-alive: update existing `sudo` time stamp until `bootstrap-shell.zsh` has finished"
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &



  # Exporting /usr/local/bin to path
  # ----------------------------------------------------------------------------
  if [[ "$(echo $PATH)" != */usr/local/bin* ]]; then
    ppinfo "Adding /usr/local/bin to path"
    export PATH="/usr/local/bin:${PATH}"
  fi
fi



# See if RVM is installed
# ------------------------------------------------------------------------------
if [[ -f "$HOME/.rvm/scripts/rvm" ]]; then
  export PSYRENDUST_HAS_RVM=1
fi



# Sourcing helper script to call all procedure functions in this script
# ------------------------------------------------------------------------------
# Includes pretty-print helpers
#  ppsuccess - green
#     ppinfo - light cyan
#  ppwarning - brown
#   ppdanger - red
# ppemphasis - purple
#  ppverbose - prints out message if PRETTY_PRINT_IS_VERBOSE="true"
# ------------------------------------------------------------------------------
if [[ -s "$ZSH_CUSTOM/tools/psyrendust-procedure-init.zsh" ]]; then
  source "$ZSH_CUSTOM/tools/psyrendust-procedure-init.zsh" $0
fi
