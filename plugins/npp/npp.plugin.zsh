_npp_win_paths=(
  "/cygdrive/c/Program Files/Notepad++/notepad++.exe"
  "/cygdrive/c/Program Files (x86)/Notepad++/notepad++.exe"
)
for _sublime_path in $_sublime_win_paths; do
  if [[ -a $_sublime_path ]]; then
    NPP_APP="$_sublime_path"
    break
  fi
done

function npp() {
  "$NPP_APP" `cygpath.exe -w "$@"`
}