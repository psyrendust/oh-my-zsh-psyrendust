# Do some system checks so we don't have to keep doing it later
# ------------------------------------------------------------------------------
if [[ $('uname') == *Darwin* ]]; then
  # We are using OS X
  export SYSTEM_IS_MAC=1

elif [[ $('uname') == *CYGWIN* ]]; then
  # We are using Cygwin in Windows
  export SYSTEM_IS_CYGWIN=1
  # We are also in a virtualized Windows environment
  [[ -f "/cygdrive/z/.zshrc" ]] && export SYSTEM_IS_VM=1 && export SYSTEM_VM_HOME="/cygdrive/z"

elif [[ $('uname') == *Linux* ]]; then
  # We are using Linux
  export SYSTEM_IS_LINUX=1

fi



# Path to your oh-my-zsh configuration
# ----------------------------------------------------------
if [[ -d "$HOME/.oh-my-zsh" ]]; then
  ZSH="$HOME/.oh-my-zsh"
fi


# Set the location of oh-my-zsh-psyrendust
# ------------------------------------------------------------------------------
if [[ -d "$HOME/.oh-my-zsh-psyrendust" ]]; then
  export ZSH_CUSTOM="$HOME/.oh-my-zsh-psyrendust"
fi


# Set name of the theme to load into oh-my-zsh.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ------------------------------------------------------------------------------
ZSH_THEME="pure"


# Set the location of our work zshrc location
# ------------------------------------------------------------------------------
if [[ -d "$HOME/.zshrc-work" ]]; then
  export ZSHRC_WORK="$HOME/.zshrc-work"
fi


# Set the location of our personal zshrc location
# ------------------------------------------------------------------------------
if [[ -d "$HOME/.zshrc-personal" ]]; then
  export ZSHRC_PERSONAL="$HOME/.zshrc-personal"
fi


# Auto update duration for oh-my-zsh-psyrendust
# ------------------------------------------------------------------------------
export UPDATE_PSYRENDUST_DAYS=1


# Ensure we have a temp folder to work with
# ------------------------------------------------------------------------------
export PSYRENDUST_CONFIG_BASE_PATH="$HOME/.psyrendust"
if [[ ! -d $PSYRENDUST_CONFIG_BASE_PATH ]]; then
  mkdir -p $PSYRENDUST_CONFIG_BASE_PATH
fi



# Configure $PATH variable
# ------------------------------------------------------------------------------
# Add locally installed binaries first
if [[ -d "/usr/local/bin" ]]; then
  PATH="/usr/local/bin:$PATH"
fi

if [[ -d "/usr/local/sbin" ]]; then
  PATH="/usr/local/sbin:$PATH"
fi

# Check if homebrew is installed
# ------------------------------------------------------------------------------
if [[ -s "/usr/local/bin/brew" ]]; then
  # Add homebrew Core Utilities
  if [[ -s "$(/usr/local/bin/brew --prefix coreutils)/libexec/gnubin" ]]; then
    PATH="$(/usr/local/bin/brew --prefix coreutils)/libexec/gnubin:$PATH"
  fi

  # Add homebrew Core Utilities man
  if [[ -s "$(/usr/local/bin/brew --prefix coreutils)/libexec/gnuman" ]]; then
    export MANPATH="$(/usr/local/bin/brew --prefix coreutils)/libexec/gnuman:$MANPATH"
  fi

  # Add SSL Cert
  if [[ -s "$(/usr/local/bin/brew --prefix curl-ca-bundle)/share/ca-bundle.crt" ]]; then
    export SSL_CERT_FILE="$(/usr/local/bin/brew --prefix curl-ca-bundle)/share/ca-bundle.crt"
  fi
fi


# ADD NVM's version of NPM
# ------------------------------------------------------------------------------
if [[ -s "$HOME/.nvm/nvm.sh" ]]; then
  source "$HOME/.nvm/nvm.sh"
fi

# Zsh & RVM woes (rvm-prompt doesn't resolve)
# http://stackoverflow.com/questions/6636066/zsh-rvm-woes-rvm-prompt-doesnt-resolve
# Load RVM into a shell session *as a function*
# ------------------------------------------------------------------------------
if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
  source "$HOME/.rvm/scripts/rvm"
fi

export PATH

# ------------------------------------------------------------------------------
# Psyrendust settings
# ------------------------------------------------------------------------------
# Uncomment this to enable verbose output for oh-my-zsy-psyrendust related scripts
export PRETTY_PRINT_IS_VERBOSE=1

# Uncomment this to disable auto-update checks for oh-my-zsy-psyrendust
# export DISABLE_PSYRENDUST_AUTO_UPDATE="true"

# Uncomment this to set your own custom right prompt id
export PSYRENDUST_CONFIG_PRPROMPT_ID="%F{magenta}[ Psyrendust ]%f"



# ------------------------------------------------------------------------------
# Oh My Zsh Settings
# ------------------------------------------------------------------------------
# Comment this out to disable auto-update prompts for oh-my-zsh
DISABLE_UPDATE_PROMPT="true"

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
  node
  npm
  ruby
  systemadmin
  urltools
  # Custom plugins from oh-my-zsh-psyrendust
  alias-grep
  git-psyrendust
  grunt-autocomplete
  kill-process
  mkcd
  plog
  pprocess
  pretty-print
  refresh
  sublime
)


# Add some cygwin related configuration
# ------------------------------------------------------------------------------
if [[ -n $SYSTEM_IS_CYGWIN ]]; then
  plugins=("${plugins[@]}" kdiff3)
  alias cygpackages="cygcheck -c -d | sed -e \"1,2d\" -e 's/ .*$//'"
  alias open="/bin/cygstart --explore \"${1:-.}\""
  cygcreateinstaller() {
    echo "echo off" > $1
    echo -n "%1 -q -P " >> $1
    echo $(echo $(cygcheck -c -d | sed -e "1,2d" -e 's/ .*$//') | tr " " ",") >> $1
  }
fi


# Add some OS X related configuration
# ------------------------------------------------------------------------------
if [[ -n $SYSTEM_IS_MAC ]]; then
  plugins=(
    "${plugins[@]}"
    apache2
    brew
    osx
    server
    sudo
  )
  alias chownapps="find /Applications -maxdepth 1 -user root -exec sudo chown -R $(echo $USER):staff {} + -print"
  alias manp="man-preview"
  alias ql="quick-look"
fi


# Helper aliases
# ------------------------------------------------------------------------------
alias zshconfig="sbl ~/.zshrc"
alias ohmyzsh="sbl ~/.oh-my-zsh"
alias sourceohmyzsh="source ~/.zshrc"
alias chownusrlocal="find /usr/local -maxdepth 2 -user root -exec sudo chown -R $(echo $USER):staff {} + -print"
alias npmlist="npm -g ls --depth=0 2>NUL"
alias psyversion="pppurple -i \"Running oh-my-zsh-psyrendust version \" && pplightpurple \"$(cat $ZSH_CUSTOM/.version)\""


# Update all global npm packages except for npm, because updating npm using npm
# always breaks. Running npm -g update will result in having to reinstall node.
# This little script will update all global npm packages except for npm.
# ------------------------------------------------------------------------------
alias npmupdate="npm -g ls --depth=0 2>NUL | awk -F'@' '{print $1}' | awk '{print $2}' | awk  '!/npm/'> ${HOME}/.psyrendust/npm-g-ls && xargs -0 -n 1 npm -g update < <(tr \\n \\0 <${HOME}/.psyrendust/npm-g-ls) && rm ${HOME}/.psyrendust/npm-g-ls"



# Force run the auto-update script
# ------------------------------------------------------------------------------
forceupdate() {
  [[ -f "$PSYRENDUST_CONFIG_BASE_PATH/auto-update-last-run" ]] && rm "$PSYRENDUST_CONFIG_BASE_PATH/auto-update-last-run";
  [[ -f "$PSYRENDUST_CONFIG_BASE_PATH/pprocess-post-update" ]] && rm "$PSYRENDUST_CONFIG_BASE_PATH/pprocess-post-update";
  [[ -f "$PSYRENDUST_CONFIG_BASE_PATH/post-update-procedure-result.conf" ]] && rm "$PSYRENDUST_CONFIG_BASE_PATH/post-update-procedure-result.conf";
  [[ -f "$PSYRENDUST_CONFIG_BASE_PATH/post-update-progress.conf" ]] && rm "$PSYRENDUST_CONFIG_BASE_PATH/post-update-progress.conf";
  [[ -s "$ZSH_CUSTOM/plugins/prprompt/prprompt.plugin.zsh" ]] && source "$ZSH_CUSTOM/plugins/prprompt/prprompt.plugin.zsh";
  [[ -f "$ZSH_CUSTOM/tools/auto-update.zsh" ]] && source "$ZSH_CUSTOM/tools/auto-update.zsh"
}



# Custom .zshrc files that get sourced if they exist. Things
# place in these files will override any settings found in
# this file.
# ------------------------------------------------------------------------------
# Load custom work zshrc
# ------------------------------------------------------------------------------
if [[ -s "$ZSHRC_WORK/.zshrc" ]]; then
  source "$ZSHRC_WORK/.zshrc"
fi


# Load custom personal zshrc
# ------------------------------------------------------------------------------
if [[ -s "$ZSHRC_PERSONAL/.zshrc" ]]; then
  source "$ZSHRC_PERSONAL/.zshrc"
fi


# Source oh-my-zsh and get things started
# ------------------------------------------------------------------------------
source $ZSH/oh-my-zsh.sh



# Output our version number
# ------------------------------------------------------------------------------
psyversion



# If we are using Cygwin and ZSH_THEME is Pure, then replace the prompt
# character to something that works in Windows
# ----------------------------------------------------------------------------
if [[ -n $SYSTEM_IS_CYGWIN ]] && [[ $ZSH_THEME == "pure" ]]; then
  PROMPT=$(echo $PROMPT | tr "❯" "›")
fi



# Last run helper functions
# ------------------------------------------------------------------------------
_psyrendust_au_last_run="$PSYRENDUST_CONFIG_BASE_PATH/auto-update-last-run"
function _psyrendust-au-get-current-epoch() {
  echo $(($(date +%s) / 24 / 60 / 60))
  # echo $(date +%s)
}

function _psyrendust-au-set-current-epoch() {
  echo "_psyrendust_au_last_epoch=$(_psyrendust-au-get-current-epoch)" > ${_psyrendust_au_last_run}
}

# Load up the last run for auto-update
# ------------------------------------------------------------------------------
if [[ -f "${_psyrendust_au_last_run}" ]]; then
  source "${_psyrendust_au_last_run}"
fi
if [[ -z "${_psyrendust_au_last_epoch}" ]]; then
  _psyrendust-au-set-current-epoch
  source "${_psyrendust_au_last_run}"
fi
_psyrendust_au_last_epoch_diff=$(($(_psyrendust-au-get-current-epoch) - ${_psyrendust_au_last_epoch}))

# See if we ran this today already
# ------------------------------------------------------------------------------
if [[ ${_psyrendust_au_last_epoch_diff} -gt 1 ]]; then
  # Load prprompt script
  # ----------------------------------------------------------------------------
  if [[ -s "$ZSH_CUSTOM/plugins/prprompt/prprompt.plugin.zsh" ]]; then
    source "$ZSH_CUSTOM/plugins/prprompt/prprompt.plugin.zsh"
  fi


  # Run auto-update for oh-my-zsh-psyrendust. Updates run asynchronously in the
  # background. The RPROMPT updates every 1 second to display the real-time
  # progress of the auto-update.
  # ----------------------------------------------------------------------------
  if [[ -s "$ZSH_CUSTOM/tools/auto-update.zsh" ]]; then
    source "$ZSH_CUSTOM/tools/auto-update.zsh"
  fi


  # Update last epoch
  # ----------------------------------------------------------------------------
  _psyrendust-au-set-current-epoch
else
  # Run any post-update scripts if they exist
  # ------------------------------------------------------------------------------
  for psyrendust_run_once in $(ls "$PSYRENDUST_CONFIG_BASE_PATH/" | grep "^post-update-run-once.*zsh$"); do
    source "$PSYRENDUST_CONFIG_BASE_PATH/$psyrendust_run_once"
    # Sourcing helper script to call all procedure functions in this script
    # ------------------------------------------------------------------------------
    if [[ -s "$ZSH_CUSTOM/tools/psyrendust-procedure-init.zsh" ]]; then
      # Pass -x option to cleanup
      source "$ZSH_CUSTOM/tools/psyrendust-procedure-init.zsh" -x "$PSYRENDUST_CONFIG_BASE_PATH/$psyrendust_run_once"
    fi
  done
  unset psyrendust_run_once
fi



# Load fasd
# ------------------------------------------------------------------------------
eval "$(fasd --init zsh-hook zsh-ccomp zsh-ccomp-install zsh-wcomp zsh-wcomp-install)"

