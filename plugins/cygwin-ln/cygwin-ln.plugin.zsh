#!/usr/bin/env zsh
#
# cygwin-ln - In cygwin map Unix "ln" to Windows "mklink" command
#
# Authors:
#   Larry Gordon
#
# ------------------------------------------------------------------------------
# SYNOPSYS
#     Creates a symbolic link if TARGET is a directory
#     ln -s TARGET LINK_NAME      >> cmd /c mklink /D "LINK_NAME" "TARGET"
#     ln -sf TARGET LINK_NAME     >> rm LINK_NAME && cmd /c mklink /D "LINK_NAME" "TARGET"
#
#     Creates a symbolic link if TARGET is a file
#     ln -s TARGET LINK_NAME      >> cmd /c mklink "LINK_NAME" "TARGET"
#     ln -sf TARGET LINK_NAME     >> rm LINK_NAME && cmd /c mklink "LINK_NAME" "TARGET"
#
#     Creates a hard link instead of a symbolic link
#     ln -P TARGET LINK_NAME      >> cmd /c mklink /H "LINK_NAME" "TARGET"
#     ln -P TARGET LINK_NAME      >> rm LINK_NAME && cmd /c mklink /H "LINK_NAME" "TARGET"
# ------------------------------------------------------------------------------
if [[ -n $SYSTEM_IS_CYGWIN ]]; then
  ln() {
    while getopts "bdfiLnPrsStTv" opts; do
      [[ $opts == "s" ]] && opt_s=1       # -s: make symbolic links instead of hard links
      [[ $opts == "f" ]] && opt_f=1       # -f: remove existing destination files
      [[ $opts == "P" ]] && opt_P=1       # -P: make hard links directly to symbolic links
    done
    if [[ -n $opt_s ]] || [[ -n $opt_f ]] || [[ -n $opt_P ]]; then
      shift
    fi
    local arg_target=$1
    local arg_link_name=$2
    if [[ -n $opt_s ]] || [[ -n $opt_P ]]; then
      if [[ -a $arg_target ]]; then
        local link_type=""
        if [[ -d $arg_target ]]; then
          link_type="/D"
        elif [[ -f $arg_target ]]; then
        fi
        local target=$(cygpath -ma ${arg_target} | sed "s/\//\\\\/g")
        local link_name=$(cygpath -ma ${arg_link_name} | sed "s/\//\\\\/g")
        local symlink_bat="$PSYRENDUST_CONFIG_BASE_PATH/symlink.bat"
        local symlink_vbs="$PSYRENDUST_CONFIG_BASE_PATH/symlink.vbs"
        local cygwin_bat=$(cygpath -ma ${symlink_bat} | sed "s/\//\\\\/g")
        [[ -a $symlink_bat ]] && rm $symlink_bat
        [[ -a $symlink_vbs ]] && rm $symlink_vbs
        printf "%s\n" "@echo off" > $symlink_bat
        printf "%s" "cmd /c mklink /D" >> $symlink_bat
        printf " \"%s\"" "$link_name" >> $symlink_bat
        printf " \"%s\"" "$target" >> $symlink_bat
        cat > $symlink_vbs <<EOF
Set WinScriptHost = CreateObject("WScript.Shell")
WinScriptHost.Run Chr(34) & "$cygwin_bat" & Chr(34), 0
Set WinScriptHost = Nothing
EOF
        chmod a+x $symlink_vbs $symlink_bat
        # Remove the arg_link_name so that we can replace it
        [[ -n $opt_f ]] rm -rf "$arg_link_name"
        # Create the symlink
        cygstart $symlink_vbs
        {
          sleep 1
          rm $symlink_vbs $symlink_bat
        } &!
      fi
    else
      \ln $@
    fi
  }
}
