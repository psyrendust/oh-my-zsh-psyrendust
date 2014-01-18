# Aliases

alias gs='git status'
compdef _git gs=git-status

alias gass='git update-index --assume-unchanged'
compdef _git gass=git-update-index

alias gaa='git add -A'
compdef _git gaa=git-add

alias gun='git reset && git checkout . && git clean -fdx'
compdef _git gun=git-reset

alias gtag='git tag'
compdef _git gtag=git-tag

alias gtaga='git tag -a'
compdef _git gtaga=git-tag

alias gbdel='git branch -D'
compdef _git gbdel=git-branch-D

alias gbfromhere='git_branch_from_here'
compdef _git gbromhere=git-checkout-b

alias gcob='git_checkout_branch'
compdef _git gcob=git-checkout-b

alias gcobu='git_checkout_branch upstream'
compdef _git gcob=git-checkout-b

alias gmfrom='git_merge_from'
compdef _git gmfrom=git-merge

alias gmfromorigin='git_merge_from_origin'
compdef _git gmfromorigin=git-merge-origin

alias gmfromupstream='git_merge_from_upstream'
compdef _git gmfromupstream=git-merge-upstream

alias gmclean='git_merge_clean'
compdef _git gmclean=git-rm

alias gsdel='git_stash_delete'
compdef _git gsdel=git-stash

alias gfo='git fetch origin'
compdef _git gfo=git-fetch-origin

alias gfu='git fetch upstream'
compdef _git gfu=git-fetch-upstream

alias ggpullu='git pull upstream $(git_branch_name)'
compdef _git ggpullu=git-pull-upstream

alias ggpullo='git pull origin $(git_branch_name)'
compdef _git ggpullo=git-pull-origin

alias ggpushu='git push upstream $(git_branch_name)'
compdef _git ggpushu=git-push-upstream

alias ggpusho='git push origin $(git_branch_name)'
compdef _git ggpusho=git-push-origin

alias gindex='git_index'
compdef _git gindex=git-rm-cached-r

alias gcindex='git_clean_index'
compdef _git gcindex=git-rm-cached-r

alias gl='git_log_pretty_grep'
compdef _git glg=git-log-pretty

alias glb='git_log_pretty_grep_begin'
compdef _git glg=git-log-pretty

alias gls='git_log_pretty_grep_begin_sublime'
compdef _git glg=git-log-pretty

# alias gfupdate='git_flow_update'

function git_index() {
  echo "Working, please be patient..."
  local currentlocation=$PWD
  cd $(git rev-parse --show-toplevel)
  git rm --cached -r .
  git reset HEAD --hard
  git add .
  cd "$currentlocation"
}

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
  if [[ "$#" -ne 2 ]]; then
    git checkout -b $1 origin/$1
  else
    git checkout -b $2 $1/$2
  fi
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

# update branch from origin and merge it into current branch
function git_merge_from_origin() {
  currentbranch=$(git_branch_name)
  echo "fetching from origin $1"
  gfo $1:$1
  echo "merging origin $1 into $currentbranch"
  gm $1
}

# update branch from upstream and merge it into current branch
function git_merge_from_upstream() {
  currentbranch=$(git_branch_name)
  echo "fetching from upstream $1"
  gfu $1:$1
  echo "merging upstream $1 into $currentbranch"
  gm $1
}

# clean up and remove any *.orig files created from a merge conflict
function git_merge_clean() {
  find ./ -type f -name \*.orig -exec rm -f {} \;
}

# create a stash and delete it
function git_stash_delete() {
  # Let's make sure there is something to stash
  command git diff --quiet --ignore-submodules HEAD &>/dev/null;
  (($? == 1)) && git stash save && git stash drop stash@{0};
}

# remove everything from the index and then write both the index and the
# working directory from git's database.
function git_clean_index() {
  if [ $# -eq 0 ]; then
    dir="."
  else
    dir=$1
  fi
  git rm --cached -r $dir
  git reset --hard
}

function git_log_pretty_grep() {
  git log --pretty=format:'%s' -i --grep='$(1)'
}

function git_log_pretty_grep_begin() {
  git log --pretty=format:'%s' -i --grep='^$1'
}

function git_log_pretty_grep_begin_sublime() {
  git log --pretty=format:'%s' -i --grep='^$1'
}
