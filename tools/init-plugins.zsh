#!/usr/bin/env zsh



# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# ------------------------------------------------------------------------------
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

# Add some OS related configuration
# ------------------------------------------------------------------------------
if [[ -n $SYSTEM_IS_MAC ]]; then
  # Add some OS X related configuration
  # ----------------------------------------------------------------------------
  plugins=(
    "${plugins[@]}"
    apache2
    brew
    osx
    server
    sudo
    zsh-syntax-highlighting
  )
elif [[ -n $SYSTEM_IS_CYGWIN ]]; then
  # Add some cygwin related configuration
  # ----------------------------------------------------------------------------
  plugins=(
    "${plugins[@]}"
    kdiff3
    psyrendust-gem
  )
fi
