#!/bin/zsh
# inpired by agnoster's Theme - https://gist.github.com/3712874

## Main prompt
build-prompt() {
  local RETVAL=$?
  local SEGMENT_SEPARATOR=''

  local CURRENT_BG='NONE'

  ### Segment drawing
  # A few utility functions to make it easy and re-usable to draw segmented prompts


  # Begin a segment
  # Takes two arguments, background and foreground. Both can be omitted,
  # rendering default background/foreground.
  prompt_segment() {
    local bg fg
    [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
    [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
    if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
      echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
    else
      echo -n "%{$bg%}%{$fg%} "
    fi
    CURRENT_BG=$1
    [[ -n $3 ]] && echo -n $3
  }

  # End the prompt, closing any open segments
  prompt_end() {
    if [[ -n $CURRENT_BG ]]; then
      echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
    else
      echo -n "%{%k%}"
    fi
    echo -n "%{%f%}"
    CURRENT_BG=''
  }

  ### Prompt components
  # Each component will draw itself, and hide itself if no information needs to be shown

  # Context: user@hostname (who am I and where am I)
  prompt_context() {
    if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
      prompt_segment black default "%(!.%{%F{yellow}%}.)$USER@%m"
    fi
  }

  # Git: branch/detached head, dirty status
  prompt_git() {

    if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
      if autoload -Uz git-dirty && git-dirty; then
        prompt_segment yellow black
      else
        prompt_segment green black
      fi

      setopt promptsubst
      autoload -Uz vcs_info

      #zstyle ':vcs_info:*+*:*' debug true

      zstyle ':vcs_info:*' enable git
      zstyle ':vcs_info:*' get-revision true
      zstyle ':vcs_info:*' check-for-changes true
      zstyle ':vcs_info:*' stagedstr '✚'
      zstyle ':vcs_info:git:*' unstagedstr '●'
      zstyle ':vcs_info:git:*' aheadstr ' ⬆%{ahead_count}'
      zstyle ':vcs_info:git:*' behindstr ' ⬇%{behind_count}'
      zstyle ':vcs_info:git:*' divergedstr ' %{ahead_count}⥮%{behind_count}'
      zstyle ':vcs_info:git:*' formats '%{ref}%{upstream_status}%u%c'
      zstyle ':vcs_info:git:*' actionformats '%{ref} %{upstream_status}%u%c%{mode}'
      #zstyle ':vcs_info:git:*' attachedRefStr '%{symbolicRef}'
      #zstyle ':vcs_info:git:*' detachedRefStr '➦ %{detachedRef}'
      zstyle ':vcs_info:git+set-message:*' hooks git-message

      vcs_info
      echo -n "${vcs_info_msg_0_}"
    fi
  }

  +vi-git-message(){
    [[ -z $2 ]] && return
    local ahead behind ref mode
    declare -A args
    for k in ${(k)hook_com};do args[$k]=$hook_com[$k];done

    ahead=`git rev-list HEAD@{upstream}..HEAD 2>/dev/null`
    behind=`git rev-list HEAD..HEAD@{upstream} 2>/dev/null`
    args[symbolicRef]=`git symbolic-ref HEAD 2>/dev/null | sed 's/refs\/heads\///'`
    args[detachedRef]=`git show-ref --head -s --abbrev |head -n1 2> /dev/null`

    if [[ -n $args[symbolicRef] ]];then
      zstyle -s ":vcs_info:git:*" attachedRefStr 'args[ref]'
    else
      zstyle -s ":vcs_info:git:*" detachedRefStr 'args[ref]'
    fi

    if [[ -e "${repo_path}/BISECT_LOG" ]]; then
      mode=" <B>"
    elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
      mode=" >M<"
    elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
      mode=" >R>"
    fi
    args[mode]=$mode
    # Load upstream statuses
    args[upstream_status]="%{ahead}%{behind}%{diverged}"
    args[ahead]=""
    args[behind]=""
    args[diverged]=""
    if [[ -n $ahead ]]; then
      zstyle -s ":vcs_info:git:*" aheadstr 'args[ahead]'
      args[ahead_count]=${(w)#ahead}
    fi
    if [[ -n $behind ]]; then
      zstyle -s ":vcs_info:git:*" behindstr 'args[behind]'
      args[behind_count]=${(w)#behind}
    fi
    if [[ -n $ahead && -n $behind ]]; then
      zstyle -s ":vcs_info:git:*" divergedstr 'args[diverged]'
      args[ahead]=""
      args[behind]=""
    fi


    autoload -Uz regexp-replace
    setopt re_match_pcre

    declare -A stdargs
    stdargs=(a action b branch c staged i revision m misc r base-name R base s vcs S subdir u unstaged)

    local previousMsg=""
    local currentMsg=$2
    #replace standard parameters...
    regexp-replace "currentMsg" "%([${(j::)${(@k)stdargs}}])" '%{$stdargs[$match[1]]}'
    #now replace custom parameters
    while [[ $previousMsg != $currentMsg ]]; do
      previousMsg=$currentMsg
      regexp-replace "currentMsg" "%\\{(${(j:|:)${(@k)args}})\\}" '$args[$match[1]]'
    done
    #hook_com[message]=""
    hook_com[message]=$currentMsg

    ret=1
  }

  prompt_hg() {
    local rev status
    if $(hg id >/dev/null 2>&1); then
      if $(hg prompt >/dev/null 2>&1); then
        if [[ $(hg prompt "{status|unknown}") = "?" ]]; then
          # if files are not added
          prompt_segment red white
          st='±'
        elif [[ -n $(hg prompt "{status|modified}") ]]; then
          # if any modification
          prompt_segment yellow black
          st='±'
        else
          # if working copy is clean
          prompt_segment green black
        fi
        echo -n $(hg prompt "☿ {rev}@{branch}") $st
      else
        st=""
        rev=$(hg id -n 2>/dev/null | sed 's/[^-0-9]//g')
        branch=$(hg id -b 2>/dev/null)
        if `hg st | grep -q "^\?"`; then
          prompt_segment red black
          st='±'
        elif `hg st | grep -q "^[MA]"`; then
          prompt_segment yellow black
          st='±'
        else
          prompt_segment green black
        fi
        echo -n "☿ $rev@$branch" $st
      fi
    fi
  }

  # Dir: current working directory
  prompt_dir() {
    prompt_segment blue black '%~'
  }

  # Virtualenv: current working virtualenv
  prompt_virtualenv() {
    local virtualenv_path="$VIRTUAL_ENV"
    if [[ -n $virtualenv_path && -n $VIRTUAL_ENV_DISABLE_PROMPT ]]; then
      prompt_segment blue black "(`basename $virtualenv_path`)"
    fi
  }

  # Status:
  # - was there an error
  # - am I root
  # - are there background jobs?
  prompt_status() {
    local symbols
    symbols=()
    [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}$RETVAL✘"
    [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}⚡"
    [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}⚙"

    [[ -n "$symbols" ]] && prompt_segment black default "$symbols"
  }

  echo
  prompt_status
  prompt_virtualenv
  prompt_context
  prompt_dir
  prompt_git
  prompt_hg
  prompt_end
}
