# Here is some bash kung-fu to try and get
# your environment updated and migrated
# ----------------------------------------------------------


# Helper functions
# ----------------------------------------------------------
function cleanup() {
  # check if it's dirty and reset it back to HEAD
  if [[ -n $(git diff --ignore-submodules HEAD) ]]; then
    git reset HEAD --hard
  fi
}

function updaterepo() {
  cd $1
  cleanup
  if git pull --rebase origin master; then
    echo "Updated $1"
  fi
}

# Get down to business
# ----------------------------------------------------------

# Grab some user info
# ----------------------------------------------------------
echo "Please enter your first and last name [First Last]: "
read gitusername
echo "Please enter your work email address [first.last@xero.com]: "
read gituseremail
echo "Would you like to replace your hosts file with a new one [y/n]: "
read replacehostsfile

# Backup your current configuration stuff in
# "${HOME}/.zshrc-personal/backup/".
# ----------------------------------------------------------
mkdir -p "${HOME}/.zshrc-personal/backup"
[[ -s "${HOME}/.gemrc" ]] && cp "${HOME}/.gemrc" "${HOME}/.zshrc-personal/backup/.gemrc"
[[ -s "${HOME}/.gitconfig" ]] && cp "${HOME}/.gitconfig" "${HOME}/.zshrc-personal/backup/.gitconfig"
[[ -s "${HOME}/.gitignore_global" ]] && cp "${HOME}/.gitignore_global" "${HOME}/.zshrc-personal/backup/.gitignore_global"
[[ -s "${HOME}/.zshrc" ]] && cp "${HOME}/.zshrc" "${HOME}/.zshrc-personal/backup/.zshrc"
[[ -s "/etc/hosts" ]] && cp "/etc/hosts" "${HOME}/.zshrc-personal/backup/hosts"
[[ -s "/etc/auto_master" ]] && cp "/etc/auto_master" "${HOME}/.zshrc-personal/backup/auto_master"
[[ -s "/etc/auto_smb" ]] && cp "/etc/auto_smb" "${HOME}/.zshrc-personal/backup/auto_smb"


# Let's cleanup our homebrew install and clear out
# the Cellar
# ----------------------------------------------------------
if [[ -s $(which -s brew) ]]; then
  cd `brew --prefix`
  rm -rf Cellar
  brew prune
  rm `git ls-files`
  rm -r Library/Homebrew Library/Aliases Library/Formula Library/Contributions
  rm -rf .git
  rm -rf ~/Library/Caches/Homebrew
fi

# Install homebrew and all of it's dependencies again
# ----------------------------------------------------------
ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
brew install coreutils findutils bash zsh ack automake curl-ca-bundle fasd git optipng phantomjs rename tree
brew install wget --enable-iri
brew tap homebrew/dupes
brew install homebrew/dupes/grep --default-names
brew cleanup

# Change root and user shell to the new zsh
# ----------------------------------------------------------
sudo chsh -s /usr/local/bin/zsh
chsh -s /usr/local/bin/zsh

# a little cleanup
# ----------------------------------------------------------
rm ~/.zcompdump*;
rm ~/.zlogin;
rm ~/.zsh-update;
rm ~/.zsh_history;
rm ~/NUL;

# Update oh-my-zsh
# ----------------------------------------------------------
updaterepo "${HOME}/.oh-my-zsh"

# Update oh-my-zsh-psyrendust
# ----------------------------------------------------------
updaterepo "${HOME}/.oh-my-zsh-psyrendust"

# Copy over template files to your home folder
# ----------------------------------------------------------
cp "${HOME}/.oh-my-zsh-psyrendust/templates/zshrc.zsh-template" "${HOME}/.zshrc";
cp "${HOME}/.oh-my-zsh-psyrendust/templates/gemrc.zsh-template" "${HOME}/.gemrc";
cp "${HOME}/.oh-my-zsh-psyrendust/templates/gitconfig.template" "${HOME}/.gitconfig";
cp "${HOME}/.oh-my-zsh-psyrendust/templates/gitignore_global.template" "${HOME}/.gitignore_global";

# Set Git user info
# ----------------------------------------------------------
git config --global user.name $gitusername
git config --global user.email $gituseremail

# Copy over fonts
# ----------------------------------------------------------
[[ -d "${HOME}/Library/Fonts" ]] || mkdir -p "${HOME}/Library/Fonts"
cp "${HOME}/.oh-my-zsh-psyrendust/fonts/." "${HOME}/Library/Fonts/"

# install the pure theme
# ----------------------------------------------------------
git clone https://github.com/sindresorhus/pure.git ~/.pure-theme;

# symlink the pure theme to our oh-my-zsh-psyrendust custom theme folder
# ----------------------------------------------------------
ln -sf ~/.pure-theme/pure.zsh ~/.oh-my-zsh-psyrendust/themes/pure.zsh-theme;

# install zshrc-work
# ----------------------------------------------------------
git clone https://github.dev.xero.com/dev-larryg/zshrc-xero.git ~/.zshrc-work;

source ~/.zshrc

# Remove all grunt-init plugins and start over
# ----------------------------------------------------------
if [[ -d "${HOME}/.grunt-init" ]]; then
  gruntinitplugins=$(ls "${HOME}/.grunt-init");
  for i in ${gruntinitplugins[@]}
  do
    rm -rf "${HOME}/.grunt-init/$i";
  done
fi
git clone https://github.com/gruntjs/grunt-init-gruntfile.git "${HOME}/.grunt-init/gruntfile";
git clone https://github.com/gruntjs/grunt-init-commonjs.git "${HOME}/.grunt-init/commonjs";
git clone https://github.com/gruntjs/grunt-init-gruntplugin.git "${HOME}/.grunt-init/gruntplugin";
git clone https://github.com/gruntjs/grunt-init-jquery.git "${HOME}/.grunt-init/jquery";
git clone https://github.com/gruntjs/grunt-init-node.git "${HOME}/.grunt-init/node";

# install zshrc-personal starter template
# ----------------------------------------------------------
cp "${HOME}/.oh-my-zsh-psyrendust/templates/zshrc-personal.zsh-template" "${HOME}/.zshrc-personal/.zshrc";

# install a default hosts file
# ----------------------------------------------------------
sudo cp "${HOME}/.zshrc-work/templates/hosts" "/etc/hosts";

# add some automount sugar for Parallels
# ----------------------------------------------------------
sudo cp "${HOME}/.zshrc-work/templates/auto_master" "/private/etc/auto_master";
sudo cp "${HOME}/.zshrc-work/templates/auto_smb" "/private/etc/auto_smb";

source "${HOME}/.zshrc";

# let's do some admin type stuff
# add myself to wheel group
# ----------------------------------------------------------
sudo dseditgroup -o edit -a $(echo $USER) -t user wheel;

# Change ownership of /usr/local
# ----------------------------------------------------------
sudo chown -R $(echo $USER):admin /usr/local;

# install a default hosts file
# ----------------------------------------------------------
if [[ $replacehostsfile == "y" || $replacehostsfile == "Y" ]]; then
  sudo cp ~/.zshrc-work/templates/hosts /etc/hosts;
fi

# for the c alias (syntax highlighted cat)
# ----------------------------------------------------------
sudo easy_install Pygments;

# source .zshrc file and reap the benefits
# ----------------------------------------------------------
source "${HOME}/.zshrc";

# run some of our update scripts
# ----------------------------------------------------------
forceupdate && npmupdate;

# run some of our update scripts
# ----------------------------------------------------------
# If we are using ruby 2.0.0pxxx skip it
rvm get stable;               # Update rvm
rvm reload;                   # Reload the updated version of rvm
rvm install 2.0.0;
rvm --default 2.0.0
ruby -v;
which ruby;
gem update --system;
gem install rails;
gem install bundler;
gem install compass -v 1.0.0.alpha.13;
gem install sass -v 3.3.0.rc2;

rvm cleanup all;

# All done
# ----------------------------------------------------------
source "${HOME}/.zshrc";

echo "We are all done."
echo "You should restart your computer now."
