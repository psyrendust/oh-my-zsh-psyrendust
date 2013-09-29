# psyrendust zsh theme [https://github.com/psyrendust/oh-my-zsh-psyrendust/]
#
# Credits: Thanks to Joshua Corbin [https://github.com/jcorbin/] for his git
# helper functions.

# Default prompts for ZSH
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[green]%}|"      # Prefix at the very beginning of the prompt, before the branch name
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[green]%}|"       # At the very end of the prompt
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗"         # Text to display if the branch is dirty
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg_bold[green]%}✓"  # Text to display if the branch is clean
# ZSH_THEME_GIT_PROMPT_ADDED="%{$FG[082]%}✚%{$reset_color%}"
# ZSH_THEME_GIT_PROMPT_MODIFIED="%{$FG[166]%}✹%{$reset_color%}"
# ZSH_THEME_GIT_PROMPT_DELETED="%{$FG[160]%}✖%{$reset_color%}"
# ZSH_THEME_GIT_PROMPT_RENAMED="%{$FG[220]%}➜%{$reset_color%}"
# ZSH_THEME_GIT_PROMPT_UNMERGED="%{$FG[082]%}═%{$reset_color%}"
# ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$FG[190]%}✭%{$reset_color%}"
# helper functions
typeset -gA psy_git_info
psy_git_info=()

psy_git_init() {
  typeset -ga chpwd_functions
  typeset -ga preexec_functions
  typeset -ga precmd_functions
  chpwd_functions+='psy_git_chpwd_hook'
  preexec_functions+='psy_git_preexec_hook'
  precmd_functions+='psy_git_precmd_hook'
}

psy_git_chpwd_hook() {
  psy_git_info_update
}

psy_git_preexec_hook() {
  if [[ $2 == git\ * ]] || [[ $2 == *\ git\ * ]]; then
    psy_git_precmd_do_update=1
  fi
}

psy_git_precmd_hook() {
  if [ $psy_git_precmd_do_update ]; then
    unset psy_git_precmd_do_update
    psy_git_info_update
  fi
}

psy_git_info_update() {
  psy_git_info=()

  local gitdir="$(git rev-parse --git-dir 2>/dev/null)"
  if [ $? -ne 0 ] || [ -z "$gitdir" ]; then
    return
  fi

  psy_git_info[dir]=$gitdir
  psy_git_info[bare]=$(git rev-parse --is-bare-repository)
  psy_git_info[inwork]=$(git rev-parse --is-inside-work-tree)
}
psy_git_isgit() {
  if [ -z "$psy_git_info[dir]" ]; then
    return 1
  else
    return 0
  fi
}

psy_git_inworktree() {
  psy_git_isgit || return
  if [ "$psy_git_info[inwork]" = "true" ]; then
    return 0
  else
    return 1
  fi
}

# psy_git_isindexclean() {
#   psy_git_isgit || return 1
#   if git diff --quiet --cached 2>/dev/null; then
#     return 0
#   else
#     return 1
#   fi
# }

psy_git_isworktreeclean() {
  psy_git_isgit || return 1
  if git diff --quiet 2>/dev/null; then
    return 0
  else
    return 1
  fi
}

# psy_git_hasunmerged() {
#   psy_git_isgit || return 1
#   local -a flist
#   flist=($(git ls-files -u))
#   if [ $#flist -gt 0 ]; then
#     return 0
#   else
#     return 1
#   fi
# }

# psy_git_hasuntracked() {
#   psy_git_isgit || return 1
#   local -a flist
#   flist=($(git ls-files --others --exclude-standard))
#   if [ $#flist -gt 0 ]; then
#     return 0
#   else
#     return 1
#   fi
# }

psy_git_head() {
  psy_git_isgit || return 1

  if [ -z "$psy_git_info[head]" ]; then
    local name=''
    name=$(git symbolic-ref -q HEAD)
    if [ $? -eq 0 ]; then
      if [[ $name == refs/(heads|tags)/* ]]; then
        name=${name#refs/(heads|tags)/}
      fi
    else
      name=$(git name-rev --name-only --no-undefined --always HEAD)
      if [ $? -ne 0 ]; then
        return 1
      elif [[ $name == remotes/* ]]; then
        name=${name#remotes/}
      fi
    fi
    psy_git_info[head]=$name
  fi

  echo $psy_git_info[head]
}

# Checks if working tree is dirty
psy_git_currentstatus() {
  psy_git_isgit || return
  if psy_git_inworktree; then
    if ! psy_git_isworktreeclean; then
      echo -n "$ZSH_THEME_GIT_PROMPT_DIRTY"
    else
      echo -n "$ZSH_THEME_GIT_PROMPT_CLEAN"
    fi
  fi
}

# get the name of the branch we are on
psy_git_prompt_info() {
  psy_git_isgit || return
  echo -n "$ZSH_THEME_GIT_PROMPT_PREFIX"
  echo -n "$(psy_git_head)"
  echo -n "$(psy_git_currentstatus)"
  echo -n "$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

psy_ruby_version_prompt() {
  # Grab the current version of ruby in use (via RVM): [ruby-1.8.7]
  if [ -e ~/.rvm/bin/rvm-prompt ]; then
    echo -n "%{$fg[yellow]%}|\$(~/.rvm/bin/rvm-prompt)|%{$reset_color%}"
  else
    if which rbenv &> /dev/null; then
      echo -n "%{$fg[yellow]%}|\$(rbenv version | sed -e 's/ (set.*$//')|%{$reset_color%}"
    fi
  fi
}

psy_scm_prompt_char() {
  # Setup some SCM characters
  local SCM_GIT_CHAR='±'
  local SCM_HG_CHAR='☿'
  local SCM_SVN_CHAR='⑆'
  local SCM_NONE_CHAR='○'
  echo -n "%{$fg_bold[cyan]%}"
  # Get the current SCM
  if [[ -f .git/HEAD ]]; then echo -n $SCM_GIT_CHAR
  elif [[ -n "$(git symbolic-ref HEAD 2> /dev/null)" ]]; then echo -n $SCM_GIT_CHAR
  elif [[ -d .hg ]]; then echo -n $SCM_HG_CHAR
  elif [[ -n "$(hg root 2> /dev/null)" ]]; then echo -n $SCM_HG_CHAR
  elif [[ -d .svn ]]; then echo -n $SCM_SVN_CHAR
  else echo -n $SCM_NONE_CHAR
  fi
  echo -n "%{$reset_color%}"
}

psy_git_init
psy_git_info_update
PROMPT="
"                                                # Newline
PROMPT+="$(psy_ruby_version_prompt) "            # Grab the current ruby version
PROMPT+="%{$fg[magenta]%}%m%{$reset_color%} "    # Grab the current machine name
PROMPT+="%{$fg[white]%}in%{$reset_color%} "      # Just some text
PROMPT+="%{$fg[green]%}%~"                       # Grab the current file path
PROMPT+="
"                                                # Newline
PROMPT+="\$(psy_scm_prompt_char)"                # Are we in a git|svn|hg repo
PROMPT+="\$(psy_git_prompt_info) "               # Grab the current branch and display status
PROMPT+="%{$fg[green]%}→%{$reset_color%} "       # Command prompt
