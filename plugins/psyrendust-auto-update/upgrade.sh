function isgitrepo() {
  # check if we're in a git repo
  if [[ -d "./.git" ]]; then
    if [[ $(git rev-parse --is-inside-work-tree) == "true" ]]; then
      echo 1;
    else
      echo 0;
    fi
  else
    echo 0;
  fi
}

function cleanup() {
  # check if it's dirty and reset it back to HEAD
  if [[ -n $(git diff --ignore-submodules HEAD) ]]; then
    git reset HEAD --hard
  fi
}

function updaterepo() {
  cd $1
  cleanup
  if git pull --rebase origin master; then
    echo 1
  else
    echo 0
  fi
}

function updatepsyrendust() {
  cd "$ZSH_CUSTOM"
  # Cleanup our repo with a stash save in case someone was mucking around
  if [[ $(isgitrepo) == 1 ]]; then
    cleanup
    if git pull --rebase origin master; then
      # Copy over any template updates
      cp $ZSH_CUSTOM/templates/zshrc.zsh-template ~/.zshrc
      # Make upgrade.sh executable
      # chmod a+x $ZSH_CUSTOM/plugins/psyrendust-auto-update/upgrade.sh
    else
      echo 0
    fi
  fi
  echo 1
}

function updatepuretheme() {
  # Update the pure theme from source
  if [[ $ZSH_THEME == "pure" && $PURE_THEME == "$HOME/.pure-theme" ]]; then
    cd "$PURE_THEME"
    if [[ $(isgitrepo) == 1 ]]; then
      cleanup
      if git pull --rebase origin master; then
        ln -sf $HOME/.pure-theme/pure.zsh $ZSH_CUSTOM/themes/pure.zsh-theme
      else
        echo 0
      fi
    fi
  fi
  echo 1
}

function updatezshrcpersonal() {
  # Update custom personal zshrc
  if [[ -s "${ZSHRC_PERSONAL}/.zshrc" ]]; then
    cd "${ZSHRC_PERSONAL}"
    if [[ $(isgitrepo) == 1 ]]; then
      cleanup
      if git pull --rebase origin master; then
        echo 1
      else
        echo 0
      fi
    fi
  fi
  echo 1
}

function updatezshrcwork() {
  # Update custom personal zshrc
  if [[ -s "${ZSHRC_WORK}/.zshrc" ]]; then
    cd "${ZSHRC_WORK}"
    if [[ $(isgitrepo) == 1 ]]; then
      cleanup
      if git pull --rebase origin master; then
        echo 1
      else
        echo 0
      fi
    fi
  fi
  echo 1
}

function processupdate() {
  printf '\033[0;34m%s\033[0m\n' "process update..."

  printf '\033[0;34m%s\033[0m\n' "Updating Oh My Zsh Psyrendust"
  successupdatepsyrendust=$(updatepsyrendust)
  if [[ $successupdatepsyrendust == *1* ]]; then
    printf '\033[0;34m%s\033[0m\n' 'Oh My Zsh Psyrendust update successful!';
  fi

  printf '\033[0;34m%s\033[0m\n' "Updating Pure Theme"
  successupdatepuretheme=$(updatepuretheme)
  if [[ $successupdatepuretheme == *1* ]]; then
    printf '\033[0;34m%s\033[0m\n' 'Pure theme update successful!'
  fi

  printf '\033[0;34m%s\033[0m\n' "Updating Personal zshrc"
  successupdatezshrcpersonal=$(updatezshrcpersonal)
  if [[ $successupdatezshrcpersonal == *1* ]]; then
    printf '\033[0;34m%s\033[0m\n' 'Personal zshrc update successful!'
  fi

  printf '\033[0;34m%s\033[0m\n' "Updating Work zshrc"
  successupdatezshrcwork=$(updatezshrcwork)
  if [[ $successupdatezshrcwork == *1* ]]; then
    printf '\033[0;34m%s\033[0m\n' 'Work zshrc update successful!'
  fi

  if [[ $successupdatepsyrendust == *1* && $successupdatepuretheme == *1* && $successupdatezshrcpersonal == *1* && $successupdatezshrcwork == *1* ]]; then
    printf '\033[0;32m%s\033[0m\n' '       __                            __                                    __         __  '
    printf '\033[0;32m%s\033[0m\n' ' ___  / /     __ _  __ __   ___ ___ / /     ___  ___ __ _________ ___  ___/ /_ _____ / /_ '
    printf '\033[0;32m%s\033[0m\n' '/ _ \/ _ \   /  ` \/ // /  /_ /(_-</ _ \   / _ \(_-</ // / __/ -_) _ \/ _  / // (_-</ __/ '
    printf '\033[0;32m%s\033[0m\n' '\___/_//_/  /_/_/_/\_, /   /__/___/_//_/  / .__/___/\_, /_/  \__/_//_/\_,_/\_,_/___/\__/  '
    printf '\033[0;32m%s\033[0m\n' '                  /___/                  /_/       /___/                                  '
    printf '\033[0;34m%s\033[0m\n' 'Hooray! Oh My Zsh Psyrendust has been updated!.'
  else
    if [[ $successupdatepsyrendust == *0* ]]; then
      printf '\033[0;31m%s\033[0m\n' 'There was an error updating Oh My Zsh Psyrendust.'
    fi
    if [[ $successupdatepuretheme == *0* ]]; then
      printf '\033[0;31m%s\033[0m\n' 'There was an error updating Pure Theme.'
    fi
    if [[ $successupdatezshrcpersonal == *0* ]]; then
      printf '\033[0;31m%s\033[0m\n' 'There was an error updating personal zshrc.'
    fi
    if [[ $successupdatezshrcwork == *0* ]]; then
      printf '\033[0;31m%s\033[0m\n' 'There was an error updating work zshrc.'
    fi
    printf '\033[0;31m%s\033[0m\n' 'Please try again later.'
  fi
  unset successupdatepsyrendust;
  unset successupdatepuretheme;
  unset successupdatezshrcpersonal;
  unset successupdatezshrcwork;

  source ~/.zshrc
}

processupdate
