#!/usr/bin/env zsh

# Helper function: Same as `export $1=$2`, but will only happen if the name
# specified by `$1` is not already set.
# Borrowed from Antigen (https://github.com/zsh-users/antigen)
psyrendust-export() {
  local arg_flag="$1"
  local arg_name="$2"
  local arg_value="$3"
  if [[ $arg_flag != "--check" ]]; then
    arg_value="$arg_name"
    arg_name="$arg_flag"
    arg_flag=""
  fi
  if [[ -z "$arg_name" ]]; then
    if [[ $arg_flag == "--check" ]]; then
      [[ -a "$arg_value" ]] && eval "export $arg_name='$arg_value'"
    else
      eval "export $arg_name='$arg_value'"
    fi
  fi
}

# Helper function: Same as `[[ -f $1 ]] && source $1`, but will only happen
# if the file specified by `$1` is present.
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

# A syntax sugar to avoid the `-` when calling psyrendust commands. With this
# function, you can write `psyrendust-update` as `psyrendust update` and so on.
# Borrowed from Antigen (https://github.com/zsh-users/antigen)
psyrendust() {
    local cmd="$1"
    if [[ -z "$cmd" ]]; then
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
