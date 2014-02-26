## Kaleidoscope plugin
# Creates a ksdiff tool that can launch Kaleidoscope.app
# from the Cygwin terminal in Parallels.
if [[ -n $SYSTEM_IS_CYGWIN ]] && [[ -n $SYSTEM_IS_VM ]]; then
  local me=$(whoami)
  local _kaleidoscope_path="/cygdrive/c/Users/$me/AppData/Roaming/Parallels/Shared Applications/Kaleidoscope (Mac).exe"
  if [[ -f $_kaleidoscope_path ]]; then
    if [[ -f "$ZSH_CUSTOM/plugins/kaleidoscope/ksdiff.sh" ]]; then
      ln -sf "$ZSH_CUSTOM/plugins/kaleidoscope/ksdiff.sh" /usr/local/bin/ksdiff
    fi
  fi
fi
