#!/usr/bin/env zsh
# name: migrate.zsh
# author: Larry Gordon
#
# My starter script for migrating your shell environment!
# This is helpful if something got borked!
# ------------------------------------------------------------------------------



# Get the location of this script relative to the cwd
# ------------------------------------------------------------------------------
psy_migrate="$0"

# While the filename in $psy_migrate is a symlink
while [ -L "$psy_migrate" ]; do
  # similar to above, but -P forces a change to the physical not symbolic directory
  psy_migrate_cwd="$( cd -P "$( dirname "$psy_migrate" )" && pwd )"

  # Get the value of symbolic link
  # If $psy_migrate is relative (doesn't begin with /), resolve relative
  # path where symlink lives
  psy_migrate="$(readlink -f "$psy_migrate")" && psy_migrate="$psy_migrate_cwd/$psy_migrate"
done
psy_migrate_cwd="$( cd -P "$( dirname "$psy_migrate" )" && pwd )"
psy_migrate_root="${psy_migrate_cwd%/*}"


# Source .zprofile to get global paths and vars
# ------------------------------------------------------------------------------
source $psy_migrate_root/templates/.zprofile


# Copy over plugins, templates, and themes
# ------------------------------------------------------------------------------
if [[ -n $SYSTEM_IS_CYGWIN ]]; then
  local system_os="win"
else
  local system_os="mac"
fi
cp -aR "$PSY_SRC_TEMPLATES/home/." "$HOME/"
cp -aR "$PSY_SRC_TEMPLATES/home-${system_os}/." "$HOME/"
cp -aR "$PSY_SRC_TEMPLATES_CONFIG/win/." "$PSY_CONFIG_WIN/"
cp -aR "$PSY_SRC_TEMPLATES_CONFIG/git/." "$PSY_CONFIG_GIT/"
cp -an "$PSY_SRC_TEMPLATES_CONFIG/git/custom-{mac,win}.gitconfig" "$PSY_CONFIG_GIT/"
cp -aR "$PSY_SRC_PLUGINS/." "$PSY_PLUGINS/"
cp -aR "$PSY_SRC_THEMES/." "$PSY_THEMES/"

unset system_os
