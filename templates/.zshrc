# Path to your oh-my-zsh configuration
# ----------------------------------------------------------
if [[ -d "${HOME}/.oh-my-zsh" ]]; then
  ZSH="${HOME}/.oh-my-zsh"
fi

# Set the location of oh-my-zsh-psyrendust
if [[ -d "${HOME}/.oh-my-zsh-psyrendust" ]]; then
  export ZSH_CUSTOM="${HOME}/.oh-my-zsh-psyrendust"
fi

# Set the location of the PURE Theme and symlink pure.zsh
# into our theme folder
if [[ -d "${HOME}/.pure-theme" ]]; then
  export PURE_THEME="$HOME/.pure-theme"
  ln -sf "${PURE_THEME}/pure.zsh" "${ZSH_CUSTOM}/themes/pure.zsh-theme"
fi

# Set name of the theme to load into oh-my-zsh.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
if [[ -n $PURE_THEME ]]; then
  ZSH_THEME="pure"
else
  ZSH_THEME="psyrendust"
fi

# Set the location of our work zshrc location
if [[ -d "${HOME}/.zshrc-work" ]]; then
  export ZSHRC_WORK="${HOME}/.zshrc-work"
fi

# Set the location of our personal zshrc location
if [[ -d "${HOME}/.zshrc-personal" ]]; then
  export ZSHRC_PERSONAL="${HOME}/.zshrc-personal"
fi

# Auto update duration for oh-my-zsh-psyrendust
export UPDATE_PSYRENDUST_DAYS=1

# Do some system checks so we don't have to keep doing it later
# ----------------------------------------------------------
[[ $('uname') == *CYGWIN* ]] && export SYSTEM_IS_CYGWIN=1
[[ $('uname') == *Linux* ]] && export SYSTEM_IS_LINUX=1
[[ $('uname') == *Darwin* ]] && export SYSTEM_IS_MAC=1


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


# Check for updates on initial load...
# ----------------------------------------------------------
if [[ "$DISABLE_PSYRENDUST_AUTO_UPDATE" != "true" ]]; then
  /usr/bin/env ZSH=$ZSH ZSH_CUSTOM=$ZSH_CUSTOM DISABLE_PSYRENDUST_AUTO_UPDATE=$DISABLE_PSYRENDUST_AUTO_UPDATE zsh $ZSH_CUSTOM/plugins/psyrendust-auto-update/check-for-upgrade.zsh
fi


# Configure $PATH variable
# ----------------------------------------------------------
# Add locally installed binaries first
if [[ -d "/usr/local/bin" ]]; then
  PATH="/usr/local/bin:${PATH}"
fi

if [[ -d "/usr/local/sbin" ]]; then
  PATH="/usr/local/sbin:${PATH}"
fi

# Check if homebrew is installed
if [[ -s "/usr/local/bin/brew" ]]; then
  # Add homebrew Core Utilities
  if [[ -s "$(/usr/local/bin/brew --prefix coreutils)/libexec/gnubin" ]]; then
    PATH="$(/usr/local/bin/brew --prefix coreutils)/libexec/gnubin:${PATH}"
  fi

  # Add homebrew Core Utilities man
  if [[ -s "$(/usr/local/bin/brew --prefix coreutils)/libexec/gnuman" ]]; then
    export MANPATH="$(/usr/local/bin/brew --prefix coreutils)/libexec/gnuman:${MANPATH}"
  fi

  # Add SSL Cert
  if [[ -s "$(/usr/local/bin/brew --prefix curl-ca-bundle)/share/ca-bundle.crt" ]]; then
    export SSL_CERT_FILE="$(/usr/local/bin/brew --prefix curl-ca-bundle)/share/ca-bundle.crt"
  fi
fi


# ADD NVM's version of NPM
if [[ -s "$HOME/.nvm/nvm.sh" ]]; then
  source "$HOME/.nvm/nvm.sh"
fi

# Zsh & RVM woes (rvm-prompt doesn't resolve)
# http://stackoverflow.com/questions/6636066/zsh-rvm-woes-rvm-prompt-doesnt-resolve
# Load RVM into a shell session *as a function*
if [[ -s "${HOME}/.rvm/scripts/rvm" ]]; then
  source "$HOME/.rvm/scripts/rvm"
fi

export PATH

# Comment this out to disable auto-update checks for oh-my-zsy-psyrendust
# DISABLE_PSYRENDUST_AUTO_UPDATE="true"

# Comment this out to disable auto-update prompts for oh-my-zsh
# DISABLE_UPDATE_PROMPT="true"

# Set to this to use case-se;nsitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(
  # Default plugins from oh-my-zsh
  bower
  colored-man
  colorize
  compleat
  copydir
  copyfile
  cp
  encode64
  extract
  fasd
  gem
  git
  gitfast
  git-flow-avh
  history
  history-substring-search
  npm
  # Custom plugins from oh-my-zsh-psyrendust
  alias-grep
  apache2
  git-psyrendust
  grunt-autocomplete
  kill-process
  mkcd
  pretty-print
  refresh
  server
  sublime
)


# Add some cygwin related configuration
if [[ -n $SYSTEM_IS_CYGWIN ]]; then
  plugins=("${plugins[@]}" kaleidoscope)
  ZSH_THEME="blinks"
  alias cygpackages="cygcheck -c -d | sed -e \"1,2d\" -e 's/ .*$//'"
  alias open="/bin/cygstart --explore \"${1:-.}\""
fi

# Add some OS X related configuration
if [[ -n $SYSTEM_IS_MAC ]]; then
  plugins=("${plugins[@]}" brew osx)
  alias chownapps="find /Applications -maxdepth 1 -user root -exec sudo chown -R $(echo $USER):staff {} + -print"
  alias manp="man-preview"
  alias ql="quick-look"
fi

# Helper aliases
alias zshconfig="sbl ~/.zshrc"
alias ohmyzsh="sbl ~/.oh-my-zsh"
alias sourceohmyzsh="source ~/.zshrc"

alias chownusrlocal="find /usr/local -maxdepth 2 -user root -exec sudo chown -R $(echo $USER):staff {} + -print"
alias npmlist="npm -g ls --depth=0 2>NUL"

alias psyversion="printf '\033[0;35m%s\033[0;33m%s\033[0m\n' 'Running oh-my-zsh-psyrendust version ' '$(cat ${ZSH_CUSTOM}/.version)'"


# Update all global npm packages except for npm, because updating npm using npm
# always breaks. Running npm -g update will result in having to reinstall node.
# This little script will update all global npm packages except for npm.
alias npmupdate="npm -g ls --depth=0 2>NUL | awk -F'@' '{print $1}' | awk '{print $2}' | awk  '!/npm/'> ~/.npm-g-ls && xargs -0 -n 1 npm -g update < <(tr \\n \\0 <~/.npm-g-ls) && rm ~/.npm-g-ls"

if [[ -s "${ZSH_CUSTOM}/plugins/psyrendust-auto-update/upgrade.zsh" ]]; then
  alias forceupdate="source ${ZSH_CUSTOM}/plugins/psyrendust-auto-update/upgrade.zsh"
fi

# Custom .zshrc files that get sourced if they exist. Things
# place in these files will override any settings found in
# this file.
# ----------------------------------------------------------
# Load custom work zshrc
if [[ -s "${ZSHRC_WORK}/.zshrc" ]]; then
  source "${ZSHRC_WORK}/.zshrc"
fi

# Load custom personal zshrc
if [[ -s "${ZSHRC_PERSONAL}/.zshrc" ]]; then
  source "${ZSHRC_PERSONAL}/.zshrc"
fi

source $ZSH/oh-my-zsh.sh

# load fasd
eval "$(fasd --init zsh-hook zsh-ccomp zsh-ccomp-install zsh-wcomp zsh-wcomp-install)"

psyversion
