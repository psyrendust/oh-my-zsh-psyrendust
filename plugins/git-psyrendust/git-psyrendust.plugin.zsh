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
compdef _git gindex=git-rm

alias gbfromhere='git_branch_from_here'
compdef _git gbromhere=git-checkout-b

alias gcob='git_checkout_branch'
compdef _git gcob=git-checkout-b

alias gmfrom='git_merge_from'
compdef _git gmfrom=git-merge

alias gmclean='git_merge_clean'
compdef _git gmclean=git-rm

alias gsdel='git_stash_delete'
compdef _git gsdel=git-stash

function git_branch_name() {
  ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  echo "${ref#refs/heads/}"
}

function git_branch_from_here() {
  git checkout -b $1 $(git_branch_name)
}

# git checkout remote branch and track it
function git_checkout_branch() {
  git checkout -b $1 origin/$1
}

# update target branch and merge it into current branch
function git_merge_from() {
  currentbranch=$(git_branch_name)
  targetbranch=$1
  echo "switching to branch $targetbranch"
  gco -f $targetbranch
  echo "updating branch $targetbranch"
  ggpull
  echo "switching to branch $currentbranch"
  gco -f $currentbranch
  echo "stashing any changes"
  gsdel
  echo "merging $targetbranch into $currentbranch"
  gm $targetbranch
}

# clean up and remove any *.orig files created from a merge conflict
function git_merge_clean() {
  find ./ -type f -name \*.orig -exec rm -f {} \;
}

# create a stash and delete it
function git_stash_delete() {
  git stash save;
  git stash drop stash@{0};
}