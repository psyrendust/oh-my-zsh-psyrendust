#-----------------------------------------------------------
# Setup Kaleidoscope as the tool of choice for merging and
# handling diffs in SourceTree.app
[difftool "sourcetree"]
  cmd = ksdiff --partial-changeset --relative-path \"$MERGED\" -- \"$LOCAL\" \"$REMOTE\"
[mergetool "sourcetree"]
  cmd = ksdiff --merge --output \"$MERGED\" --base \"$BASE\" -- \"$LOCAL\" --snapshot \"$REMOTE\" --snapshot
#-----------------------------------------------------------
# Setup Kaleidoscope as the tool of choice for merging and
# handling diffs
[diff]
  tool = Kaleidoscope
[difftool "Kaleidoscope"]
  cmd = ksdiff --partial-changeset --relative-path \"$MERGED\" -- \"$LOCAL\" \"$REMOTE\"
[merge]
  tool = Kaleidoscope
[mergetool "Kaleidoscope"]
  cmd = ksdiff --merge --output \"$MERGED\" --base \"$BASE\" -- \"$LOCAL\" --snapshot \"$REMOTE\" --snapshot
[alias]
  lg = log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative
[mergetool]
  keepBackup = false
  prompt = false
  trustExitCode = true
[difftool]
  keepBackup = false
  prompt = false
  trustExitCode = true
