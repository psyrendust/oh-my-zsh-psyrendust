#!/usr/bin/env zsh
#
# gem helper functions
#
# License under MIT Copyright (c) 2014 Larry Gordon
#
# Gem helper functions for use with Cygwin.
# When using Cygwin with Ruby (mingw64) the "gem" command will not work as
# as stated in SO (http://stackoverflow.com/a/4260598/1013618).
# Included is a "gem" wrapper function that creates aliases for each gem when
# opening a new shell. The gem function will also add and remove aliases when
# executing "gem install" and "gem uninstall". All "gem" commands are passed
# along to the native gem function.


# Lists all gems and associated executables installed with gem
# --------------------------------------------------------------------------
_psyrendust-gem-list() {
  echo "${$(ls "$RUBY_BIN" | grep ".bat$" | tr "\n" ":")%:}"
}


# Manage aliases for installed gems
# Adds an alias to the associated .bat when executing "gem install".
# Removes an alias when executing "gem uninstall".
# --------------------------------------------------------------------------
_psyrendust-gem-alias() {
  if [[ $1 == "uninstall" ]]; then
    uninstall_alias=1
  fi
  shift
  gem_file_bats_args=( $(echo $@ | tr ":" " ") )
  gem_file_bats_curr=( $(_psyrendust-gem-list | tr ":" " ") )
  gem_file_bats_diff=()
  # Add gem.bat if the array is empty so that it can be filtered out later.
  # We do this because we have a function called "gem" and we don't need
  # an alias to replace this function.
  [[ ${#gem_file_bats_args} == 0 ]] && gem_file_bats_args=( gem.bat )
  gem_file_bats_sm=("${gem_file_bats_args[@]}")
  gem_file_bats_lg=("${gem_file_bats_curr[@]}")
  # Find the largest array
  if [[ ${#gem_file_bats_sm} -gt ${#gem_file_bats_lg} ]]; then
    gem_file_bats_sm=("${gem_file_bats_curr[@]}")
    gem_file_bats_lg=("${gem_file_bats_args[@]}")
  fi
  # Filter out the unique elements
  for gem_file_bat in "${gem_file_bats_lg[@]}"; do
    if [[ ! -n $(grep "$gem_file_bat" <<< "${gem_file_bats_sm[@]}") ]]; then
      gem_file_bats_diff=("${gem_file_bats_diff[@]}" $gem_file_bat)
    fi
  done
  # Add or remove alias
  for gem_file_bat in $gem_file_bats_diff; do
    if [[ -n $uninstall_alias ]]; then
      unalias "${gem_file_bat%.bat}"
    else
      alias "${gem_file_bat%.bat}"="$RUBY_BIN/$gem_file_bat"
    fi
  done
  unset gem_file_bats_sm
  unset gem_file_bats_lg
  unset gem_file_bats_args
  unset gem_file_bats_curr
  unset gem_file_bats_diff
}



# Wrapper for gem command
# When executing "gem install" or "gem uninstall" the command will manage
# the gems associated aliases.
# --------------------------------------------------------------------------
gem() {
  local gem_file_bats=`_psyrendust-gem-list`
  "$RUBY_BIN/gem.bat" $@
  if [[ -n $(echo $1 | grep "install") ]]; then
    _psyrendust-gem-alias $1 "$gem_file_bats"
  fi
}
