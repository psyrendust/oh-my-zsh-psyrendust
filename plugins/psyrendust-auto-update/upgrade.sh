printf '\033[0;34m%s\033[0m\n' "Upgrading Oh My Zsh Psyrendust"
cd "$ZSH"
if git pull --rebase origin master
then
  printf '\033[0;32m%s\033[0m\n' '       __                          __                                   __         __  '
  printf '\033[0;32m%s\033[0m\n' ' ___  / /    __ _  __ __  ___ ___ / /    ___  ___ __ _________ ___  ___/ /_ _____ / /_ '
  printf '\033[0;32m%s\033[0m\n' '/ _ \/ _ \  /  ` \/ // / /_ /(_-</ _ \  / _ \(_-</ // / __/ -_) _ \/ _  / // (_-</ __/ '
  printf '\033[0;32m%s\033[0m\n' '\___/_//_/ /_/_/_/\_, /  /__/___/_//_/ / .__/___/\_, /_/  \__/_//_/\_,_/\_,_/___/\__/  '
  printf '\033[0;32m%s\033[0m\n' '                 /___/                /_/       /___/                                  '
  printf '\033[0;34m%s\033[0m\n' 'Hooray! Oh My Zsh Psyrendust has been updated and/or is at the current version.'
else
  printf '\033[0;31m%s\033[0m\n' 'There was an error updating. Try again later?'
fi

