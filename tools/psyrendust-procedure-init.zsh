#!/usr/bin/env zsh
# name: " "psyrendust-procedure-init.zsh
# author: Larry Gordon
#
# Source this script to automatically step through each procedure function in
# your script. Allows for automatic resuming of your script if a break in your
# code is detected causing all of your procedure functions to not complete.
#
# Procedure functions will be unfunction'd upon successful completion.
#
#
# Example usage:
# ------------------------------------------------------------------------------
#
#   # Sourcing helper script to call all procedure functions in
#   # this script
#   # -----------------------------------------------------------------
#   if [[ -s "$ZSH_CUSTOM/tools/psyrendust-procedure-init.zsh" ]]; then
#     source "$ZSH_CUSTOM/tools/psyrendust-procedure-init.zsh" $0
#   fi
#
#
# Notes:
# ------------------------------------------------------------------------------
# Make sure you pass `$0` as a parameter when sourcing this script.



# Sourcing pretty-print helpers
#  ppsuccess - green
#     ppinfo - light cyan
#  ppwarning - brown
#   ppdanger - red
# ppemphasis - purple
#  ppverbose - prints out message if PRETTY_PRINT_IS_VERBOSE="true"
# ------------------------------------------------------------------------------
psyrendust source "$ZSH_CUSTOM/plugins/pretty-print/pretty-print.plugin.zsh"



# Sourcing plog helpers
# ------------------------------------------------------------------------------
psyrendust source "$ZSH_CUSTOM/plugins/plog/plog.plugin.zsh"



# Setup variables, detect current progress, and execute each procedure function
# that is found in the script that sourced "psyrendust-procedure-init.zsh".
# ------------------------------------------------------------------------------
# Notes
# psyrendust_pi_script_name=${0##*/}
# psyrendust_pi_script_path=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd -P)/`basename "${BASH_SOURCE[0]}"`${psyrendust_pi_script_name}
# ------------------------------------------------------------------------------
if [[ -n $PRETTY_PRINT_IS_VERBOSE ]]; then
  ppemphasis -i "Processing functions in: "
  pplightpurple "$1"
  ppemphasis "Verbose Mode True"
fi



# Store a reference to the calling script
# ------------------------------------------------------------------------------
psyrendust_pi_script_path=$1
ppverbose "psyrendust_pi_script_path: " "$psyrendust_pi_script_path"

psyrendust_pi_script_namespace=$(echo ${1##*/} | cut -d. -f 1)
ppverbose "psyrendust_pi_script_namespace: " "$psyrendust_pi_script_namespace"



# Configure paths for conf files
# ------------------------------------------------------------------------------
psyrendust_pi_config_breakpoint="$PSYRENDUST_CONFIG_BASE_PATH/${psyrendust_pi_script_namespace}-progress.conf"
ppverbose "psyrendust_pi_config_breakpoint: " "$psyrendust_pi_config_breakpoint"

psyrendust_pi_config_user_info="$PSYRENDUST_CONFIG_BASE_PATH/${psyrendust_pi_script_namespace}-user-info.conf"
ppverbose "psyrendust_pi_config_user_info: " "$psyrendust_pi_config_user_info"

psyrendust_pi_procedure_result="$PSYRENDUST_CONFIG_BASE_PATH/${psyrendust_pi_script_namespace}-procedure-result.conf"
ppverbose "psyrendust_pi_procedure_result: " "$psyrendust_pi_procedure_result"



# Halt if we are already running this process
# ------------------------------------------------------------------------------
if [[ -n $(pprocess -i $psyrendust_pi_script_namespace) ]]; then
  ppverbose "Already processing $psyrendust_pi_script_namespace [Psyrendust]"
  return 0
else
  # Set processing status to true
  pprocess -s "$psyrendust_pi_script_namespace"
fi



# Remove previous results if they exist
# ------------------------------------------------------------------------------
if [[ -s $psyrendust_pi_procedure_result ]]; then
  rm $psyrendust_pi_procedure_result
fi



# Get all procedure functions in calling script
# ------------------------------------------------------------------------------
psyrendust_pi_total_functions=(`cat $psyrendust_pi_script_path | grep "^_psyrendust-procedure-" | cut -d\( -f 1`)
psyrendust_pi_total_functions+=(`cat $psyrendust_pi_script_path | grep "^function _psyrendust-procedure-" | cut -d\  -f 2 | cut -d\( -f 1`)
ppverbose "psyrendust_pi_total_functions: " "$psyrendust_pi_total_functions"

psyrendust_pi_max_breakpoints=$((${#psyrendust_pi_total_functions[@]}))
ppverbose "psyrendust_pi_max_breakpoints: " "$psyrendust_pi_max_breakpoints"



# Sourcing psyrendust_pi_current_breakpoint info
# ------------------------------------------------------------------------------
if [[ -s $psyrendust_pi_config_breakpoint ]]; then
  ppverbose "Sourcing: " "$psyrendust_pi_config_breakpoint"
  source $psyrendust_pi_config_breakpoint
fi
if [[ -z $psyrendust_pi_current_breakpoint ]]; then
  ppverbose "No Breakponts set. Initializing: " "\$psyrendust_pi_current_breakpoint"
  psyrendust_pi_current_breakpoint=1
fi



# Output the current breakpoint
# ------------------------------------------------------------------------------
ppverbose "psyrendust_pi_current_breakpoint: " "$psyrendust_pi_current_breakpoint"



# Sourcing user info
# ------------------------------------------------------------------------------
ppverbose "Sourcing: " "$psyrendust_pi_config_user_info"
psyrendust source "$psyrendust_pi_config_user_info"



# Process each function based on the psyrendust_pi_current_breakpoint
# ------------------------------------------------------------------------------
ppverbose "Process each function based on the psyrendust_pi_current_breakpoint"
for (( psyrendust_pi_procedure_count=$psyrendust_pi_current_breakpoint; psyrendust_pi_procedure_count<=psyrendust_pi_max_breakpoints; psyrendust_pi_procedure_count++ )); do
  ppverbose "for: " "$psyrendust_pi_procedure_count <= $psyrendust_pi_max_breakpoints"


  # Exit if the next function doesn't exist
  ppverbose "Let's see if the next function exists and exit if it doesn't"
  if [[ -n `whence -w ${psyrendust_pi_total_functions[$psyrendust_pi_procedure_count]} | grep "function"` ]]; then
    # Saving the current psyrendust_pi_current_breakpoint for auto resuming of this script
    ppverbose "Saving the current psyrendust_pi_current_breakpoint for auto resuming of this script"
    ppverbose "- psyrendust_pi_current_breakpoint = " "$psyrendust_pi_procedure_count"
    echo "psyrendust_pi_current_breakpoint=$psyrendust_pi_procedure_count" > $psyrendust_pi_config_breakpoint

    # Execute the current procedure function
    ppverbose "Execute procedure function: " "${psyrendust_pi_total_functions[$psyrendust_pi_procedure_count]}"
    ${psyrendust_pi_total_functions[$psyrendust_pi_procedure_count]} 2> $psyrendust_pi_procedure_result

    # Output error and exit if there was a problem
    if [[ -n `cat $psyrendust_pi_procedure_result` ]]; then
      # Set processing status to false
      pprocess -x "$psyrendust_pi_script_namespace"
      ppdanger "An error was reported:"
      ppdanger "$(cat $psyrendust_pi_procedure_result)"
      return 0
    fi

    # Remove the shell function from the command hash table
    ppverbose "Removing shell function from the command hash table: " "${psyrendust_pi_total_functions[$psyrendust_pi_procedure_count]}"
    unfunction -m ${psyrendust_pi_total_functions[$psyrendust_pi_procedure_count]}
  else
    ppdanger -i "The following function does not exist:"
    ppwarning " ${psyrendust_pi_total_functions[$psyrendust_pi_procedure_count]}"
    return 0
  fi
done



# Remove temp files
# ------------------------------------------------------------------------------
ppverbose "Removing temp files:"
if [ -e $psyrendust_pi_config_breakpoint ]; then
  ppverbose "- Removing: " "$psyrendust_pi_config_breakpoint"
  rm -f $psyrendust_pi_config_breakpoint
fi
if [ -e $psyrendust_pi_config_user_info ]; then
  ppverbose "- Removing: " "$psyrendust_pi_config_user_info"
  rm -f $psyrendust_pi_config_user_info
fi
if [ -e $psyrendust_pi_procedure_result ]; then
  ppverbose "- Removing: " "$psyrendust_pi_procedure_result"
  rm -f $psyrendust_pi_procedure_result
fi



# ------------------------------------------------------------------------------
# Cleanup and remove the calling script if it's name contains "run-once"
if [[ -n $(echo ${1##*/} | grep "run-once") ]]; then
  ppverbose "- Removing: " "$1"
  rm -f $1
fi



# Script completed successfully
# ------------------------------------------------------------------------------
ppsuccess "complete!"
if [[ -n $PRETTY_PRINT_IS_VERBOSE ]]; then
  ppsuccess "- $psyrendust_pi_script_path"
fi



# Set processing status to false
# ------------------------------------------------------------------------------
pprocess -x "$psyrendust_pi_script_namespace"



# Remove any local vars and functions from the command hash table
# ------------------------------------------------------------------------------
unset psyrendust_pi_option
unset psyrendust_pi_config_breakpoint
unset psyrendust_pi_config_user_info
unset psyrendust_pi_current_breakpoint
unset psyrendust_pi_max_breakpoints
unset psyrendust_pi_procedure_count
unset psyrendust_pi_procedure_processing
unset psyrendust_pi_procedure_result
unset psyrendust_pi_script_namespace
unset psyrendust_pi_script_path
unset psyrendust_pi_total_functions
