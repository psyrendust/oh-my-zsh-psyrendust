#!/usr/bin/env zsh
# Check for updates on initial load...
if [[ "$DISABLE_PSYRENDUST_AUTO_UPDATE" != "true" ]] && [[ -f $ZSH_CUSTOM/tools/auto-update.zsh ]]; then
  (/usr/bin/env ZSH=$ZSH ZSH_CUSTOM=$ZSH_CUSTOM DISABLE_PSYRENDUST_AUTO_UPDATE=$DISABLE_PSYRENDUST_AUTO_UPDATE zsh $ZSH_CUSTOM/tools/auto-update.zsh &)
fi
