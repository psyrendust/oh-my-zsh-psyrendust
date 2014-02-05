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
printf '\033[0;32m%s\033[0m\n' 'Grab some user info'
echo "Please enter your first and last name [First Last]: "
read git-user-name-first git-user-name-last
echo "Please enter your work email address [first.last@xero.com]: "
read git-user-email
echo "Would you like to replace your hosts file with a new one [y/n]: "
read replacehostsfile

# Backup your current configuration stuff in
# "${HOME}/.zshrc-personal/backup/".
# ----------------------------------------------------------
printf '\033[0;32m%s\033[0m\n' 'Backup your current configuration stuff'
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
printf '\033[0;32m%s\033[0m\n' 'Cleanup homebrew'
if [[ -s $(which brew) ]]; then
  cd `brew --prefix`
  brewfiles=$(git ls-files -z)
  rm -rf Cellar
  bin/brew prune
  rm $($brewfiles | awk '{print $1}')
  [[ -d Library/Homebrew ]] && rm -r Library/Homebrew
  [[ -d Library/Aliases ]] && rm -r Library/Aliases
  [[ -d Library/Formula ]] && rm -r Library/Formula
  [[ -d Library/Contributions ]] && rm -r Library/Contributions
  test -d Library/LinkedKegs && rm -r Library/LinkedKegs
  rmdir -p bin Library share/man/man1 2> /dev/null
  [[ -d .git ]] && rm -rf .git
  [[ -d ~/Library/Caches/Homebrew ]] && rm -rf ~/Library/Caches/Homebrew
  [[ -d ~/Library/Logs/Homebrew ]] && rm -rf ~/Library/Logs/Homebrew
  [[ -d /Library/Caches/Homebrew ]] && rm -rf /Library/Caches/Homebrew
fi

# Install homebrew and all of it's dependencies again
# ----------------------------------------------------------
printf '\033[0;32m%s\033[0m\n' 'Install homebrew'
ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)";
brew install coreutils findutils bash zsh ack automake curl-ca-bundle fasd git optipng phantomjs rename tree python;
brew install wget --enable-iri;
brew tap homebrew/dupes;
brew install homebrew/dupes/grep --default-names;
brew cleanup;

# Change root and user shell to the new zsh
# ----------------------------------------------------------
printf '\033[0;32m%s\033[0m\n' 'Changing shell'
sudo chsh -s /usr/local/bin/zsh
chsh -s /usr/local/bin/zsh

# a little cleanup
# ----------------------------------------------------------
printf '\033[0;32m%s\033[0m\n' 'A little cleanup'
rm ~/.zcompdump*;
rm ~/.zlogin;
rm ~/.zsh-update;
rm ~/.zsh_history;
rm ~/NUL;

# Update oh-my-zsh
# ----------------------------------------------------------
printf '\033[0;32m%s\033[0m\n' 'Update oh-my-zsh'
updaterepo "${HOME}/.oh-my-zsh"

# Update oh-my-zsh-psyrendust
# ----------------------------------------------------------
printf '\033[0;32m%s\033[0m\n' 'Update oh-my-zsh-psyrendust'
updaterepo "${HOME}/.oh-my-zsh-psyrendust"

# Copy over template files to your home folder
# ----------------------------------------------------------
printf '\033[0;32m%s\033[0m\n' 'Copy over template files to your home folder'
cp "${HOME}/.oh-my-zsh-psyrendust/templates/zshrc.template" "${HOME}/.zshrc";
cp "${HOME}/.oh-my-zsh-psyrendust/templates/gemrc.template" "${HOME}/.gemrc";
cp "${HOME}/.oh-my-zsh-psyrendust/templates/gitconfig.template" "${HOME}/.gitconfig";
cp "${HOME}/.oh-my-zsh-psyrendust/templates/gitignore_global.template" "${HOME}/.gitignore_global";

# Set Git user info
# ----------------------------------------------------------
printf '\033[0;32m%s\033[0m\n' 'Set Git user info'
git config --global user.name "${git-user-name-first} ${git-user-name-last}"
git config --global user.email "${git-user-email}"

# Copy over fonts
# ----------------------------------------------------------
printf '\033[0;32m%s\033[0m\n' 'Copy over fonts'
[[ -d "${HOME}/Library/Fonts" ]] || mkdir -p "${HOME}/Library/Fonts"
cp "${HOME}/.oh-my-zsh-psyrendust/fonts/DroidSansMono.ttf" "${HOME}/Library/Fonts/DroidSansMono.ttf"
cp "${HOME}/.oh-my-zsh-psyrendust/fonts/Inconsolata.otf" "${HOME}/Library/Fonts/Inconsolata.otf"

# install the pure theme
# ----------------------------------------------------------
printf '\033[0;32m%s\033[0m\n' 'Install the pure theme'
git clone https://github.com/sindresorhus/pure.git ~/.pure-theme;

# symlink the pure theme to our oh-my-zsh-psyrendust custom theme folder
# ----------------------------------------------------------
printf '\033[0;32m%s\033[0m\n' 'symlink the pure theme to our oh-my-zsh-psyrendust custom theme folder'
ln -sf ~/.pure-theme/pure.zsh ~/.oh-my-zsh-psyrendust/themes/pure.zsh-theme;

# install zshrc-work
# ----------------------------------------------------------
printf '\033[0;32m%s\033[0m\n' 'install zshrc-work'
git clone https://github.dev.xero.com/dev-larryg/zshrc-xero.git ~/.zshrc-work;

printf '\033[0;32m%s\033[0m\n' 'sourcing .zshrc'
source ~/.zshrc

# Remove all grunt-init plugins and start over
# ----------------------------------------------------------
printf '\033[0;32m%s\033[0m\n' 'Remove all grunt-init plugins and start over'
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
printf '\033[0;32m%s\033[0m\n' 'install zshrc-personal starter template'
cp "${HOME}/.oh-my-zsh-psyrendust/templates/zshrc-personal.zsh-template" "${HOME}/.zshrc-personal/.zshrc";

# add some automount sugar for Parallels
# ----------------------------------------------------------
printf '\033[0;32m%s\033[0m\n' 'add some automount sugar for Parallels'
sudo cp "${HOME}/.zshrc-work/templates/auto_master" "/private/etc/auto_master";
sudo cp "${HOME}/.zshrc-work/templates/auto_smb" "/private/etc/auto_smb";

printf '\033[0;32m%s\033[0m\n' 'sourcing .zshrc'
source "${HOME}/.zshrc";

# let's do some admin type stuff
# add myself to wheel group
# ----------------------------------------------------------
printf '\033[0;32m%s\033[0m\n' 'add myself to wheel group'
sudo dseditgroup -o edit -a $(echo $USER) -t user wheel;

# Change ownership of /usr/local
# ----------------------------------------------------------
printf '\033[0;32m%s\033[0m\n' 'Change ownership of /usr/local'
sudo chown -R $(echo $USER):staff /usr/local;

# install a default hosts file
# ----------------------------------------------------------
if [[ $replacehostsfile = [Yy] ]]; then
  printf '\033[0;32m%s\033[0m\n' 'install a default hosts file'
  sudo cp "${HOME}/.zshrc-work/templates/hosts" "/etc/hosts";
fi

# for the c alias (syntax highlighted cat)
# ----------------------------------------------------------
printf '\033[0;32m%s\033[0m\n' 'Installing Pygments'
sudo easy_install Pygments;

# source .zshrc file and reap the benefits
# ----------------------------------------------------------
printf '\033[0;32m%s\033[0m\n' 'sourcing .zshrc'
source "${HOME}/.zshrc";

# run some of our update scripts
# ----------------------------------------------------------
printf '\033[0;32m%s\033[0m\n' 'Run some of our update scripts'
forceupdate && npmupdate;

# Update Ruby and Gems
# ----------------------------------------------------------
printf '\033[0;32m%s\033[0m\n' 'Update Ruby and Gems'
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
printf '\033[0;32m%s\033[0m\n' 'All done'
source "${HOME}/.zshrc";

printf '\033[0;32m%s\033[0m\n' 'We are all done.'
printf '\033[0;32m%s\033[0m\n' 'You should restart your computer now.'
