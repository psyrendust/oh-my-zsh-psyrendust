# name: shell-bootstrap.sh
# version: 1.0.0
# author: Larry Gordon
#
# My starter script for bootstraping your shell environment!
#
# It's up to (you|me) if you want to exec this file or copy
# paste each command at your leisure

if [[ "$(echo $PATH)" != */usr/local/bin* ]]; then
  export PATH="/usr/local/bin:${PATH}"
fi

# Check and see if node is installed.
if [[ -s /usr/local/bin/node ]]; then
  echo "Great, you have node installed!"
else
  # Node is not installed send the user to go install it
  echo "You don't have node installed!"
  echo "Press [ENTER] to open your browser to get the installer. Then return here and run this script again."
  open "http://nodejs.org/download/"
  exit
fi

echo "Checking for homebrew"
# Install Homebrew
if [[ $(which -s brew) != 0 ]]; then
    echo "Homebrew missing"
    # Install Homebrew
    # https://github.com/mxcl/homebrew/wiki/installation
    ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
else
    echo "Homebrew installed"
    # Make sure we’re using the latest Homebrew
    brew update
    # Upgrade any already-installed formulae
    brew upgrade
fi

# Install GNU core utilities (those that come with OS X are outdated)
brew install coreutils
# Don’t forget to add $(brew --prefix coreutils)/libexec/gnubin to $PATH.

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils
# Install the latest Bash and Zsh
brew install bash zsh
# Add it to the allowed shells list
sudo bash -c "echo /usr/local/bin/bash >> /private/etc/shells"
sudo bash -c "echo /usr/local/bin/zsh >> /private/etc/shells"
# Change root shell to the new zsh
sudo chsh -s /usr/local/bin/zsh

# Make sure that everything went well
echo "SHELL: $SHELL";
echo "$BASH_VERSION";
echo $(zsh --version);

# Install wget with IRI support
brew install wget --enable-iri

# Install more recent versions of some OS X tools
brew tap homebrew/dupes && brew install homebrew/dupes/grep --default-names

# Install everything else
brew install ack automake curl-ca-bundle fasd git optipng phantomjs rename tree

# Remove outdated versions from the cellar
brew cleanup

# Setup your zsh prompt and plugins
# a little cleanup
rm ~/.zcompdump*;
rm ~/.zlogin;
rm ~/.zsh-update;
rm ~/.zsh_history;

# install oh-my-zsh
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh;
chsh -s /usr/local/bin/zsh;

# install some oh-my-zsh extras
git clone https://github.com/psyrendust/oh-my-zsh-psyrendust.git ~/.oh-my-zsh-psyrendust;
cp ~/.oh-my-zsh-psyrendust/templates/zshrc.zsh-template ~/.zshrc;
cp ~/.oh-my-zsh-psyrendust/templates/gemrc.zsh-template ~/.gemrc;
cp ~/.oh-my-zsh-psyrendust/templates/gitconfig.template ~/.gitconfig;
cp ~/.oh-my-zsh-psyrendust/templates/gitignore_global.template ~/.gitignore_global;

# install the pure theme
git clone https://github.com/sindresorhus/pure.git ~/.pure-theme;

# symlink the pure theme to our oh-my-zsh-psyrendust custom theme folder
ln -sf ~/.pure-theme/pure.zsh ~/.oh-my-zsh-psyrendust/themes/pure.zsh-theme;

# install zshrc-work
git clone https://github.dev.xero.com/dev-larryg/zshrc-xero.git ~/.zshrc-work;

# install zshrc-personal starter template
mkdir ~/.zshrc-personal
cp ~/.oh-my-zsh-psyrendust/templates/zshrc-personal.zsh-template ~/.zshrc-personal/.zshrc

# install iTerm2
#
# install the tomorrow-theme for iTerm2
# git clone https://github.com/chriskempson/tomorrow-theme.git ~/.tomorrow-theme;
# try to do some applescript kung-fu to auto install the theme into iTerm2

# install a default hosts file
sudo cp ~/.zshrc-work/templates/hosts /etc/hosts;

# add some automount sugar for Parallels
sudo cp ~/.zshrc-work/templates/auto_master /private/etc/auto_master;
sudo cp ~/.zshrc-work/templates/auto_smb /private/etc/auto_smb;

source ~/.zshrc

# let's do some admin type stuff
# add myself to wheel group
sudo dseditgroup -o edit -a $(echo $USER) -t user wheel

# Change ownership of /usr/local
sudo chown -R $(echo $USER):admin /usr/local

# https://rvm.io
# rvm for the rubiess
curl -L https://get.rvm.io | bash -s stable --ruby;

# To start using RVM you need to run `source "/Users/$USER/.rvm/scripts/rvm"`
# in all your open shell windows, in rare cases you need to reopen all shell windows.
source ~/.zshrc

rvm install 2.0.0;
rvm --default 2.0.0
ruby -v;
which ruby;
gem install rails;

# Install Compass
# http://compass-style.org/install/
gem update --system;
gem install bundler;
gem install compass -v 1.0.0.alpha.13;
gem install sass -v 3.3.0.rc2;

# install nvm "Node Version Manager"
# curl https://raw.github.com/creationix/nvm/master/install.sh | sh;

# Start using nvm without needing to reopen all shell windows.
# [[ -s "$HOME/.nvm/nvm.sh" ]] && . "$HOME/.nvm/nvm.sh";

# install the latest version of node
# nvm install v0.10.18;
# nvm alias default 0.10.18;
# nvm use v0.10.18;

# install npm
# curl https://npmjs.org/install.sh | sh;

# install Bower, jshint, and Grunt Init
npm install -g bower grunt-init grunt-cli jshint;

# install some templates
mkdir ~/.grunt-init;
git clone https://github.com/gruntjs/grunt-init-gruntfile.git ~/.grunt-init/gruntfile;
git clone https://github.com/gruntjs/grunt-init-commonjs.git ~/.grunt-init/commonjs;
git clone https://github.com/gruntjs/grunt-init-gruntplugin.git ~/.grunt-init/gruntplugin;
git clone https://github.com/gruntjs/grunt-init-jquery.git ~/.grunt-init/jquery;
git clone https://github.com/gruntjs/grunt-init-node.git ~/.grunt-init/node;

# for the c alias (syntax highlighted cat)
sudo easy_install Pygments;

source ~/.zshrc

echo "Don't forget to:"
echo "1. Setup Parallels to autostart on login."
echo "2. Set Parallels Shared Network DHCP Settings."
echo "   Start Address: 1.2.3.1"
echo "   End Address  : 1.2.3.254"
echo "   Subnet Mask  : 255.255.255.0"
echo "Restart your computer now."
