function isgitrepoandcanupdate() {
  # check if we're in a git repo
  command git rev-parse --is-inside-work-tree &>/dev/null || return 0
  # check if it's dirty
  command git diff --quiet --ignore-submodules HEAD &>/dev/null
  if [[ $? == 1 ]]; then
    git reset HEAD --hard;
    return 1
  else
    return 0
  fi
}

function updatepsyrendust() {
  printf '\033[0;34m%s\033[0m\n' "Upgrading Oh My Zsh Psyrendust"
  cd "$ZSH_CUSTOM"
  # Cleanup our repo with a stash save in case someone was mucking around
  if [[ isgitrepoandcanupdate == 1 ]]; then
    if git pull --rebase origin master; then
      # Copy over any template updates
      cp $ZSH_CUSTOM/templates/zshrc.zsh-template ~/.zshrc
      printf '\033[0;34m%s\033[0m\n' 'Oh My Zsh Psyrendust update successful!'
      return 1
    else
      return 0
    fi
  else
    return 0
  fi
}

function updatepuretheme() {
  # Update the pure theme from source
  if [[ $ZSH_THEME == "pure" && $PURE_THEME == "$HOME/.pure-theme" ]]; then
    printf '\033[0;34m%s\033[0m\n' "Upgrading Pure theme"
    cd "$PURE_THEME"
    isgitrepoandcanupdate
    if git pull --rebase origin master; then
      ln -sf $HOME/.pure-theme/pure.zsh $ZSH_CUSTOM/themes/pure.zsh-theme
      printf '\033[0;34m%s\033[0m\n' 'Pure theme update successful!'
      return 1
    else
      return 0
    fi
  else
    return 1
  fi
}

function updatezshrcpersonal() {
  # Update custom personal zshrc
  if [[ -s "${ZSHRC_PERSONAL}/.zshrc" ]]; then
    printf '\033[0;34m%s\033[0m\n' "Upgrading personal zshrc"
    cd "${ZSHRC_PERSONAL}"
    if [[ isgitrepoandcanupdate == 1 ]]; then
      if git pull --rebase origin master; then
        printf '\033[0;34m%s\033[0m\n' 'Personal zshrc update successful!'
        return 1
      else
        return 0
      fi
    else
      return 0
    fi
  else
    return 1
  fi
}

function updatezshrcwork() {
  # Update custom personal zshrc
  if [[ -s "${ZSHRC_WORK}/.zshrc" ]]; then
    printf '\033[0;34m%s\033[0m\n' "Upgrading work zshrc"
    cd "${ZSHRC_WORK}"
    if [[ isgitrepoandcanupdate == 1 ]]; then
      if git pull --rebase origin master; then
        printf '\033[0;34m%s\033[0m\n' 'Work zshrc update successful!'
        return 1
      else
        return 0
      fi
    else
      return 0
    fi
  else
    return 1
  fi
}

function processupgrade() {
  local successupdatepsyrendust=updatepsyrendust;
  local successupdatepuretheme=updatepuretheme;
  local successupdatezshrcpersonal=updatezshrcpersonal;
  local successupdatezshrcpersonal=updatezshrcpersonal;
  if [[ successupdatepsyrendust == 1 && successupdatepuretheme == 1 && successupdatezshrcpersonal == 1 && successupdatezshrcpersonal == 1 ]]; then
    printf '\033[0;32m%s\033[0m\n' '       __                            __                                    __         __  '
    printf '\033[0;32m%s\033[0m\n' ' ___  / /     __ _  __ __   ___ ___ / /     ___  ___ __ _________ ___  ___/ /_ _____ / /_ '
    printf '\033[0;32m%s\033[0m\n' '/ _ \/ _ \   /  ` \/ // /  /_ /(_-</ _ \   / _ \(_-</ // / __/ -_) _ \/ _  / // (_-</ __/ '
    printf '\033[0;32m%s\033[0m\n' '\___/_//_/  /_/_/_/\_, /   /__/___/_//_/  / .__/___/\_, /_/  \__/_//_/\_,_/\_,_/___/\__/  '
    printf '\033[0;32m%s\033[0m\n' '                  /___/                  /_/       /___/                                  '
    printf '\033[0;34m%s\033[0m\n' 'Hooray! Oh My Zsh Psyrendust has been updated!.'
  else
    if [[ successupdatepsyrendust == 0 ]]; then
      printf '\033[0;31m%s\033[0m\n' 'There was an error updating Oh My Zsh Psyrendust.'
    fi
    if [[ successupdatepuretheme == 0 ]]; then
      printf '\033[0;31m%s\033[0m\n' 'There was an error updating Pure Theme.'
    fi
    if [[ successupdatezshrcpersonal == 0 ]]; then
      printf '\033[0;31m%s\033[0m\n' 'There was an error updating personal zshrc.'
    fi
    if [[ successupdatezshrcpersonal == 0 ]]; then
      printf '\033[0;31m%s\033[0m\n' 'There was an error updating work zshrc.'
    fi
    printf '\033[0;31m%s\033[0m\n' 'Please try again later.'

  fi
}

processupgrade
