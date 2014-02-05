## Kaleidoscope plugin
# Creates a ksdiff tool that can launch Kaleidoscope.app
# from the Cygwin terminal in Parallels.
if [[ -n $SYSTEM_IS_CYGWIN ]]; then
  local me=$(whoami)
  local _kaleidoscope_path="/cygdrive/c/Users/$me/AppData/Roaming/Parallels/Shared Applications/Kaleidoscope (Mac).exe"
  if [[ -f $_kaleidoscope_path ]]; then
    ln -sf "$_kaleidoscope_path" /usr/local/bin/kscope
  fi
fi

function ksdiff {
  for arg
  do
    if [[ "$arg" != "" ]] && [[ -e $arg ]]; then
      arguments=`cygpath -wa $arg`
    else
      arguments=$arg
      [[ $arg == -* ]] || arguments="'$arg'"
    fi
  done
  if [[ -n $SYSTEM_IS_CYGWIN ]]; then
    kscope $arguments
  fi
}
