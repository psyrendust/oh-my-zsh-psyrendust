# Sublime Text 2/3 plugin
# Open path or files in Sublime Text 3 or Sublime Text 2
# Uses a sleep command to fix a bug with ST opening
# with no files/folders showing in the sidebar
#
# param: path or files to open
# $ sbl .
# $ sbl filename.txt
# $ sbl file1.txt file2.txt
sublime_paths > /dev/null 2>&1
sublime_paths=(
  "$HOME/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl"
  "$HOME/Applications/Sublime Text 3.app/Contents/SharedSupport/bin/subl"
  "$HOME/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl"
  "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl"
  "/Applications/Sublime Text 3.app/Contents/SharedSupport/bin/subl"
  "/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl"
  "/cygdrive/c/Program Files/Sublime Text 3/sublime_text.exe"
  "/cygdrive/c/Program Files/Sublime Text 2/sublime_text.exe"
)

for sublime_path in $sublime_paths; do
  if [[ -a $sublime_path ]]; then
    # Aliases that need to happen after plugins are loaded
    ln -sf "$sublime_path" /usr/local/bin/subl
    break
  fi
done

unset sublime_path
unset sublime_paths

function sbl {
  if  [[ -n $SYSTEM_IS_MAC ]]; then
    subl $@
  elif  [[ -n $SYSTEM_IS_CYGWIN ]]; then
    cygstart /usr/local/bin/subl $(cygpath -w $@)
  elif [[ -n $SYSTEM_IS_LINUX ]]; then
    if [ -f '/usr/bin/sublime_text' ]; then
      nohup /usr/bin/sublime_text $@ > /dev/null &
    else
      nohup /usr/bin/sublime-text $@ > /dev/null &
    fi
  fi
}
