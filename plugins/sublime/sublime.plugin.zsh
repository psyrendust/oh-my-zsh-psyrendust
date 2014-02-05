# Sublime Text 2/3 plugin
# Open path or files in Sublime Text 3 or Sublime Text 2
# Uses a sleep command to fix a bug with ST opening
# with no files/folders showing in the sidebar
#
# param: path or files to open
# $ sbl .
# $ sbl filename.txt
# $ sbl file1.txt file2.txt
local _sublime_darwin_paths > /dev/null 2>&1
local _sublime_win_paths > /dev/null 2>&1
_sublime_darwin_paths=(
  "$HOME/Applications/Sublime Text.app"
  "/Applications/Sublime Text.app"
  "$HOME/Applications/Sublime Text 2.app"
  "/Applications/Sublime Text 2.app"
)
_sublime_win_paths=(
  "/cygdrive/c/Program Files/Sublime Text 3/sublime_text.exe"
  "/cygdrive/c/Program Files/Sublime Text 2/sublime_text.exe"
)

if  [[ -n $SYSTEM_IS_MAC ]]; then
  for _sublime_path in $_sublime_darwin_paths; do
    if [[ -a $_sublime_path ]]; then
      # Aliases that need to happen after plugins are loaded
      ln -sf "$_sublime_path/Contents/SharedSupport/bin/subl" /usr/local/bin/subl
      break
    fi
  done
  unset _sublime_path

elif  [[ -n $SYSTEM_IS_CYGWIN ]]; then

  for _sublime_path in $_sublime_win_paths; do
    if [[ -a $_sublime_path ]]; then
      ln -sf "$_sublime_path" /usr/local/bin/subl
      break
    fi
  done
  unset _sublime_path

fi

function sbl {

  if  [[ -n $SYSTEM_IS_MAC ]]; then

    subl $1

  elif  [[ -n $SYSTEM_IS_CYGWIN ]]; then

    subl `cygpath -w $@` &

  elif [[ -n $SYSTEM_IS_LINUX ]]; then

    if [ -f '/usr/bin/sublime_text' ]; then
      nohup /usr/bin/sublime_text $@ > /dev/null &
    else
      nohup /usr/bin/sublime-text $@ > /dev/null &
    fi

  fi
}
