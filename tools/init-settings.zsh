#!/usr/bin/env zsh


# ------------------------------------------------------------------------------
# Psyrendust settings
# ------------------------------------------------------------------------------
# Uncomment to change how often before auto-updates occur for
# oh-my-zsh-psyrendust? (in days)
psyrendust export PSYRENDUST_UPDATE_DAYS 1

# Uncomment this to enable verbose output for oh-my-zsy-psyrendust related scripts
# psyrendust export PRETTY_PRINT_IS_VERBOSE 1

# Uncomment this to disable auto-update checks for oh-my-zsy-psyrendust
# psyrendust export PSYRENDUST_DISABLE_AUTO_UPDATE "true"

# Uncomment this to set your own custom right prompt id
psyrendust export PSYRENDUST_CONFIG_PRPROMPT_ID "%F{magenta}[ Psyrendust ]%f"



# ------------------------------------------------------------------------------
# Oh My Zsh Settings
# ------------------------------------------------------------------------------
# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME "pure"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment following line if you want to shown in the command execution time stamp
# in the history command output. The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|
# yyyy-mm-dd
# HIST_STAMPS="mm/dd/yyyy"