#!/usr/bin/env zsh

# ------------------------------------------------------------------------------
# Setup autocompletion for psyrendust-* functions
# Borrowed from Antigen (https://github.com/zsh-users/antigen)
# ------------------------------------------------------------------------------
# Used to defer compinit/compdef
typeset -a __psyrendust_deferred_compdefs
compdef () { __psyrendust_deferred_compdefs=($__psyrendust_deferred_compdefs "$*") }

# A syntax sugar to avoid the `-` when calling psyrendust commands. With this
# function, you can write `psyrendust-update` as `psyrendust update` and so on.
# Borrowed from Antigen (https://github.com/zsh-users/antigen)
psy() {
  local cmd="$1"
  if [[ $cmd == "--version" ]] || [[ $cmd == "-v" ]]; then
    _psyrendust-version --get
    return
  elif [[ -z "$cmd" ]]; then
    echo 'Psyrendust: Please give a command to run.' >&2
    return 1
  fi
  shift

  if functions "psyrendust-$cmd" > /dev/null; then
    "psyrendust-$cmd" "$@"
  else
    echo "Psyrendust: Unknown command: $cmd" >&2
  fi
}

# Long name version of psy function
psyrendust() {
  psy $@
}

_psyrendust-version() {
  local arg_flag="$1"
  if [[ $arg_flag == "--set" ]]; then
    cd "$ZSH_CUSTOM"
    local version_file="$PSYRENDUST_CONFIG_BASE_PATH/version"
    local version=$(git describe)
    local version_tag=$(echo $version | cut -d- -f 1)
    local version_commit=$(echo $version | cut -d- -f 2)
    local version_sha=$(echo $version | cut -d- -f 3)
    local version_date=$(echo $(git show -s --format=%ci | cut -d\  -f 1))
    echo "pppurple -i \"oh-my-zsh-psyrendust \"" > "$version_file"
    echo "pplightpurple \"${version_tag}p${version_commit} (${version_date} revision ${version_sha})\"" >> "$version_file"
  else
    [[ -f "$PSYRENDUST_CONFIG_BASE_PATH/version" ]] || _psyrendust-version --set
    source "$PSYRENDUST_CONFIG_BASE_PATH/version"
  fi
}

# Initialize completion.
psyrendust-apply() {
  local cdef

  # Load the compinit module. This will readefine the `compdef` function to
  # the one that actually initializes completions.
  autoload -U compinit
  compinit -i

  # Apply all `compinit`s that have been deferred.
  eval "$(for cdef in $__psyrendust_deferred_compdefs; do
            echo compdef $cdef
          done)"

  unset __psyrendust_deferred_compdefs
}

# Setup psyrendust's autocompletion
_psyrendust() {
  eval "compadd \
    $(echo $(print -l ${(ok)functions} | grep "psyrendust-" | sed "s/psyrendust-//g"))"
}

# Setup psyrendust's own completion.
compdef _psyrendust psy



# ------------------------------------------------------------------------------
# Helper function: Same as `[[ -f $1 ]] && source $1`, but will only happen
# if the file specified by `$1` is present.
# ------------------------------------------------------------------------------
psyrendust-source() {
  local arg_flag="${1}"
  local arg_file="${2}"
  local arg_args="${3}"
  if [[ $arg_flag == "--help" ]]; then
    cat <<EOF
NAME
    psyrendust source - Source a given file if it exists and if the flag is true

SYNOPSYS
    psyrendust source [ --all ]
                      [ --help ]

DESCRIPTION
    Helper function: Same as `[[ -f $1 ]] && source $1`, but will only happen
    if the file specified by `$1` is present.

OPTIONS
    --all
    --mac
    --cygwin
    --ming
    --linux
    --vm
    --not-mac
    --not-cygwin
    --not-ming
    --not-linux
    --not-vm
EOF
    return
  fi

  if [[ -z $arg_file ]]; then
    arg_flag="--all"
  else
    shift
  fi
  arg_file="$1"
  shift
  arg_args="$@"

  if [[ -a "$arg_file" ]]; then
    local should_source
    case "$arg_flag" in
      --mac) [[ -n $SYSTEM_IS_MAC ]] && should_source=1;;
      --cygwin) [[ -n $SYSTEM_IS_CYGWIN ]] && should_source=1;;
      --ming) [[ -n $SYSTEM_IS_MINGW32 ]] && should_source=1;;
      --linux) [[ -n $SYSTEM_IS_LINUX ]] && should_source=1;;
      --vm) [[ -n $SYSTEM_IS_VM ]] && should_source=1;;
      --not-mac) [[ ! -n $SYSTEM_IS_MAC ]] && should_source=1;;
      --not-cygwin) [[ ! -n $SYSTEM_IS_CYGWIN ]] && should_source=1;;
      --not-ming) [[ ! -n $SYSTEM_IS_MINGW32 ]] && should_source=1;;
      --not-linux) [[ ! -n $SYSTEM_IS_LINUX ]] && should_source=1;;
      --not-vm) [[ ! -n $SYSTEM_IS_VM ]] && should_source=1;;
      *) should_source=1;;
    esac
    if [[ -n $should_source ]] && eval "source \"$arg_file\" $arg_args"
  fi
}



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
