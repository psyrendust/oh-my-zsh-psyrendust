#!/usr/bin/env zsh

# Color references: numeric-sort
# ----------------------------------------------------------
# Black       0;30     Dark Gray     1;30
# Red         0;31     Light Red     1;31
# Green       0;32     Light Green   1;32
# Brown       0;33     Yellow        1;33
# Blue        0;34     Light Blue    1;34
# Purple      0;35     Light Purple  1;35
# Cyan        0;36     Light Cyan    1;36
# Light Gray  0;37     White         1;37



# Color references: alpha-sort
# ----------------------------------------------------------
# Black         0;30
# Blue          0;34
# Brown         0;33
# Cyan          0;36
# Dark Gray     1;30
# Green         0;32
# Light Blue    1;34
# Light Cyan    1;36
# Light Gray    0;37
# Light Green   1;32
# Light Purple  1;35
# Light Red     1;31
# Purple        0;35
# Red           0;31
# White         1;37
# Yellow        1;33


# Create pretty print aliases
# ----------------------------------------------------------
for ppfile in $(ls "$HOME/.oh-my-zsh-psyrendust/plugins/pretty-print/" | grep "^pretty-print-"); do
  ppshortname=$(echo $ppfile | cut -d- -f 3 | cut -d. -f 1)

  # Create color based aliases
  # --------------------------------------------------------
  alias "pp$ppshortname"="$ZSH_CUSTOM/plugins/pretty-print/$ppfile"

  # Create status based aliases
  # --------------------------------------------------------
  [[ $ppshortname = "green" ]]    && alias "ppsuccess"="$ZSH_CUSTOM/plugins/pretty-print/$ppfile"
  [[ $ppshortname = "cyan" ]]     && alias "ppinfo"="$ZSH_CUSTOM/plugins/pretty-print/$ppfile"
  [[ $ppshortname = "brown" ]]    && alias "ppwarning"="$ZSH_CUSTOM/plugins/pretty-print/$ppfile"
  [[ $ppshortname = "red" ]]      && alias "ppdanger"="$ZSH_CUSTOM/plugins/pretty-print/$ppfile"
  [[ $ppshortname = "purple" ]]   && alias "ppemphasis"="$ZSH_CUSTOM/plugins/pretty-print/$ppfile"
done
unset ppshortname
unset ppfile



# pretty print helper function that will only output messages if verbose is true
# ------------------------------------------------------------------------------
function ppverbose() {
  if [[ -n $PRETTY_PRINT_IS_VERBOSE ]]; then
    if [[ $# < 2 ]]; then
      ppblue "$1"
    else
      ppblue -i "$1: "
      shift
      pplightblue "$@"
    fi
  fi
}


# Test colors
# ----------------------------------------------------------
function prettyprint-test-colors() {
  pppurple " " "    Pretty Print Color Based Aliases"
  pppurple "------------------------------------"
  for ppfile in $(ls "$HOME/.oh-my-zsh-psyrendust/plugins/pretty-print/" | grep "^pretty-print-"); do
    ppshortname=$(echo $ppfile | cut -d- -f 3 | cut -d. -f 1)
    eval "pp$ppshortname \"pp$ppshortname - testing pretty print\" | awk '{ printf \"%20s %s %s %s %s\\n\", \$1, \$2, \$3, \$4, \$5}'"
  done
  pppurple " " " " "   Pretty Print Status Based Aliases"
  pppurple "------------------------------------"
  ppsuccess  "ppsuccess  - testing pretty print" | awk '{ printf "%20s %s %s %s %s\n", $1, $2, $3, $4, $5}'
  ppinfo     "ppinfo     - testing pretty print" | awk '{ printf "%20s %s %s %s %s\n", $1, $2, $3, $4, $5}'
  ppwarning  "ppwarning  - testing pretty print" | awk '{ printf "%20s %s %s %s %s\n", $1, $2, $3, $4, $5}'
  ppdanger   "ppdanger   - testing pretty print" | awk '{ printf "%20s %s %s %s %s\n", $1, $2, $3, $4, $5}'
  ppemphasis "ppemphasis - testing pretty print" | awk '{ printf "%20s %s %s %s %s\n", $1, $2, $3, $4, $5}'
  pppurple " " " " "        Pretty Print Inline Printing"
  pppurple "------------------------------------"
  for ppfile in $(ls "$HOME/.oh-my-zsh-psyrendust/plugins/pretty-print/" | grep "^pretty-print-"); do
    ppshortname=$(echo $ppfile | cut -d- -f 3 | cut -d. -f 1)
    eval "pp$ppshortname -i \"pp$ppshortname \""
  done
}
