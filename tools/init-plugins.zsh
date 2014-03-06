#!/usr/bin/env zsh
#
# Initialize which plugins to load into oh-my-zsh
#
# Authors:
#   Larry Gordon
#
# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# ------------------------------------------------------------------------------

# Set default plugins from oh-my-zsh
zstyle -a ':psyrendust:load:oh-my-zsh:default' plugins 'plugins_oh_my_zsh_default'
if (( ${#plugins_oh_my_zsh_default[@]} == 0 )); then
  plugins_oh_my_zsh_default=(git gitfast)
fi

# Set default plugins from oh-my-zsh-psyrendust
zstyle -a ':psyrendust:load:oh-my-zsh-psyrendust:default' plugins 'plugins_oh_my_zsh_psyrendust_default'
if (( ${#plugins_oh_my_zsh_psyrendust_default[@]} == 0 )); then
  plugins_oh_my_zsh_psyrendust_default=()
fi

# Set default system plugins from oh-my-zsh-psyrendust
if [[ -n $SYSTEM_IS_MAC ]]; then
  # Set default plugins from oh-my-zsh-psyrendust
  zstyle -a ':psyrendust:load:oh-my-zsh-psyrendust:mac' plugins 'plugins_oh_my_zsh_psyrendust_system'
  if (( ${#plugins_oh_my_zsh_psyrendust_system[@]} == 0 )); then
    plugins_oh_my_zsh_psyrendust_system=()
  fi
elif [[ -n $SYSTEM_IS_CYGWIN ]]; then
  # Set default plugins from oh-my-zsh-psyrendust
  zstyle -a ':psyrendust:load:oh-my-zsh-psyrendust:win' plugins 'plugins_oh_my_zsh_psyrendust_system'
  if (( ${#plugins_oh_my_zsh_psyrendust_system[@]} == 0 )); then
    plugins_oh_my_zsh_psyrendust_system=(cygwin-gem cygwin-ln)
  fi
fi



plugins=(
  "${plugins_oh_my_zsh_default[@]}"
  "${plugins_oh_my_zsh_psyrendust_default[@]}"
  "${plugins_oh_my_zsh_psyrendust_system[@]}"
)

unset plugins_oh_my_zsh_default
unset plugins_oh_my_zsh_psyrendust_default
unset plugins_oh_my_zsh_psyrendust_system
