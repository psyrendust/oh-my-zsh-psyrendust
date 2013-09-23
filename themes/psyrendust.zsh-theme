# Default prompts for ZSH
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[green]%}|"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[green]%}|"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg_bold[green]%}✓"

# # get the name of the branch we are on
# function psy_git_prompt_info() {
#   ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
#   ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
#   if [[ "$(command git config --get oh-my-zsh.hide-status)" != "1" ]]; then
#     if [[ $POST_1_7_2_GIT -gt 0 ]]; then
#       SUBMODULE_SYNTAX="--ignore-submodules=dirty"
#     fi
#     if [[ "$DISABLE_UNTRACKED_FILES_DIRTY" == "true" ]]; then
#         GIT_STATUS=$(command git status -s ${SUBMODULE_SYNTAX} -uno 2> /dev/null | tail -n1)
#     else
#         GIT_STATUS=$(command git status -s ${SUBMODULE_SYNTAX} 2> /dev/null | tail -n1)
#     fi
#   fi
#   # echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(psy_parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
#   echo "$ZSH_THEME_GIT_PROMPT_PREFIX$(git_branch_name)$ZSH_THEME_GIT_PROMPT_SUFFIX"
# }
# # Checks if working tree is dirty
# function psy_parse_git_dirty() {
#   local SUBMODULE_SYNTAX=''
#   local GIT_STATUS=''
#   local CLEAN_MESSAGE='nothing to commit (working directory clean)'
#   if [[ "$(command git config --get oh-my-zsh.hide-status)" != "1" ]]; then
#     if [[ $POST_1_7_2_GIT -gt 0 ]]; then
#           SUBMODULE_SYNTAX="--ignore-submodules=dirty"
#     fi
#     if [[ "$DISABLE_UNTRACKED_FILES_DIRTY" == "true" ]]; then
#         GIT_STATUS=$(command git status -s ${SUBMODULE_SYNTAX} -uno 2> /dev/null | tail -n1)
#     else
#         GIT_STATUS=$(command git status -s ${SUBMODULE_SYNTAX} 2> /dev/null | tail -n1)
#     fi
#     if [[ -n $GIT_STATUS ]]; then
#       echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
#     else
#       echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
#     fi
#   else
#     echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
#   fi
# }
function ruby_version_prompt {
  # Grab the current version of ruby in use (via RVM): [ruby-1.8.7]
  if [ -e ~/.rvm/bin/rvm-prompt ]; then
    local CURRENT_RUBY="%{$fg[yellow]%}|\$(~/.rvm/bin/rvm-prompt)|%{$reset_color%}"
  else
    if which rbenv &> /dev/null; then
      local CURRENT_RUBY="%{$fg[yellow]%}|\$(rbenv version | sed -e 's/ (set.*$//')|%{$reset_color%}"
    fi
  fi
  echo $CURRENT_RUBY
}
function scm_prompt_char {
  # Setup some SCM characters
  local SCM=''
  local SCM_GIT='git'
  local SCM_GIT_CHAR='±'
  local SCM_HG='hg'
  local SCM_HG_CHAR='☿'
  local SCM_SVN='svn'
  local SCM_SVN_CHAR='⑆'
  local SCM_NONE='NONE'
  local SCM_NONE_CHAR='○'
  # Get the current SCM
  if [[ -f .git/HEAD ]]; then SCM=$SCM_GIT
  elif [[ -n "$(git symbolic-ref HEAD 2> /dev/null)" ]]; then SCM=$SCM_GIT
  elif [[ -d .hg ]]; then SCM=$SCM_HG
  elif [[ -n "$(hg root 2> /dev/null)" ]]; then SCM=$SCM_HG
  elif [[ -d .svn ]]; then SCM=$SCM_SVN
  else SCM=$SCM_NONE
  fi

  # Get the SCM character
  if [[ $SCM == $SCM_GIT ]]; then SCM_CHAR=$SCM_GIT_CHAR
  elif [[ $SCM == $SCM_HG ]]; then SCM_CHAR=$SCM_HG_CHAR
  elif [[ $SCM == $SCM_SVN ]]; then SCM_CHAR=$SCM_SVN_CHAR
  else SCM_CHAR=$SCM_NONE_CHAR
  fi
  echo $SCM_CHAR
}
function PSYRENDUST_PROMPT_LINE_1 {
  local CURRENT_USER="%{$fg[magenta]%}%m%{$reset_color%}"   # Grab the current machine name
  local IN="%{$fg[white]%}in%{$reset_color%}"               # Just some text
  local CURRENT_PATH="%{$fg[green]%}%~"                     # Grab the current file path
  echo "$(ruby_version_prompt) $CURRENT_USER $IN $CURRENT_PATH"
}

function PSYRENDUST_PROMPT_LINE_2 {
  echo "%{$fg_bold[cyan]%}\$(scm_prompt_char)%{$reset_color%}\$(git_prompt_info)%{$fg[green]%} →%{$reset_color%} "
  # echo "%{$fg_bold[cyan]%}\$(scm_prompt_char)%{$reset_color%}\$(psy_git_prompt_info)%{$fg[green]%} →%{$reset_color%} "
}

PROMPT="
$(PSYRENDUST_PROMPT_LINE_1)
$(PSYRENDUST_PROMPT_LINE_2)"

# Do some cleanup. We don't want these functions lingering
unfunction ruby_version_prompt
unfunction PSYRENDUST_PROMPT_LINE_1
unfunction PSYRENDUST_PROMPT_LINE_2
