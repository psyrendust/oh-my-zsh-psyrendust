# Init system
source "$HOME/.oh-my-zsh-psyrendust/tools/init-system.zsh"

# Init paths
psyrendust source "$HOME/.oh-my-zsh-psyrendust/tools/init-paths.zsh"

# Init homebrew
psyrendust source "$ZSH_CUSTOM/tools/init-homebrew.zsh"

# Init nvm
# psyrendust source "$HOME/.nvm/nvm.sh"

# Init rvm
# Zsh & RVM woes (rvm-prompt doesn't resolve)
# http://stackoverflow.com/questions/6636066/zsh-rvm-woes-rvm-prompt-doesnt-resolve
psyrendust source "$HOME/.rvm/scripts/rvm"

# Init settings
psyrendust source "$ZSH_CUSTOM/tools/init-settings.zsh"

# Init plugins
psyrendust source "$ZSH_CUSTOM/tools/init-plugins.zsh"

# Init aliases
psyrendust source "$ZSH_CUSTOM/tools/init-aliases.zsh"

# Init functions
psyrendust source "$ZSH_CUSTOM/tools/init-functions.zsh"



# ------------------------------------------------------------------------------
# Custom .zshrc files that get sourced if they exist. Things
# place in these files will override any settings found in
# this file.
# ------------------------------------------------------------------------------
# Load custom work zshrc
psyrendust source "$ZSHRC_WORK/.zshrc"

# Load custom personal zshrc
psyrendust source "$ZSHRC_PERSONAL/.zshrc"



# ------------------------------------------------------------------------------
# Source oh-my-zsh and get things started
# ------------------------------------------------------------------------------
psyrendust source $ZSH/oh-my-zsh.sh



# ------------------------------------------------------------------------------
# Init post settings
# ------------------------------------------------------------------------------
psyrendust source "$ZSH_CUSTOM/tools/init-post-settings.zsh"

# Last run helper functions
psyrendust source "$ZSH_CUSTOM/tools/last-run.zsh"

# Load fasd
eval "$(fasd --init zsh-hook zsh-ccomp zsh-ccomp-install zsh-wcomp zsh-wcomp-install)"

# Output our version number
psyrendustsbl  --version
