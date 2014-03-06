#!/usr/bin/env zsh
#
# Initialize which plugins to load into oh-my-zsh
#
# Authors:
#   Larry Gordon
#
# ------------------------------------------------------------------------------
# Setup global functions
# ------------------------------------------------------------------------------

# Add some cygwin related functions
psyrendust-mkcygwin() {
  if [[ -n $SYSTEM_IS_CYGWIN ]]; then
    echo "echo off" > $1
    echo -n "%1 -q -P " >> $1
    echo $(echo $(cygcheck -c -d | sed -e "1,2d" -e 's/ .*$//') | tr " " ",") >> $1
  fi
}

# Force run the auto-update script
psyrendust-update() {
  [[ -f "$PSYRENDUST_CONFIG_BASE_PATH/auto-update-last-run" ]] && rm "$PSYRENDUST_CONFIG_BASE_PATH/auto-update-last-run";
  [[ -f "$PSYRENDUST_CONFIG_BASE_PATH/pprocess-post-update" ]] && rm "$PSYRENDUST_CONFIG_BASE_PATH/pprocess-post-update";
  [[ -f "$PSYRENDUST_CONFIG_BASE_PATH/post-update-procedure-result.conf" ]] && rm "$PSYRENDUST_CONFIG_BASE_PATH/post-update-procedure-result.conf";
  [[ -f "$PSYRENDUST_CONFIG_BASE_PATH/post-update-progress.conf" ]] && rm "$PSYRENDUST_CONFIG_BASE_PATH/post-update-progress.conf";
  psyrendust source "$ZSH_CUSTOM/plugins/prprompt/prprompt.plugin.zsh";
  psyrendust source "$ZSH_CUSTOM/tools/auto-update.zsh"
}

# Restart the current shell
psyrendust-restartshell() {
  ppemphasis ""
  ppemphasis ""
  if [[ -n $SYSTEM_IS_MAC ]]; then
    # If we are running OS X we can use applescript to create a new tab and
    # close the current tab we are on
    ppemphasis "Restarting iTerm Shell in 2 seconds"
    sleep 2
    osascript "$ZSH_CUSTOM/tools/restart-iterm.scpt"
  elif [[ -n $SYSTEM_IS_CYGWIN ]]; then
    # If we are running cygwin we can restart the current console
    ppemphasis "Restarting Cygwin Shell in 2 seconds"
    sleep 2
    cygstart "$ZSH_CUSTOM/tools/restart-cygwin.vbs"
    exit
  fi
}

# Create a backup of any config files
psyrendust-backup() {
  local psyrendust_config_base_development="$(find $HOME -maxdepth 3 -name "oh-my-zsh-psyrendust" -type d 2> /dev/null | grep "github")"
  if [[ -z "$psyrendust_config_base_development" ]]; then
    psyrendust_config_base_development="$(find /cygdrive/z -maxdepth 3 -name "oh-my-zsh-psyrendust" -type d 2> /dev/null | grep "github")"
  fi
  # Only run if one of the base dev locations was found
  if [[ -n $psyrendust_config_base_development ]]; then
    rsync -avr "$HOME/.oh-my-zsh-psyrendust/ConEmu/ConEmu.xml" "$psyrendust_config_base_development/ConEmu/ConEmu.xml"
    rsync -avr "$HOME/.oh-my-zsh-psyrendust/autoHotkeys/" "$psyrendust_config_base_development/autoHotkeys/"
    rsync -avr "$HOME/.oh-my-zsh-psyrendust/fonts/" "$psyrendust_config_base_development/fonts/"
    psyrendust-mkcygwin "$psyrendust_config_base_development/tools/cygwin-setup.bat"
  fi
}

# Get or Set a epoch
psyrendust-epoch() {
  local arg_flag="$1"
  local arg_name="$PSYRENDUST_CONFIG_BASE_PATH/currentepoch-${2:-default}"
  if [[ $arg_flag == "--set" ]]; then
    echo "$(($(date +%s) / 60 / 60 / 24))" > "$arg_name"
  elif [[ $arg_flag == "--get" ]]; then
    [[ -f "$arg_name" ]] && echo "$(cat "$arg_name")"
  fi
}

# Update all global npm packages except for npm, because updating npm using npm
# always breaks. Running npm -g update will result in having to reinstall node.
# This little script will update all global npm packages except for npm.
psyrendust-npmupdate() {
  # Create a clean list of globally installed npm packages
  # npm -g ls --depth=0 2>NUL    List all npm packages at root level
  # grep "──"                    Only list lines that contain a tree prefix "├──" or "└──"
  # awk -F'@' '{print $1}'       Remove trailing version number "@0.0.0"
  # awk '{print $2}'             Only print the 2nd column which contains the names of the package
  # awk  '!/npm/'                Exclude npm in the final list
  npm -g ls --depth=0 2>/dev/null | grep "──" | awk -F'@' '{print $1}' | awk '{print $2}' | awk  '!/npm/' > "$PSYRENDUST_CONFIG_BASE_PATH/npm-g-ls"
  for pkg in $(cat $PSYRENDUST_CONFIG_BASE_PATH/npm-g-ls); do
    npm -g update $pkg
  done
  rm "$PSYRENDUST_CONFIG_BASE_PATH/npm-g-ls"
}

# Helper function: Strips ansi color codes from string
psyrendust-stripansi() {
  if [[ -n $SYSTEM_IS_LINUX ]]; then
    echo $(echo $1 >1 | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})*)?m//g")
  else
    echo $(echo $1 >1 | sed -E "s/"$'\E'"\[([0-9]{1,2}(;[0-9]{1,2})*)?m//g")
  fi
}

# Helper function: Initializes a given plugin if there is a difference in the version info
psyrendust-plugin() {
  local arg_flag="${1}"
  local arg_name="${2}"
  local namespace="plugin-init-$arg_name"
  local plugin_version="$(_psyrendust-version --get "$namespace")"
  local system_version="$(psy stripansi "$(_psyrendust-version --get)")"
  if [[ "$plugin_version" != "$system_version" ]]; then
    if [[ $arg_flag == "--init" ]]; then
      psyrendust-plugin-${arg_name}
      _psyrendust-version --set "$namespace"
    fi
  fi
}

# Helper function: Helps with getting what you want out of a path
# -p: base path
# -e: file extension
# -f: file name with no extension
# -F: file name with extension
psyrendust-path() {
  while getopts "pfFe" opts; do
    [[ $opts == "p" ]] && local option="p" && continue
    [[ $opts == "f" ]] && local option="f" && continue
    [[ $opts == "F" ]] && local option="F" && continue
    [[ $opts == "e" ]] && local option="e" && continue
  done
  shift
  local path_p=${1%/*}
  local path_f=${1##*/}
  local path_F=${path_f%.*}
  local path_e=${path_f##*.}
  case $option in
    p) echo $path_p;;
    f) echo $path_f;;
    F) echo $path_F;;
    e) echo $path_e;;
    *) echo $1;;
  esac
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

# Get or set oh-my-zsh-psyrendust version number
_psyrendust-version() {
  local arg_flag="$1"
  if [[ $arg_flag == "--set" ]]; then
    cd "$ZSH_CUSTOM"
    local version_file="$PSYRENDUST_CONFIG_BASE_PATH/version"
    # Get the version string from git (eg. v0.1.4-248-g5840656)
    local version=$(git describe)
    # Get the tag number (eg. v0.1.4)
    local version_tag=$(echo $version | cut -d- -f 1)
    # Get the total number of commits (eg. 248)
    local version_commit=$(echo $version | cut -d- -f 2)
    # Get the latest sha (eg. g5840656)
    local version_sha=$(echo $version | cut -d- -f 3)
    # Get the date of the latest commit (eg. 2014-03-03)
    local version_date=$(echo $(git show -s --format=%ci | cut -d\  -f 1))
    # Output version info to a file (eg. oh-my-zsh-psyrendust v0.1.4p244 (2014-03-03 revision g67cfc97))
    echo "pppurple -i \"oh-my-zsh-psyrendust \"" > "$version_file"
    echo "pplightpurple \"${version_tag}p${version_commit} (${version_date} revision ${version_sha})\"" >> "$version_file"
  else
    # Get the version info, if it doesn't exist create one
    [[ -f "$PSYRENDUST_CONFIG_BASE_PATH/version" ]] || _psyrendust-version --set
    source "$PSYRENDUST_CONFIG_BASE_PATH/version"
  fi
}

# Initialize autocompletion.
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

_psyrendust-exec-setup() {
  # Setup psyrendust's own completion.
  compdef _psyrendust-exec-compadd psy
}

# Setup psyrendust's autocompletion
_psyrendust-exec-compadd() {
  eval "compadd \
    $(echo $(print -l ${(ok)functions} | grep "psyrendust-" | sed "s/psyrendust-//g"))"
}

_psyrendust-exec-setup
