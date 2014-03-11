#!/usr/bin/env zsh

# Log helper functions
# ------------------------------------------------------------------------------
# Usage: man plog

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
  if [[ -s "$PSY_LOGS/${1}.log" ]]; then
    rm "$PSY_LOGS/${1}.log"
  fi
  if [[ -s "$PSY_LOGS/error-${1}.log" ]]; then
    rm "$PSY_LOGS/error-${1}.log"
  fi
elif [[ $option == 2 ]]; then
  # Append a message ($2) to an error logfile for a given namespace ($1)
  echo "$(date): $2" >> "$PSY_LOGS/error-${1}.log"
else
  # Append a message ($2) to a logfile for a given namespace ($1)
  echo "$(date): $2" >> "$PSY_LOGS/${1}.log"
fi
