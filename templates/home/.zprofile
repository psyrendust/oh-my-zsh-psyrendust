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
    export PSY_HOST="/cygdrive/z/.psyrendust"
  fi
  if [[ -n "$(which ruby 2>/dev/null)" ]]; then
    export PSY_RUBY_BIN="$(cygpath -u $(ruby -e 'puts RbConfig::CONFIG["bindir"]') | sed 's/\\r$//g' )"
  fi

elif [[ $('uname') == *MINGW* ]]; then
  # We are using Git Bash in Windows
  export SYSTEM_IS_MINGW32=1
  if [[ -f "/c/cygwin64/z/.zshrc" ]]; then
    export SYSTEM_IS_VM=1
    export PSY_HOST="/c/cygwin64/z/.psyrendust"
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
export ZSH="$HOME/.psyrendust/repos/frameworks/oh-my-zsh"
export ZSH_CUSTOM="$HOME/.psyrendust"
export PSY_CUSTOM="$ZSH_CUSTOM"
zstyle ':psyrendust:paths:default' paths \
  'BACKUP' '$PSY_CUSTOM/backup' \
  'CONFIG' '$PSY_CUSTOM/config' \
  'CONFIG_GIT' '$PSY_CUSTOM/config/git' \
  'CONFIG_SSH' '$PSY_CUSTOM/config/ssh' \
  'CONFIG_WIN' '$PSY_CUSTOM/config/win' \
  'EPOCH' '$PSY_CUSTOM/epoch' \
  'LOGS' '$PSY_CUSTOM/logs' \
  'PLUGINS' '$PSY_CUSTOM/plugins' \
  'PROCESS' '$PSY_CUSTOM/process' \
  'REPOS' '$PSY_CUSTOM/repos' \
  'REPOS_DEV' '$PSY_CUSTOM/repos/dev' \
  'REPOS_FRAMEWORKS' '$PSY_CUSTOM/repos/frameworks' \
  'REPOS_PLUGINS' '$PSY_CUSTOM/repos/plugins' \
  'REPOS_THEMES' '$PSY_CUSTOM/repos/themes' \
  'REPOS_TOOLS' '$PSY_CUSTOM/repos/tools' \
  'RPROMPT' '$PSY_CUSTOM/rprompt' \
  'RUN_ONCE' '$PSY_CUSTOM/run-once' \
  'SYMLINK' '$PSY_CUSTOM/symlink' \
  'THEMES' '$PSY_CUSTOM/themes' \
  'UPDATES' '$PSY_CUSTOM/updates' \
  'VERSION' '$PSY_CUSTOM/version' \
  'GRUNT_INIT' '$HOME/.grunt-init'



# ------------------------------------------------------------------------------
# Location of installed frameworks
# ------------------------------------------------------------------------------
zstyle ':psyrendust:paths:frameworks' paths \
  'WORK' '$PSY_REPOS_FRAMEWORKS/work' \
  'USER' '$PSY_REPOS_FRAMEWORKS/user' \
  'PSYRENDUST' '$PSY_REPOS_FRAMEWORKS/psyrendust'



# ------------------------------------------------------------------------------
# Location of psyrendust src paths
# ------------------------------------------------------------------------------
zstyle ':psyrendust:paths:src' paths \
  'SRC_FONTS' '$PSY_PSYRENDUST/fonts' \
  'SRC_PLUGINS' '$PSY_PSYRENDUST/plugins' \
  'SRC_TEMPLATES' '$PSY_PSYRENDUST/templates' \
  'SRC_TEMPLATES_CONFIG' '$PSY_PSYRENDUST/templates/config' \
  'SRC_THEMES' '$PSY_PSYRENDUST/themes' \
  'SRC_TOOLS' '$PSY_PSYRENDUST/tools'



# Set exports for default paths
typeset -A psyrendust_default_paths
zstyle -a ':psyrendust:paths:default' paths 'psyrendust_default_paths'
for psyrendust_default_path in "${(k)psyrendust_default_paths[@]}"; do
  eval "export PSY_${psyrendust_default_path}=\"$psyrendust_default_paths[$psyrendust_default_path]\""
  default_path="$(eval "echo \"\$PSY_$psyrendust_default_path\"")"
  if [[ ! -d $default_path ]]; then
    mkdir -p "$default_path"
  fi
  echo "default_path: $psyrendust_default_path : $default_path"
  unset default_path
done
unset psyrendust_default_paths{s,}



# Set exports for frameworks paths
typeset -A psyrendust_frameworks_paths
zstyle -a ':psyrendust:paths:frameworks' paths 'psyrendust_frameworks_paths'
for psyrendust_frameworks_path in "${(k)psyrendust_frameworks_paths[@]}"; do
  eval "export PSY_${psyrendust_frameworks_path}=\"$psyrendust_frameworks_paths[$psyrendust_frameworks_path]\""
done
unset psyrendust_frameworks_paths{s,}



# Set exports for src paths
typeset -A psyrendust_src_paths
zstyle -a ':psyrendust:paths:src' paths 'psyrendust_src_paths'
for psyrendust_src_path in "${(k)psyrendust_src_paths[@]}"; do
  eval "export PSY_${psyrendust_src_path}=\"$psyrendust_src_paths[$psyrendust_src_path]\""
done
unset psyrendust_src_paths{s,}



if [[ -n $SYSTEM_IS_VM ]]; then
  # Load cygwin-ln plugin to fix symlinking in our VM
  [[ -s "$PSY_PLUGINS/cygwin-ln/cygwin-ln.plugin.zsh" ]] || cp -aR "$PSY_SRC_PLUGINS/cygwin-ln/." "$PSY_PLUGINS/cygwin-ln/"
  source "$PSY_PLUGINS/cygwin-ln/cygwin-ln.plugin.zsh"
  # Symlink our config folder to our host
  if [[ ! -d "$PSY_CONFIG" ]] || [[ -z $(readlink -f "$PSY_CONFIG" | grep "/cygdrive/z") ]]; then
    ln -sf "$PSY_HOST/config" "$PSY_CONFIG"
  fi
  # Symlink our repos folder to our host
  if [[ ! -d "$PSY_REPOS" ]] || [[ -z $(readlink -f "$PSY_REPOS" | grep "/cygdrive/z") ]]; then
    ln -sf "$PSY_HOST/repos" "$PSY_REPOS"
  fi
fi



# ------------------------------------------------------------------------------
# Init homebrew
# ------------------------------------------------------------------------------
if [[ -s "/usr/local/bin/brew" ]]; then
  brew_coreutils="/usr/local/opt/coreutils"
  brew_curl_ca_bundle="/usr/local/opt/curl-ca-bundle"

  # Add homebrew Core Utilities
  if [[ -s "$brew_coreutils/libexec/gnubin" ]]; then
    export PATH="$brew_coreutils/libexec/gnubin:$PATH"
  fi

  # Add manpath
  if [[ -s "/usr/local/share/man" ]]; then
    export MANPATH="/usr/local/share/man:$MANPATH"
  fi

  # Add homebrew Core Utilities man
  if [[ -s "$brew_coreutils/libexec/gnuman" ]]; then
    export MANPATH="$brew_coreutils/libexec/gnuman:$MANPATH"
  fi

  # Add SSL Cert
  if [[ -s "$brew_curl_ca_bundle/share/ca-bundle.crt" ]]; then
    export SSL_CERT_FILE="$brew_curl_ca_bundle/share/ca-bundle.crt"
  fi
  unset brew_coreutils
  unset brew_curl_ca_bundle
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

# Set default plugins from oh-my-zsh
zstyle ':psyrendust:load:oh-my-zsh:default' plugins \
  'bower' \
  'colorize' \
  'colored-man' \
  'compleat' \
  'copydir' \
  'copyfile' \
  'cp' \
  'encode64' \
  'extract' \
  'fasd' \
  'gem' \
  'git' \
  'gitfast' \
  'git-flow-avh' \
  'history' \
  'history-substring-search' \
  'node' \
  'npm' \
  'ruby' \
  'systemadmin' \
  'urltools'

# Set default plugins from psyrendust
zstyle ':psyrendust:load:psyrendust:default' plugins \
  'alias-grep' \
  'git-psyrendust' \
  'grunt-autocomplete' \
  'kill-process' \
  'mkcd' \
  'plog' \
  'pprocess' \
  'refresh' \
  'sublime'

# Set default plugins from psyrendust
zstyle ':psyrendust:load:psyrendust:mac' plugins \
  'apache2' \
  'brew' \
  'osx' \
  'server' \
  'sudo' \
  'zsh-syntax-highlighting'

# Set default plugins from psyrendust
zstyle ':psyrendust:load:psyrendust:win' plugins \
  'cygwin-gem' \
  'cygwin-ln' \
  'kdiff3'

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

# Ensure that pretty-print is available
[[ -f "$PSY_PLUGINS/pretty-print/pretty-print.plugin.zsh" ]] || cp -aR "$PSY_SRC_PLUGINS/pretty-print/." "$PSY_PLUGINS/pretty-print/"
source "$PSY_PLUGINS/pretty-print/pretty-print.plugin.zsh"
