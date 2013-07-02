_npp_win_paths=(
  "/cygdrive/c/Program Files/Notepad++/notepad++.exe"
  "/cygdrive/c/Program Files (x86)/Notepad++/notepad++.exe"
)
for _npp_path in $_npp_win_paths; do
  if [[ -a $_npp_path ]]; then
    NPP_APP="$_npp_path"
    break
  fi
done

function npp() {
  "$NPP_APP" `cygpath.exe -w "$@"`
}