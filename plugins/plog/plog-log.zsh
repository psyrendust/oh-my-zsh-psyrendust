#!/usr/bin/env zsh

# Log helper functions
# ------------------------------------------------------------------------------
# Usage: man plog

[[ -d $PSYRENDUST_CONFIG_BASE_PATH ]] || PSYRENDUST_CONFIG_BASE_PATH="$HOME/.psyrendust"

# Accepts an optional flag
while getopts "edl" opt; do
  [[ $opt == "d" ]] && option=1
  [[ $opt == "e" ]] && option=2
  [[ $opt == "l" ]] && option=3
done

# Shift the params if an option exists
if [[ -n $option ]]; then
  shift
fi

if [[ $option == 1 ]]; then
  # Delete the log and error logfile for a given namespace ($1)
  if [[ -s "$PSYRENDUST_CONFIG_BASE_PATH/log-${1}.log" ]]; then
    rm "$PSYRENDUST_CONFIG_BASE_PATH/log-${1}.log"
  fi
  if [[ -s "$PSYRENDUST_CONFIG_BASE_PATH/log-error-${1}.log" ]]; then
    rm "$PSYRENDUST_CONFIG_BASE_PATH/log-error-${1}.log"
  fi
elif [[ $option == 2 ]]; then
  # Append a message ($2) to an error logfile for a given namespace ($1)
  echo "$(date): $2" >> "$PSYRENDUST_CONFIG_BASE_PATH/log-error-${1}.log"
else
  # Append a message ($2) to a logfile for a given namespace ($1)
  echo "$(date): $2" >> "$PSYRENDUST_CONFIG_BASE_PATH/log-${1}.log"
fi
