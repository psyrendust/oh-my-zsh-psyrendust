# Aliases

alias gass='git update-index --assume-unchanged'
compdef _git gass=git-update-index

alias gaa='git add -A'
compdef _git gaa=git-add

alias gun='git reset && git checkout . && git clean -fdx'
compdef _git gun=git-reset

alias gt='git tag'
compdef _git gt=git-tag

alias gta='git tag -a'
compdef _git gta=git-tag

alias gindex='git rm --cached -r . && git reset --hard && git add .'
compdef _git git=git-rm

function git_branch_name() {
  ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  echo "${ref#refs/heads/}"
}

function gbfromhere() {
  git checkout -b $1 $(git_branch_name)
}