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

# git checkout remote branch and track it
function gcob() {
  git checkout -b $1 origin/$1
}

# update target branch and merge it into current branch
function gmfrom() {
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
function gmclean() {
  find ./ -type f -name \*.orig -exec rm -f {} \;
}

# # save a named stash
# function gssave() {
#   git stash save "$1"
# }

# # drop a stash by name using regex
# function gsdrop() {
#   git stash drop stash^{/$*};
# }

# # search for stash by name using regex
# function gsshow() {
#   git stash show stash^{/$*} -p;
# }

# # apply stash by name using regex
# function gsapply() {
#   git stash apply stash^{/$*};
# }

# create a stash and delete it
function gsdel() {
  git stash save;
  git stash drop stash@{0};
}