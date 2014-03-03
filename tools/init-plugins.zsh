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


plugins=(
  "${plugins[@]}"
  zsh-syntax-highlighting
)

# ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# source $ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ZSH_HIGHLIGHT_STYLES[default]=none
# ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red,bold
# ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=green
# ZSH_HIGHLIGHT_STYLES[alias]=none
# ZSH_HIGHLIGHT_STYLES[builtin]=none
# ZSH_HIGHLIGHT_STYLES[function]=none
# ZSH_HIGHLIGHT_STYLES[command]=none
# ZSH_HIGHLIGHT_STYLES[precommand]=none
# ZSH_HIGHLIGHT_STYLES[commandseparator]=none
# ZSH_HIGHLIGHT_STYLES[hashed-command]=none
# ZSH_HIGHLIGHT_STYLES[path]=none
# ZSH_HIGHLIGHT_STYLES[globbing]=none
# ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue
# ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=none
# ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=none
# ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
# ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
# ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
# ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=cyan
# ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=cyan
# ZSH_HIGHLIGHT_STYLES[assign]=none
