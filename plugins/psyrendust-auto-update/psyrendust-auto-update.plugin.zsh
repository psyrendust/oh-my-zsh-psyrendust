# Check for updates on initial load...
if [ "$DISABLE_AUTO_UPDATE" != "true" ]
then
  /usr/bin/env ZSH=$ZSH zsh $ZSH_CUSTOM/plugins/psyrendust-auto-update/check_for_upgrade.sh
fi