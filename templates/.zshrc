# Init plugins
if [[ -s "$ZSH_CUSTOM/tools/init-plugins.zsh" ]]; then
  source "$ZSH_CUSTOM/tools/init-plugins.zsh"
fi

# Init aliases
if [[ -s "$ZSH_CUSTOM/tools/init-aliases.zsh" ]]; then
  source "$ZSH_CUSTOM/tools/init-aliases.zsh"
fi

# Init functions
if [[ -s "$ZSH_CUSTOM/tools/init-functions.zsh" ]]; then
  source "$ZSH_CUSTOM/tools/init-functions.zsh"
fi



# ------------------------------------------------------------------------------
# Custom .zshrc files that get sourced if they exist. Things
# place in these files will override any settings found in
# this file.
# ------------------------------------------------------------------------------
# Load custom work zshrc
if [[ -s "$ZSHRC_WORK/.zshrc" ]]; then
  source "$ZSHRC_WORK/.zshrc"
fi

# Load custom personal zshrc
if [[ -s "$ZSHRC_PERSONAL/.zshrc" ]]; then
  source "$ZSHRC_PERSONAL/.zshrc"
fi



# Source oh-my-zsh and get things started
if [[ -s "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
fi



# ------------------------------------------------------------------------------
# Post initialization
# ------------------------------------------------------------------------------
if [[ -s "$ZSH_CUSTOM/tools/init-post-settings.zsh" ]]; then
  source "$ZSH_CUSTOM/tools/init-post-settings.zsh"
fi

# Last run helper functions
if [[ -s "$ZSH_CUSTOM/tools/last-run.zsh" ]]; then
  source "$ZSH_CUSTOM/tools/last-run.zsh"
fi

# Output our version number
psyrendust  --version
