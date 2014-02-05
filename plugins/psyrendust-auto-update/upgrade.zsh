#!/usr/bin/env zsh
function isgitrepo() {
  # check if we're in a git repo
  if [[ -d "./.git" ]]; then
    if [[ $(git rev-parse --is-inside-work-tree) == "true" ]]; then
      echo 1;
    fi
  fi
}

function cleanup() {
  # check if it's dirty and reset it back to HEAD
  if [[ -n $(git diff --ignore-submodules HEAD) ]]; then
    git reset HEAD --hard
  fi
}

function updaterepo() {
  # Check if the folder exists
  if [[ -d $1 ]]; then
    cd $1
    # Check if we're in a git repo
    if [[ -n $(isgitrepo) ]]; then
      # cleanup
      if git pull --rebase origin master; then
        # Run any repo specific updates
        local pattern="${2:-}"
        [[ $pattern == '' ]] || $($2)
        echo 1
      fi
    else
      echo 2
    fi
  else
    echo 2
  fi
}

function updatepsyrendust() {
  # Run custom updates
  if [[ -d $ZSH_CUSTOM ]]; then
    cp "$ZSH_CUSTOM/templates/.zshrc" "$HOME/.zshrc"
  fi
}

function updatepuretheme() {
  # Run custom updates
  if [[ -d $PURE_THEME ]]; then
    ln -sf "$HOME/.pure-theme/pure.zsh" "$ZSH_CUSTOM/themes/pure.zsh-theme"
  fi
}

function updatezshrcpersonal() {
  # Run custom updates
  [[ -d $ZSHRC_PERSONAL ]]
}

function updatezshrcwork() {
  # Run custom updates
  [[ -d $ZSHRC_WORK ]]
}

function processupdate() {
  printf '\033[0;34m%s\033[0m\n' "Processing updates..."

  [[ -d "$ZSH_CUSTOM" ]] && printf '\033[0;34m%s\033[0m\n' "[ Oh My Zsh Psyrendust ]"
  successupdatepsyrendust=$(updaterepo "$ZSH_CUSTOM" updatepsyrendust)

  [[ -d "$PURE_THEME" ]] && printf '\033[0;34m%s\033[0m\n' "[ Pure Theme ]"
  successupdatepuretheme=$(updaterepo "$PURE_THEME" updatepuretheme)

  [[ -d "$ZSHRC_PERSONAL" ]] && printf '\033[0;34m%s\033[0m\n' "[ Personal zshrc ]"
  successupdatezshrcpersonal=$(updaterepo "$ZSHRC_PERSONAL" updatezshrcpersonal)

  [[ -d "$ZSHRC_WORK" ]] && printf '\033[0;34m%s\033[0m\n' "[ Work zshrc ]"
  successupdatezshrcwork=$(updaterepo "$ZSHRC_WORK" updatezshrcwork)

  [[ -n $successupdatepsyrendust ]]    || printf '\033[0;31m%s\033[0m\n' ' - There was an error updating Oh My Zsh Psyrendust.'
  [[ -n $successupdatepuretheme ]]     || printf '\033[0;31m%s\033[0m\n' ' - There was an error updating Pure Theme.'
  [[ -n $successupdatezshrcpersonal ]] || printf '\033[0;31m%s\033[0m\n' ' - There was an error updating zshrc-personal.'
  [[ -n $successupdatezshrcwork ]]     || printf '\033[0;31m%s\033[0m\n' ' - There was an error updating zshrc-work.'


  if [[ -n $successupdatepsyrendust && -n $successupdatepuretheme && -n $successupdatezshrcpersonal && -n $successupdatezshrcwork ]]; then
    printf '\033[0;32m%s\033[0m\n' '       __                            __                                    __         __  '
    printf '\033[0;32m%s\033[0m\n' ' ___  / /     __ _  __ __   ___ ___ / /     ___  ___ __ _________ ___  ___/ /_ _____ / /_ '
    printf '\033[0;32m%s\033[0m\n' '/ _ \/ _ \   /  ` \/ // /  /_ /(_-</ _ \   / _ \(_-</ // / __/ -_) _ \/ _  / // (_-</ __/ '
    printf '\033[0;32m%s\033[0m\n' '\___/_//_/  /_/_/_/\_, /   /__/___/_//_/  / .__/___/\_, /_/  \__/_//_/\_,_/\_,_/___/\__/  '
    printf '\033[0;32m%s\033[0m\n' '                  /___/                  /_/       /___/                                  '
    printf '\033[0;32m%s\033[0m\n' 'Hooray!'
  else
    printf '\033[0;31m%s\033[0m\n' 'Please try again later.'
  fi


  unset successupdatepsyrendust;
  unset successupdatepuretheme;
  unset successupdatezshrcpersonal;
  unset successupdatezshrcwork;
}

processupdate
