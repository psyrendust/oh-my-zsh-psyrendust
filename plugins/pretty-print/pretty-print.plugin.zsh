#!/usr/bin/env zsh

# Create symlinks
# ----------------------------------------------------------
[[ -s /usr/local/bin/pperror ]] || ln -s $HOME/.oh-my-zsh-psyrendust/plugins/pretty-print/pretty-print-error.zsh /usr/local/bin/pperror
[[ -s /usr/local/bin/ppinfo ]] || ln -s $HOME/.oh-my-zsh-psyrendust/plugins/pretty-print/pretty-print-info.zsh /usr/local/bin/ppinfo
[[ -s /usr/local/bin/ppquestion ]] || ln -s $HOME/.oh-my-zsh-psyrendust/plugins/pretty-print/pretty-print-question.zsh /usr/local/bin/ppquestion
[[ -s /usr/local/bin/ppsuccess ]] || ln -s $HOME/.oh-my-zsh-psyrendust/plugins/pretty-print/pretty-print-success.zsh /usr/local/bin/ppsuccess
