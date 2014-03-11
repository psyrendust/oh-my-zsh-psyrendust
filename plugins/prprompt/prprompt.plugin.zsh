#!/usr/bin/env zsh


# Create vars to hold the path of our config files
# ------------------------------------------------------------------------------
[[ -f $PSYRENDUST_CONFIG_PRPROMPT_ORIGINAL ]] || PSYRENDUST_CONFIG_PRPROMPT_ORIGINAL="$PSY_RPROMPT/original"
[[ -f $PSYRENDUST_CONFIG_PRPROMPT_NEW ]] || PSYRENDUST_CONFIG_PRPROMPT_NEW="$PSY_RPROMPT/new"
[[ -f $PSYRENDUST_CONFIG_PRPROMPT_STATUS ]] || PSYRENDUST_CONFIG_PRPROMPT_STATUS="$PSY_RPROMPT/status"
[[ -n $PSYRENDUST_CONFIG_PRPROMPT_ID ]] || PSYRENDUST_CONFIG_PRPROMPT_ID="%F{magenta}[ Psyrendust ]%f"



# Create vars to hold chevron total and progress
# ------------------------------------------------------------------------------
PSYRENDUST_CONFIG_PRPROMPT_PROGRESS_ARRAY=()
PSYRENDUST_CONFIG_PRPROMPT_PROGRESS_CURRENT=1



# Chevron for completion chevron
# Left three eighths block: ▍
# Unicode hexadecimal: 0x258d
# In block: Block Elements
# ------------------------------------------------------------------------------
PSYRENDUST_CONFIG_PRPROMPT_PROGRESS_CHEVRON=(
  "%B%F{black}▍%f%b"  #  Incomplete: Dark Gray
  "%B%F{green}▍%f%b"  # In Progress: Light Green
    "%F{green}▍%f"    #    Complete: Green
    "%B%F{red}▍%f%b"  #       Error: Light Red
)



# ------------------------------------------------------------------------------
# RPROMPT manipulation functions
# ------------------------------------------------------------------------------
# Prepends a series of progress chevron to the original RPROMPT defined by the theme
# Output chevron in brown for incomplete status
# Output chevron in green for complete status
# Accepts a number that represents the current state
# ------------------------------------------------------------------------------
_psyrendust-rprompt-chevron() {
  # Set the previous chevron to complete
  PSYRENDUST_CONFIG_PRPROMPT_PROGRESS_ARRAY[$PSYRENDUST_CONFIG_PRPROMPT_PROGRESS_CURRENT]=3
  # Increment the current indicator
  PSYRENDUST_CONFIG_PRPROMPT_PROGRESS_CURRENT=$((PSYRENDUST_CONFIG_PRPROMPT_PROGRESS_CURRENT+1))
  # Check to see if our progress is complete
  if [[ $PSYRENDUST_CONFIG_PRPROMPT_PROGRESS_CURRENT -le ${#PSYRENDUST_CONFIG_PRPROMPT_PROGRESS_ARRAY} ]]; then
    # Set the current chevron to in progress
    PSYRENDUST_CONFIG_PRPROMPT_PROGRESS_ARRAY[$PSYRENDUST_CONFIG_PRPROMPT_PROGRESS_CURRENT]=2
  else
    # Progress is complete
    plog "rprompt-update" "progress complete"
    PSYRENDUST_CONFIG_PRPROMPT_PROGRESS_COMPLETE=1
  fi
  # Reset the progress string
  psyrendust_prprompt_progress_string=""
  for chevron in ${PSYRENDUST_CONFIG_PRPROMPT_PROGRESS_ARRAY}; do
    psyrendust_prprompt_progress_string="${psyrendust_prprompt_progress_string}${PSYRENDUST_CONFIG_PRPROMPT_PROGRESS_CHEVRON[$chevron]}"
  done
  echo -n "$psyrendust_prprompt_progress_string $PSYRENDUST_CONFIG_PRPROMPT_ID $(cat $PSYRENDUST_CONFIG_PRPROMPT_ORIGINAL)" > $PSYRENDUST_CONFIG_PRPROMPT_NEW
  plog "rprompt-update" "chevron $(cat $PSYRENDUST_CONFIG_PRPROMPT_NEW)"
  RPROMPT='$(cat $PSYRENDUST_CONFIG_PRPROMPT_NEW)'
  if [[ -n $PSYRENDUST_CONFIG_PRPROMPT_PROGRESS_COMPLETE ]]; then
    {
      sleep 1
      plog "rprompt-update" "set progress status to 1"
      _psyrendust-config-rprompt-status-update 1
    } &!
  fi
}

# Prepends a custom message to the original RPROMPT defined by the theme
# Output is in magenta
# ------------------------------------------------------------------------------
_psyrendust-rprompt-update() {
  echo -n "%F{magenta}${1} ${PSYRENDUST_CONFIG_PRPROMPT_ID}%f $(cat $PSYRENDUST_CONFIG_PRPROMPT_ORIGINAL)" > $PSYRENDUST_CONFIG_PRPROMPT_NEW
  plog "rprompt-update" "update $(cat $PSYRENDUST_CONFIG_PRPROMPT_NEW)"
  RPROMPT='$(cat $PSYRENDUST_CONFIG_PRPROMPT_NEW)'
}

# Prepends a custom message to the original RPROMPT defined by the theme
# Output is in red
# ------------------------------------------------------------------------------
_psyrendust-rprompt-update-error() {
  echo -n "%F{red}${1} ${PSYRENDUST_CONFIG_PRPROMPT_ID}%f $(cat $PSYRENDUST_CONFIG_PRPROMPT_ORIGINAL)" > $PSYRENDUST_CONFIG_PRPROMPT_NEW
  plog "rprompt-update" "update-error $(cat $PSYRENDUST_CONFIG_PRPROMPT_NEW)"
  RPROMPT='$(cat $PSYRENDUST_CONFIG_PRPROMPT_NEW)'
}

# Prepends a custom message to the original RPROMPT defined by the theme
# Output is in red
# ------------------------------------------------------------------------------
_psyrendust-rprompt-update-success() {
  echo -n "%F{green}${1} ${PSYRENDUST_CONFIG_PRPROMPT_ID}%f $(cat $PSYRENDUST_CONFIG_PRPROMPT_ORIGINAL)" > $PSYRENDUST_CONFIG_PRPROMPT_NEW
  plog "rprompt-update" "update-success $(cat $PSYRENDUST_CONFIG_PRPROMPT_NEW)"
  RPROMPT='$(cat $PSYRENDUST_CONFIG_PRPROMPT_NEW)'
}

# Resets the original RPROMPT back to the original state defined by the theme
# ------------------------------------------------------------------------------
_psyrendust-rprompt-reset() {
  plog "rprompt-update" "reset"
  RPROMPT=$(echo "$(cat $PSYRENDUST_CONFIG_PRPROMPT_ORIGINAL)")
}

# Update the prprompt status
# ------------------------------------------------------------------------------
_psyrendust-config-rprompt-status-update() {
  plog "rprompt-update" "PSYRENDUST_PRPROMPT_STATUS=${1}"
  echo "PSYRENDUST_PRPROMPT_STATUS=${1}" > $PSYRENDUST_CONFIG_PRPROMPT_STATUS
}



# ------------------------------------------------------------------------------
# prprompt: Right prompt status message
# ------------------------------------------------------------------------------
# Usage: prprompt [-x|-e|-s|-m] MESSAGE
# Usage: prprompt [-p] TOTAL_PROGRESS
# Usage: prprompt [-p|-P|-E]
# ------------------------------------------------------------------------------
prprompt() {
  # Accepts an optional flag
  # ----------------------------------------------------------------------------
  while getopts "xpPwEesm" opt; do
    [[ $opt == "x" ]] && option=1 # Stop processing updates and reset message back to original RPROMPT
    [[ $opt == "p" ]] && option=2 # Output progress with chevrons and show current chevron as in progress [light green].
    [[ $opt == "P" ]] && option=3 # Output progress with chevrons and show current chevron as completed [green]
    [[ $opt == "w" ]] && option=4 # Output progress with chevrons and show current chevron as a warning [yellow]
    [[ $opt == "E" ]] && option=5 # Output progress with chevrons and show current chevron as a error [red]
    [[ $opt == "e" ]] && option=6 # Output error message
    [[ $opt == "s" ]] && option=7 # Output success message
    [[ $opt == "m" ]] && option=8 # Output message
  done

  # Shift the params if an option exists
  if [[ -n $option ]]; then
    shift
  else
  option=8
  fi

  case $option in
    2)
      # -p = 2: Output progress with chevrons and show current chevron as in progress [light green]
      # If an argument is passed then set total number of chevron to display and start
      # the progress at the beginning.
      if [[ -n $1 ]]; then
        PSYRENDUST_CONFIG_PRPROMPT_PROGRESS_ARRAY=($(for i in `seq $1`; do echo "1"; done | xargs echo))
        PSYRENDUST_CONFIG_PRPROMPT_PROGRESS_CURRENT=1
      fi
      _psyrendust-rprompt-chevron
      _psyrendust-config-rprompt-status-update $option
      TMOUT=1
      ;;
    [3-5])
      # -P = [3-5]: Output progress with chevrons
      _psyrendust-rprompt-chevron
      _psyrendust-config-rprompt-status-update $option
      TMOUT=1
      ;;
    [6-8])
      # -s = [6-8]: Output error, success, or default message
      _psyrendust-rprompt-update-success $1
      _psyrendust-config-rprompt-status-update $option
      TMOUT=1
      ;;
    *)
      # -x = [1|*]: Stop processing updates and reset message back to original RPROMPT
      _psyrendust-config-rprompt-status-update 1
      ;;
  esac
}


plog -d "rprompt-update"
setopt prompt_subst


# Store a reference to any RPROMPTS that have been set by a theme
# ------------------------------------------------------------------------------
echo -n "$RPROMPT" > $PSYRENDUST_CONFIG_PRPROMPT_ORIGINAL


# Update the RPROMPT to display the original RPROMPT along with any message we
# want to send to it
# ------------------------------------------------------------------------------
TMOUT=1
TRAPALRM() {
  plog "rprompt-update" "[ TRAPALRM ]"
  if [[ -f "$PSYRENDUST_CONFIG_PRPROMPT_STATUS" ]]; then
    source "$PSYRENDUST_CONFIG_PRPROMPT_STATUS"
    case $PSYRENDUST_PRPROMPT_STATUS in
      # Stop processing updates and reset message back to original RPROMPT
      1)
        _psyrendust-rprompt-reset
        zle reset-prompt
        PSYRENDUST_CONFIG_PRPROMPT_PROGRESS_ARRAY=()
        PSYRENDUST_CONFIG_PRPROMPT_PROGRESS_CURRENT=1
        [[ -f "$PSYRENDUST_CONFIG_PRPROMPT_ORIGINAL" ]] && rm "$PSYRENDUST_CONFIG_PRPROMPT_ORIGINAL"
        [[ -f "$PSYRENDUST_CONFIG_PRPROMPT_NEW" ]] && rm "$PSYRENDUST_CONFIG_PRPROMPT_NEW"
        [[ -f "$PSYRENDUST_CONFIG_PRPROMPT_STATUS" ]] && rm "$PSYRENDUST_CONFIG_PRPROMPT_STATUS"
        plog "rprompt-update" "[ TRAPALRM ] | TMOUT: ${TMOUT}##"
        unset TMOUT
        ;;
      # Start processing updates
      *)
        TMOUT=1
        zle reset-prompt
        plog "rprompt-update" "[ TRAPALRM ] - status: $PSYRENDUST_PRPROMPT_STATUS | TMOUT: ${TMOUT}##"
        ;;
    esac
  fi
}
