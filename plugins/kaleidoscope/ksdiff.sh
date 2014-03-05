#!/usr/bin/env sh
kaleidoscope_path="/cygdrive/c/Users/$me/AppData/Roaming/Parallels/Shared Applications/Kaleidoscope (Mac).exe"
if [[ -f $kaleidoscope_path ]]; then
  RESULT=""
  for arg
  do
    if [[ "" != "$arg" ]] && [[ -e $arg ]];
    then
      OUT=`cygpath -wa $arg`
    else
      OUT=$arg
      if [[ $arg == -* ]];
      then
        OUT=$arg
      else
        OUT="'$arg'"
      fi
    fi
    RESULT=$RESULT" "$OUT
  done
  "/cygdrive/c/Users/$me/AppData/Roaming/Parallels/Shared Applications/Kaleidoscope (Mac).exe" $RESULT
fi
