function upgradepsyrendust() {
  printf '\033[0;34m%s\033[0m\n' "Upgrading Oh My Zsh Psyrendust"
  PSYRENDUST_AUTO_UPDATE_SUCCESS="false"

  cd "$ZSH_CUSTOM"

  # Cleanup our repo with a stash save in case someone was mucking around
  command git diff --quiet --ignore-submodules HEAD &>/dev/null;
  (($? == 1)) && git stash save;

  if git pull --rebase origin master; then
    PSYRENDUST_AUTO_UPDATE_SUCCESS="true"
    # Copy over any template updates
    cp $ZSH_CUSTOM/templates/zshrc.zsh-template ~/.zshrc

    # Update the pure theme from source
    if [[ $ZSH_THEME == "pure" && $PURE_THEME == "$HOME/.pure-theme" ]]; then
      cd "$PURE_THEME"
      if git pull --rebase origin master; then
        ln -sf $HOME/.pure-theme/pure.zsh $ZSH_CUSTOM/themes/pure.zsh-theme
        printf '\033[0;34m%s\033[0m\n' 'Pure theme update successful!'
      fi
    fi
  fi

  if [[ $PSYRENDUST_AUTO_UPDATE_SUCCESS == "true" ]]; then
    printf '\033[0;32m%s\033[0m\n' '       __                            __                                    __         __  '
    printf '\033[0;32m%s\033[0m\n' ' ___  / /     __ _  __ __   ___ ___ / /     ___  ___ __ _________ ___  ___/ /_ _____ / /_ '
    printf '\033[0;32m%s\033[0m\n' '/ _ \/ _ \   /  ` \/ // /  /_ /(_-</ _ \   / _ \(_-</ // / __/ -_) _ \/ _  / // (_-</ __/ '
    printf '\033[0;32m%s\033[0m\n' '\___/_//_/  /_/_/_/\_, /   /__/___/_//_/  / .__/___/\_, /_/  \__/_//_/\_,_/\_,_/___/\__/  '
    printf '\033[0;32m%s\033[0m\n' '                  /___/                  /_/       /___/                                  '
    printf '\033[0;34m%s\033[0m\n' 'Hooray! Oh My Zsh Psyrendust has been updated and/or is at the current version.'
  else
    printf '\033[0;31m%s\033[0m\n' 'There was an error updating. Try again later?'
  fi

  unset PSYRENDUST_AUTO_UPDATE_SUCCESS
}

upgradepsyrendust
