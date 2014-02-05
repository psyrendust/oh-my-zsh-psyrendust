# name: bootstrap-win-shell.sh
# author: Larry Gordon
#
# My starter script for bootstraping your shell environment!
#
# It's up to (you|me) if you want to exec this file or copy
# paste each command at your leisure

if [[ "$(echo $PATH)" != */usr/local/bin* ]]; then
  export PATH="/usr/local/bin:${PATH}";
fi

# Check and see if node is installed.
if [[ -s /usr/local/bin/node ]]; then
  echo "Great, you have node installed!";
else
  # Node is not installed send the user to go install it
  echo "You don't have node installed!";
  echo "Press [ENTER] to open your browser to get the installer. Then return here and run this script again.";
  read youneednode;
  open "http://nodejs.org/download/";
  exit;
fi

# Setup your zsh prompt and plugins
# a little cleanup
rm "${HOME}/.zcompdump*";
rm "${HOME}/.zlogin";
rm "${HOME}/.zsh-update";
rm "${HOME}/.zsh_history";

source "${HOME}/.zshrc";

# install oh-my-zsh
git clone https://github.com/robbyrussell/oh-my-zsh.git "${HOME}/.oh-my-zsh";
chsh -s /usr/local/bin/zsh;

# install some oh-my-zsh extras
git clone https://github.com/psyrendust/oh-my-zsh-psyrendust.git "${HOME}/.oh-my-zsh-psyrendust";
cp "${HOME}/.oh-my-zsh-psyrendust/templates/.zshrc" "${HOME}/.zshrc";
cp "${HOME}/.oh-my-zsh-psyrendust/templates/.gemrc" "${HOME}/.gemrc";
cp "${HOME}/.oh-my-zsh-psyrendust/templates/.gitconfig_win" "${HOME}/.gitconfig";
cp "${HOME}/.oh-my-zsh-psyrendust/templates/.gitignore_global" "${HOME}/.gitignore_global";

# Copy over fonts
[[ -d "/cygdrive/c/Windows/Fonts" ]] || mkdir -p "${HOME}/Library/Fonts"
cp "${HOME}/.oh-my-zsh-psyrendust/fonts/DroidSansMono.ttf" "/cygdrive/c/Windows/Fonts/DroidSansMono.ttf"
cp "${HOME}/.oh-my-zsh-psyrendust/fonts/Inconsolata.otf" "/cygdrive/c/Windows/Fonts/Inconsolata.otf"

# install the pure theme
git clone https://github.com/sindresorhus/pure.git "${HOME}/.pure-theme";

# symlink the pure theme to our oh-my-zsh-psyrendust custom theme folder
ln -sf "${HOME}/.pure-theme/pure.zsh" "${HOME}/.oh-my-zsh-psyrendust/themes/pure.zsh-theme";

source "${HOME}/.zshrc";

# install zshrc-work
git clone https://github.dev.xero.com/dev-larryg/zshrc-xero.git "${HOME}/.zshrc-work";

# install zshrc-personal starter template
mkdir "${HOME}/.zshrc-personal";
cp "${HOME}/.oh-my-zsh-psyrendust/templates/zshrc-personal.template" "${HOME}/.zshrc-personal/.zshrc";

# install iTerm2
#
# install the tomorrow-theme for iTerm2
# git clone https://github.com/chriskempson/tomorrow-theme.git "${HOME}/.tomorrow-theme";
# try to do some applescript kung-fu to auto install the theme into iTerm2

# install a default hosts file
sudo cp "${HOME}/.zshrc-work/templates/hosts" "/etc/hosts";

# add some automount sugar for Parallels
sudo cp "${HOME}/.zshrc-work/templates/auto_master" "/private/etc/auto_master";
sudo cp "${HOME}/.zshrc-work/templates/auto_smb" "/private/etc/auto_smb";

source "${HOME}/.zshrc";

# let's do some admin type stuff
# add myself to wheel group
# sudo dseditgroup -o edit -a $(echo $USER) -t user wheel;

# Change ownership of /usr/local
# sudo chown -R $(echo $USER):staff /usr/local;


# To start using RVM you need to run `source "/Users/$USER/.rvm/scripts/rvm"`
# in all your open shell windows, in rare cases you need to reopen all shell windows.
source "${HOME}/.zshrc";

# Download the RubyGems tarball from Ruby Forge
# Unpack the tarball
# In a bash terminal, navigate to the unpacked directory
# Run the following command:
ruby setup.rb install
# Update RubyGems by running the following:
gem update --system;
gem install rails;
gem install bundler;
gem install compass -v 1.0.0.alpha.13;
gem install sass -v 3.3.0.rc2;

rvm cleanup all;

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
mkdir "${HOME}/.grunt-init";
git clone https://github.com/gruntjs/grunt-init-gruntfile.git "${HOME}/.grunt-init/gruntfile";
git clone https://github.com/gruntjs/grunt-init-commonjs.git "${HOME}/.grunt-init/commonjs";
git clone https://github.com/gruntjs/grunt-init-gruntplugin.git "${HOME}/.grunt-init/gruntplugin";
git clone https://github.com/gruntjs/grunt-init-jquery.git "${HOME}/.grunt-init/jquery";
git clone https://github.com/gruntjs/grunt-init-node.git "${HOME}/.grunt-init/node";

# for the c alias (syntax highlighted cat)
sudo easy_install Pygments;

source "${HOME}/.zshrc"

echo "Don't forget to:";
echo "1. Setup Parallels to autostart on login.";
echo "2. Set Parallels Shared Network DHCP Settings.";
echo "   Start Address: 1.2.3.1";
echo "   End Address  : 1.2.3.254";
echo "   Subnet Mask  : 255.255.255.0";
echo "Restart your computer now.";
