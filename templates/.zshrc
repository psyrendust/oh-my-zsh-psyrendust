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



# Source oh-my-zsh and get things started
psyrendust source "$ZSH/oh-my-zsh.sh"



# ------------------------------------------------------------------------------
# Post initialization
# ------------------------------------------------------------------------------
psyrendust source "$ZSH_CUSTOM/tools/init-post-settings.zsh"

# Last run helper functions
psyrendust source "$ZSH_CUSTOM/tools/last-run.zsh"

# Output our version number
psyrendust  --version
