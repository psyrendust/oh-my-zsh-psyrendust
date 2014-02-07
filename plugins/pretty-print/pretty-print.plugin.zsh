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

# Setup path to pretty-print folder
# ----------------------------------------------------------
psyrendust_pretty_print=$HOME/.oh-my-zsh-psyrendust/plugins/pretty-print

# Cleanup old references
# ----------------------------------------------------------
[[ -s /usr/local/bin/pperror ]]       && rm -f /usr/local/bin/pperror
[[ -s /usr/local/bin/ppinfo ]]        && rm -f /usr/local/bin/ppinfo
[[ -s /usr/local/bin/ppquestion ]]    && rm -f /usr/local/bin/ppquestion
[[ -s /usr/local/bin/ppsuccess ]]     && rm -f /usr/local/bin/ppsuccess
[[ -s /usr/local/bin/ppblack ]]       && rm -f /usr/local/bin/ppblack
[[ -s /usr/local/bin/ppblue ]]        && rm -f /usr/local/bin/ppblue
[[ -s /usr/local/bin/ppbrown ]]       && rm -f /usr/local/bin/ppbrown
[[ -s /usr/local/bin/ppcyan ]]        && rm -f /usr/local/bin/ppcyan
[[ -s /usr/local/bin/ppdarkgray ]]    && rm -f /usr/local/bin/ppdarkgray
[[ -s /usr/local/bin/ppgreen ]]       && rm -f /usr/local/bin/ppgreen
[[ -s /usr/local/bin/pplightblue ]]   && rm -f /usr/local/bin/pplightblue
[[ -s /usr/local/bin/pplightcyan ]]   && rm -f /usr/local/bin/pplightcyan
[[ -s /usr/local/bin/pplightgray ]]   && rm -f /usr/local/bin/pplightgray
[[ -s /usr/local/bin/pplightgreen ]]  && rm -f /usr/local/bin/pplightgreen
[[ -s /usr/local/bin/pplightpurple ]] && rm -f /usr/local/bin/pplightpurple
[[ -s /usr/local/bin/pplightred ]]    && rm -f /usr/local/bin/pplightred
[[ -s /usr/local/bin/pppurple ]]      && rm -f /usr/local/bin/pppurple
[[ -s /usr/local/bin/ppred ]]         && rm -f /usr/local/bin/ppred
[[ -s /usr/local/bin/ppwhite ]]       && rm -f /usr/local/bin/ppwhite
[[ -s /usr/local/bin/ppyellow ]]      && rm -f /usr/local/bin/ppyellow

# Create color based aliases
# ----------------------------------------------------------
alias ppblack="$psyrendust_pretty_print/pretty-print-black.zsh"
alias ppblue="$psyrendust_pretty_print/pretty-print-blue.zsh"
alias ppbrown="$psyrendust_pretty_print/pretty-print-brown.zsh"
alias ppcyan="$psyrendust_pretty_print/pretty-print-cyan.zsh"
alias ppdarkgray="$psyrendust_pretty_print/pretty-print-dark-gray.zsh"
alias ppgreen="$psyrendust_pretty_print/pretty-print-green.zsh"
alias pplightblue="$psyrendust_pretty_print/pretty-print-light-blue.zsh"
alias pplightcyan="$psyrendust_pretty_print/pretty-print-light-cyan.zsh"
alias pplightgray="$psyrendust_pretty_print/pretty-print-light-gray.zsh"
alias pplightgreen="$psyrendust_pretty_print/pretty-print-light-green.zsh"
alias pplightpurple="$psyrendust_pretty_print/pretty-print-light-purple.zsh"
alias pplightred="$psyrendust_pretty_print/pretty-print-light-red.zsh"
alias pppurple="$psyrendust_pretty_print/pretty-print-purple.zsh"
alias ppred="$psyrendust_pretty_print/pretty-print-red.zsh"
alias ppwhite="$psyrendust_pretty_print/pretty-print-white.zsh"
alias ppyellow="$psyrendust_pretty_print/pretty-print-yellow.zsh"


# Create status based aliases
# ----------------------------------------------------------
# alias ppblue="$psyrendust_pretty_print/pretty-print-blue.zsh"
# alias ppbrown="$psyrendust_pretty_print/pretty-print-brown.zsh"
# alias ppcyan="$psyrendust_pretty_print/pretty-print-cyan.zsh"
# alias ppdarkgray="$psyrendust_pretty_print/pretty-print-dark-gray.zsh"
# alias ppgreen="$psyrendust_pretty_print/pretty-print-green.zsh"
# alias pplightblue="$psyrendust_pretty_print/pretty-print-light-blue.zsh"
# alias pplightcyan="$psyrendust_pretty_print/pretty-print-light-cyan.zsh"
# alias pplightgray="$psyrendust_pretty_print/pretty-print-light-gray.zsh"
# alias pplightgreen="$psyrendust_pretty_print/pretty-print-light-green.zsh"
# alias pplightpurple="$psyrendust_pretty_print/pretty-print-light-purple.zsh"
# alias pplightred="$psyrendust_pretty_print/pretty-print-light-red.zsh"
# alias pppurple="$psyrendust_pretty_print/pretty-print-purple.zsh"
# alias ppred="$psyrendust_pretty_print/pretty-print-red.zsh"
# alias ppwhite="$psyrendust_pretty_print/pretty-print-white.zsh"
# alias ppyellow="$psyrendust_pretty_print/pretty-print-yellow.zsh"
# alias pperror="pbred"
# alias ppinfo=""
# alias ppquestion=""
# alias ppsuccess=""


# Test colors
# ----------------------------------------------------------
function prettyprint-test-colors() {
  for pp_alias in $(alias | grep -e "^pp" | cut -d= -f 1 | xargs echo); do
    $pp_alias "${pp_alias}: testing pretty print"
  done
}
