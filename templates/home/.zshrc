# Init plugins
if [[ -s "$PSY_TOOLS/init-plugins.zsh" ]]; then
  source "$PSY_TOOLS/init-plugins.zsh"
fi

# Init aliases
if [[ -s "$PSY_TOOLS/init-aliases.zsh" ]]; then
  source "$PSY_TOOLS/init-aliases.zsh"
fi

# Init functions
if [[ -s "$PSY_TOOLS/init-functions.zsh" ]]; then
  source "$PSY_TOOLS/init-functions.zsh"
fi



# ------------------------------------------------------------------------------
# Custom .zshrc files that get sourced if they exist. Things
# place in these files will override any settings found in
# this file.
# ------------------------------------------------------------------------------
# Load custom work zshrc
if [[ -s "$PSY_WORK/.zshrc" ]]; then
  source "$PSY_WORK/.zshrc"
fi

# Load custom user zshrc
if [[ -s "$PSY_USER/.zshrc" ]]; then
  source "$PSY_USER/.zshrc"
fi



# Source oh-my-zsh and get things started
if [[ -s "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
fi



# ------------------------------------------------------------------------------
# Post initialization
# ------------------------------------------------------------------------------
if [[ -s "$PSY_TOOLS/init-post-settings.zsh" ]]; then
  source "$PSY_TOOLS/init-post-settings.zsh"
fi

# Last run helper functions
if [[ -s "$PSY_TOOLS/last-run.zsh" ]]; then
  source "$PSY_TOOLS/last-run.zsh"
fi

# Output our version number
psyrendust  --version
