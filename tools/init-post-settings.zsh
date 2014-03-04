#!/usr/bin/env zsh

# Run a few things after Oh My Zsh has finished initializing
# ------------------------------------------------------------------------------
if [[ -n $SYSTEM_IS_CYGWIN ]]; then
  # Install gem helper aliases
  # ----------------------------------------------------------------------------
  if [[ -n "$(which ruby 2>/dev/null)" ]]; then
    _psyrendust-gem-alias "install"
  fi



  # If we are using Cygwin and ZSH_THEME is Pure, then replace the prompt
  # character to something that works in Windows
  # ----------------------------------------------------------------------------
  if [[ $ZSH_THEME == "pure" ]]; then
    PROMPT=$(echo $PROMPT | tr "❯" "›")
  fi
fi



# Settings for zsh-syntax-highlighting plugin
# ----------------------------------------------------------------------------------------------------------------------
# ASSIGNMENTS                                                                 # DEFAULT VALUE         DESCRIPTION
# ----------------------------------------------------------------------------------------------------------------------
ZSH_HIGHLIGHT_STYLES[default]=none                                            # none                  : parts of the buffer that do not match anything
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red,bold                               # fg=red,bold           : unknown tokens / errors
ZSH_HIGHLIGHT_STYLES[reserved-word]=yellow,bold                                    # fg=yellow             : shell reserved words

ZSH_HIGHLIGHT_STYLES[alias]=fg=green                                          # fg=green              : aliases
ZSH_HIGHLIGHT_STYLES[builtin]=fg=green                                        # fg=green              : shell builtin commands
ZSH_HIGHLIGHT_STYLES[command]=fg=green                                        # fg=green              : commands
ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=green                               # none                  : command separation tokens
ZSH_HIGHLIGHT_STYLES[precommand]=fg=green                                     # fg=green,underline    : precommands (i.e. exec, builtin, ...)
ZSH_HIGHLIGHT_STYLES[function]=fg=green                                       # fg=green              : functions
ZSH_HIGHLIGHT_STYLES[hashed-command]=fg=green                                 # fg=green              : hashed commands
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=green,bold                      # none                  : single hyphen options
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=green,bold                      # none                  : double hyphen options


ZSH_HIGHLIGHT_STYLES[assign]=fg=magenta,bold                                  # none                  : variable assignments
ZSH_HIGHLIGHT_STYLES[globbing]=fg=magenta,bold                                # fg=blue               : globbing expressions
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=magenta                # fg=cyan               : dollar double quoted arguments


ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=blue,bold                     # fg=yellow             : single quoted arguments
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=blue,bold                     # fg=yellow             : double quoted arguments

ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=fg=cyan,bold                       # none                  : backquoted expressions
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=cyan,bold                # fg=cyan               : back double quoted arguments
ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=cyan,bold                          # fg=blue               : history expansion expressions

ZSH_HIGHLIGHT_STYLES[path]=fg=blue,bold                                       # underline             : paths
ZSH_HIGHLIGHT_STYLES[path_approx]=fg=blue,bold                                # fg=yellow,underline   : approximated paths
ZSH_HIGHLIGHT_STYLES[path_prefix]=fg=blue,bold                                # underline             : path prefixes




# ------------------------------------------------------------------------------
# Setup autocompletion for psyrendust-* functions
# Borrowed from Antigen (https://github.com/zsh-users/antigen)
# ------------------------------------------------------------------------------
# Used to defer compinit/compdef
typeset -a __psyrendust_deferred_compdefs
compdef () { __psyrendust_deferred_compdefs=($__psyrendust_deferred_compdefs "$*") }

psyrendust-apply() {

  # Initialize completion.
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

_psyrendust() {
  eval "compadd \
    $(echo $(print -l ${(ok)functions} | grep "psyrendust-" | sed "s/psyrendust-//g"))"
}

# Setup psyrendust's own completion.
compdef _psyrendust psyrendust

psyrendust apply
