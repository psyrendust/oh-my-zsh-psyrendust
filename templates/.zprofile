#
# Executes commands at login pre-zshrc.
#
# Authors:
#   Larry Gordon
#
# ------------------------------------------------------------------------------
# Do some system checks so we don't have to keep doing it later
# ------------------------------------------------------------------------------
if [[ $('uname') == *Darwin* ]]; then
  # We are using OS X
  export SYSTEM_IS_MAC=1

elif [[ $('uname') == *CYGWIN* ]]; then
  # We are using Cygwin in Windows
  export SYSTEM_IS_CYGWIN=1
  # We are also in a virtualized Windows environment
  if [[ -f "/cygdrive/z/.zshrc" ]]; then
    export SYSTEM_IS_VM=1
    export SYSTEM_VM_HOME="/cygdrive/z"
  fi
  if [[ -n "$(which ruby 2>/dev/null)" ]]; then
    export RUBY_BIN="$(cygpath -u $(ruby -e 'puts RbConfig::CONFIG["bindir"]') | sed 's/\\r$//g' )"
  fi

elif [[ $('uname') == *MINGW* ]]; then
  # We are using Git Bash in Windows
  export SYSTEM_IS_MINGW32=1
  if [[ -f "/c/cygwin64/z/.zshrc" ]]; then
    export SYSTEM_IS_VM=1
    export SYSTEM_VM_HOME="/c/cygwin64/z"
  fi
  if [[ -d "/c/cygwin64/c/cygwin64/home" ]]; then
    psyrendust_user=`whoami`
    export HOME="/c/cygwin64/c/cygwin64/home/${psyrendust_user##*\\}"
    unset psyrendust_user
  fi
  return

elif [[ $('uname') == *Linux* ]]; then
  # We are using Linux
  export SYSTEM_IS_LINUX=1

fi



# ------------------------------------------------------------------------------
# Configure $PATH
# ------------------------------------------------------------------------------
# Add locally installed binaries for cabal
if [[ -d "$HOME/.cabal/bin" ]]; then
  export PATH="$HOME/.cabal/bin:$PATH"
fi

# Add locally installed binaries (mostly from homebrew)
if [[ -d "/usr/local/bin" ]]; then
  export PATH="/usr/local/bin:$PATH"
fi

if [[ -d "/usr/local/sbin" ]]; then
  export PATH="/usr/local/sbin:$PATH"
fi

# Init nvm
# if [[ -s "$HOME/.nvm/nvm.sh" ]]; then
#   source "$HOME/.nvm/nvm.sh"
# fi

# Init rvm
# Zsh & RVM woes (rvm-prompt doesn't resolve)
# http://stackoverflow.com/questions/6636066/zsh-rvm-woes-rvm-prompt-doesnt-resolve
if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
  source "$HOME/.rvm/scripts/rvm"
fi



# ------------------------------------------------------------------------------
# Configure vars to some default paths
# ------------------------------------------------------------------------------
# Path to your oh-my-zsh configuration
export ZSH="$HOME/.oh-my-zsh"

# Set the location of oh-my-zsh-psyrendust
export ZSH_CUSTOM="$HOME/.oh-my-zsh-psyrendust"

# Set the location of our work zshrc location
export ZSHRC_WORK="$HOME/.zshrc-work"

# Set the location of our personal zshrc location
export ZSHRC_PERSONAL="$HOME/.zshrc-personal"

# Set the location of our config path
export PSYRENDUST_CONFIG_BASE_PATH="$HOME/.psyrendust"

# Ensure we have our base config paths
if [[ ! -d $PSYRENDUST_CONFIG_BASE_PATH ]]; then
  mkdir -p $PSYRENDUST_CONFIG_BASE_PATH
fi
if [[ -n $SYSTEM_IS_VM ]]; then
  export PSYRENDUST_CONFIG_BASE_ROOT="/cygdrive/z"
  if [[ ! -d "$PSYRENDUST_CONFIG_BASE_PATH/config" ]] || [[ -z $(readlink -f "$PSYRENDUST_CONFIG_BASE_PATH/config" | grep "/cygdrive/z") ]]; then
    if [[ -s "$ZSH_CUSTOM/plugins/cygwin-ln/cygwin-ln.plugin.zsh" ]]; then
      source "$ZSH_CUSTOM/plugins/cygwin-ln/cygwin-ln.plugin.zsh"
    fi
    ln -sf "$PSYRENDUST_CONFIG_BASE_ROOT/config" "$PSYRENDUST_CONFIG_BASE_PATH/config"
  fi
else
  for psyrendust_path in $PSYRENDUST_CONFIG_BASE_PATH/config/{git,win}; do
    if [[ ! -d "$psyrendust_path" ]]; then
      mkdir -p "psyrendust_path"
    fi
  done
  unset psyrendust_path
fi


# ------------------------------------------------------------------------------
# Init homebrew
# ------------------------------------------------------------------------------
if [[ -s "/usr/local/bin/brew" ]]; then
  # Add homebrew Core Utilities
  if [[ -s "$(/usr/local/bin/brew --prefix coreutils)/libexec/gnubin" ]]; then
    export PATH="$(/usr/local/bin/brew --prefix coreutils)/libexec/gnubin:$PATH"
  fi

  # Add manpath
  if [[ -s "/usr/local/share/man" ]]; then
    export MANPATH="/usr/local/share/man:$MANPATH"
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



# ------------------------------------------------------------------------------
# Psyrendust settings
# ------------------------------------------------------------------------------
# Uncomment to change how often before auto-updates occur for
# oh-my-zsh-psyrendust? (in days)
export PSYRENDUST_UPDATE_DAYS=1

# Uncomment this to enable verbose output for oh-my-zsy-psyrendust related scripts
# export PRETTY_PRINT_IS_VERBOSE=1

# Uncomment this to disable auto-update checks for oh-my-zsy-psyrendust
# export PSYRENDUST_DISABLE_AUTO_UPDATE="true"

# Uncomment this to set your own custom right prompt id
export PSYRENDUST_CONFIG_PRPROMPT_ID="%F{magenta}[ Psyrendust ]%f"

# Set syntax highlighters.
# By default, only the main highlighter is enabled.
zstyle ':psyrendust:module:syntax-highlighting' highlighters \
  'main' \
  'brackets' \
  'pattern' \
  'cursor' \
  'root'

# Set syntax highlighting styles.
# ------------------------------------------------------------------------------
#                        default: parts of the buffer that do not match anything (default: none)
#                  unknown-token: unknown tokens / errors (default: fg=red,bold)
#                  reserved-word: shell reserved words (default: fg=yellow)
#                          alias: aliases (default: fg=green)
#                        builtin: shell builtin commands (default: fg=green)
#                        command: commands (default: fg=green)
#               commandseparator: command separation tokens (default: none)
#                     precommand: precommands (i.e. exec, builtin, ...) (default: fg=green,underline)
#                       function: functions (default: fg=green)
#                 hashed-command: hashed commands (default: fg=green)
#           single-hyphen-option: single hyphen options (default: none)
#           double-hyphen-option: double hyphen options (default: none)
#                         assign: variable assignments (default: none)
#                       globbing: globbing expressions (default: fg=blue)
#  dollar-double-quoted-argument: dollar double quoted arguments (default: fg=cyan)
#         single-quoted-argument: single quoted arguments (default: fg=yellow)
#         double-quoted-argument: double quoted arguments (default: fg=yellow)
#           back-quoted-argument: backquoted expressions (default: none)
#    back-double-quoted-argument: back double quoted arguments (default: fg=cyan)
#              history-expansion: history expansion expressions (default: fg=blue)
#                           path: paths (default: underline)
#                    path_approx: approximated paths (default: fg=yellow,underline)
#                    path_prefix: path prefixes (default: underline)
zstyle ':psyrendust:module:syntax-highlighting' styles \
  'default' 'none' \
  'unknown-token' 'fg=red,bold' \
  'reserved-word' 'yellow,bold' \
  'alias' 'fg=green' \
  'builtin' 'fg=green' \
  'command' 'fg=green' \
  'commandseparator' 'fg=green' \
  'precommand' 'fg=green' \
  'function' 'fg=green' \
  'hashed-command' 'fg=green' \
  'single-hyphen-option' 'fg=green,bold' \
  'double-hyphen-option' 'fg=green,bold' \
  'assign' 'fg=magenta,bold' \
  'globbing' 'fg=magenta,bold' \
  'dollar-double-quoted-argument' 'fg=magenta' \
  'single-quoted-argument' 'fg=blue,bold' \
  'double-quoted-argument' 'fg=blue,bold' \
  'back-quoted-argument' 'fg=cyan,bold' \
  'back-double-quoted-argument' 'fg=cyan,bold' \
  'history-expansion' 'fg=cyan,bold' \
  'path' 'fg=blue,bold' \
  'path_approx' 'fg=blue,bold' \
  'path_prefix' 'fg=blue,bold'



# ------------------------------------------------------------------------------
# Oh My Zsh Settings
# ------------------------------------------------------------------------------
# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="pure"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

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

# Uncomment following line if you want to shown in the command execution time stamp
# in the history command output. The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|
# yyyy-mm-dd
# HIST_STAMPS="mm/dd/yyyy"
