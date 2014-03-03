#!/usr/bin/env zsh

# ------------------------------------------------------------------------------
# Configure $PATH
# ------------------------------------------------------------------------------
# Add locally installed binaries first
if [[ -d "/usr/local/bin" ]]; then
  export PATH="/usr/local/bin:$PATH"
fi

if [[ -d "/usr/local/sbin" ]]; then
  export PATH="/usr/local/sbin:$PATH"
fi



# ------------------------------------------------------------------------------
# Configure vars to some default paths
# ------------------------------------------------------------------------------
# Path to your oh-my-zsh configuration
psyrendust export --check ZSH "$HOME/.oh-my-zsh"

# Set the location of oh-my-zsh-psyrendust
psyrendust export --check ZSH_CUSTOM="$HOME/.oh-my-zsh-psyrendust"

# Set the location of our work zshrc location
psyrendust export --check ZSHRC_WORK="$HOME/.zshrc-work"

# Set the location of our personal zshrc location
psyrendust export --check ZSHRC_PERSONAL="$HOME/.zshrc-personal"



# ------------------------------------------------------------------------------
# Ensure we have our base config path
# ------------------------------------------------------------------------------
psyrendust export PSYRENDUST_CONFIG_BASE_PATH="$HOME/.psyrendust"
