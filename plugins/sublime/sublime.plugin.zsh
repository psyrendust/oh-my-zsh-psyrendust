# Sublime Text 2 plugin
# Open path or files in Sublime Text 2
# Uses a sleep command to fix a bug with ST2 opening
# with no files/folders showing in the sidebar
#
# param: path or files to open
# $ sbl .
# $ sbl filename.txt
# $ sbl file1.txt file2.txt
local _sublime_darwin_paths > /dev/null 2>&1
_sublime_darwin_paths=(
  "$HOME/Applications/Sublime Text 2.app"
  "$HOME/Applications/Sublime Text.app"
  "/Applications/Sublime Text 2.app"
  "/Applications/Sublime Text.app"
)
_sublime_win_paths=(
  "/cygdrive/c/Program Files/Sublime Text 2/sublime_text.exe"
)

if [[ $('uname') == 'Linux' ]]; then
  if [ -f '/usr/bin/sublime_text' ]; then
    ST_RUN() { nohup /usr/bin/sublime_text $@ > /dev/null & }
  else
    ST_RUN() { nohup /usr/bin/sublime-text $@ > /dev/null & }
  fi

elif  [[ $('uname') == 'Darwin' ]]; then
  for _sublime_path in $_sublime_darwin_paths; do
    if [[ -a $_sublime_path ]]; then
      ST_APP="$_sublime_path"
      ST_PATH="$ST_APP/Contents/SharedSupport/bin/subl"
      # Aliases that need to happen after plugins are loaded
      ln -sf "$ST_PATH" /usr/local/bin/subl
      break
    fi
  done

elif  [[ $('uname') == *CYGWIN_NT* ]]; then

  for _sublime_path in $_sublime_win_paths; do
    if [[ -a $_sublime_path ]]; then
      ST_APP="$_sublime_path"
      ln -sf $ST_APP /usr/local/bin/subl
      break
    fi
  done

fi

function sbl ()
{
  if [[ $('uname') == 'Linux' ]]; then

    ST_RUN() "$@"

  elif  [[ $('uname') == 'Darwin' ]]; then

    subl $1

  elif  [[ $('uname') == *CYGWIN_NT* ]]; then

    subl `cygpath -w $@` &

  fi
}
