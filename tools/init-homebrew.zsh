#!/usr/bin/env zsh

# Init homebrew
# ------------------------------------------------------------------------------
if [[ -s "/usr/local/bin/brew" ]]; then
  # Add homebrew Core Utilities
  if [[ -s "$(/usr/local/bin/brew --prefix coreutils)/libexec/gnubin" ]]; then
    export PATH="$(/usr/local/bin/brew --prefix coreutils)/libexec/gnubin:$PATH"
  fi

  # Add manpath
  if [[ -s "/usr/local/share/man" ]]; then
    export MANPATH="/usr/local/share/man:$MANPATH"
  fi

  # Add homebrew Core Utilities man
  if [[ -s "$(/usr/local/bin/brew --prefix coreutils)/libexec/gnuman" ]]; then
    export MANPATH="$(/usr/local/bin/brew --prefix coreutils)/libexec/gnuman:$MANPATH"
  fi

  # Add SSL Cert
  if [[ -s "$(/usr/local/bin/brew --prefix curl-ca-bundle)/share/ca-bundle.crt" ]]; then
    export SSL_CERT_FILE="$(/usr/local/bin/brew --prefix curl-ca-bundle)/share/ca-bundle.crt"
  fi
fi
