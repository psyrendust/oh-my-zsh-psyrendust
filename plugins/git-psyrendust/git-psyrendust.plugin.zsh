# Aliases

alias gass="git update-index --assume-unchanged"
compdef _git gass=git-update-index

alias gaa='git add -A'
compdef _git gaa=git-add

alias gun='git reset && git checkout . && git clean -fdx'
compdef _git gun=git-reset

alias gt='git tag'
compdef _git gt=git-tag

alias gta='git tag -a'
compdef _git gta=git-tag

alias gindex='git rm --cached -r . && git clean -fdx && git reset --hard'
compdef _git git=git-rm