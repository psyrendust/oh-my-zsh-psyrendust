#!/usr/bin/env zsh
#
# Initialize which plugins to load into oh-my-zsh
#
# Authors:
#   Larry Gordon
#
# Which plugins would you like to load? (plugins can be found in ~/.psyrendust/repos/.oh-my-zsh/plugins/*)
# Custom plugins will be copied from the following locations into ~/.psyrendust/plugins:
#  ~/.psyrendust/repos/psyrendust/plugins/
#  ~/.psyrendust/repos/work/plugins/
#  ~/.psyrendust/repos/user/plugins/
#
# Custom plugins will be loaded from ~/.psyrendust/plugins/*
# Using zstyle:
#
# # Set default plugins from psyrendust
# zstyle ':psyrendust:load:psyrendust:default' plugins \
#   'git' \
#   'lighthouse'
#
# # Set mac default plugins from psyrendust
# zstyle ':psyrendust:load:psyrendust:mac' plugins \
#   'rails' \
#   'textmate' \
#   'ruby'
#
# ------------------------------------------------------------------------------

# Set default plugins from oh-my-zsh
zstyle -a ':psyrendust:load:oh-my-zsh:default' plugins 'psyrendust_load_oh_my_zsh_default'
if (( ${#psyrendust_load_oh_my_zsh_default[@]} == 0 )); then
  psyrendust_load_oh_my_zsh_default=(git gitfast)
fi

# Set default plugins from psyrendust
zstyle -a ':psyrendust:load:psyrendust:default' plugins 'psyrendust_load_psyrendust_default'
if (( ${#psyrendust_load_psyrendust_default[@]} == 0 )); then
  psyrendust_load_psyrendust_default=()
fi

# Set default system plugins from psyrendust
if [[ -n $SYSTEM_IS_MAC ]]; then
  # Set mac default plugins from psyrendust
  zstyle -a ':psyrendust:load:psyrendust:mac' plugins 'psyrendust_load_psyrendust_system'
  if (( ${#psyrendust_load_psyrendust_system[@]} == 0 )); then
    psyrendust_load_psyrendust_system=()
  fi
elif [[ -n $SYSTEM_IS_CYGWIN ]]; then
  # Set win default plugins from psyrendust
  zstyle -a ':psyrendust:load:psyrendust:win' plugins 'psyrendust_load_psyrendust_system'
  if (( ${#psyrendust_load_psyrendust_system[@]} == 0 )); then
    psyrendust_load_psyrendust_system=(cygwin-gem cygwin-ln)
  fi
fi

# Set default plugins from work
zstyle -a ':psyrendust:load:work:default' plugins 'psyrendust_load_work_default'
if (( ${#psyrendust_load_work_default[@]} == 0 )); then
  psyrendust_load_work_default=()
fi

# Set default system plugins from work
if [[ -n $SYSTEM_IS_MAC ]]; then
  # Set mac default plugins from work
  zstyle -a ':psyrendust:load:work:mac' plugins 'psyrendust_load_work_system'
  if (( ${#psyrendust_load_work_system[@]} == 0 )); then
    psyrendust_load_work_system=()
  fi
elif [[ -n $SYSTEM_IS_CYGWIN ]]; then
  # Set windows default plugins from work
  zstyle -a ':psyrendust:load:work:win' plugins 'psyrendust_load_work_system'
  if (( ${#psyrendust_load_work_system[@]} == 0 )); then
    psyrendust_load_work_system=()
  fi
fi

# Set default plugins from user
zstyle -a ':psyrendust:load:user:default' plugins 'psyrendust_load_user_default'
if (( ${#psyrendust_load_user_default[@]} == 0 )); then
  psyrendust_load_user_default=()
fi

# Set default system plugins from user
if [[ -n $SYSTEM_IS_MAC ]]; then
  # Set mac default plugins from user
  zstyle -a ':psyrendust:load:user:mac' plugins 'psyrendust_load_user_system'
  if (( ${#psyrendust_load_user_system[@]} == 0 )); then
    psyrendust_load_user_system=()
  fi
elif [[ -n $SYSTEM_IS_CYGWIN ]]; then
  # Set windows default plugins from user
  zstyle -a ':psyrendust:load:user:win' plugins 'psyrendust_load_user_system'
  if (( ${#psyrendust_load_user_system[@]} == 0 )); then
    psyrendust_load_user_system=()
  fi
fi



plugins=(
  "${psyrendust_load_oh_my_zsh_default[@]}"
  "${psyrendust_load_psyrendust_default[@]}"
  "${psyrendust_load_psyrendust_system[@]}"
  "${psyrendust_load_work_default[@]}"
  "${psyrendust_load_work_system[@]}"
  "${psyrendust_load_user_default[@]}"
  "${psyrendust_load_user_system[@]}"
)



unset psyrendust_load_oh_my_zsh_default
unset psyrendust_load_psyrendust_default
unset psyrendust_load_psyrendust_system
unset psyrendust_load_work_default
unset psyrendust_load_work_system
unset psyrendust_load_user_default
unset psyrendust_load_user_system
