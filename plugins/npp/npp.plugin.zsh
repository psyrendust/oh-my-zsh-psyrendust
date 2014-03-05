npp_win_paths=(
  "/cygdrive/c/Program Files/Notepad++/notepad++.exe"
  "/cygdrive/c/Program Files (x86)/Notepad++/notepad++.exe"
)
for npp_path in $npp_win_paths; do
  if [[ -a $npp_path ]]; then
    ln -sf "${npp_path}" /usr/local/bin/notepadpp
    break
  fi
done

unset npp_win_paths
unset npp_path

function npp() {
  notepadpp $@
}
