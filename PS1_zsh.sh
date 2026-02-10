parse_git_branch_status() {
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    local branch marker behind ahead
    branch=$(git branch --show-current 2>/dev/null)

    if git rev-parse --abbrev-ref @{upstream} >/dev/null 2>&1; then
      read behind ahead <<<"$(git rev-list --left-right --count @{upstream}...HEAD 2>/dev/null)"

      if [ "$ahead" -gt 0 ] && [ "$behind" -gt 0 ]; then
        marker="±"
      elif [ "$ahead" -gt 0 ]; then
        marker="↑"
      elif [ "$behind" -gt 0 ]; then
        marker="↓"
      else
        marker="="
      fi
      echo "GIT:${branch}${marker}"
    else
      echo "GIT:${branch}"
    fi
  fi
}

tmux_session_name() {
  [ -n "$TMUX" ] && echo "TMUX:$(tmux display-message -p '#S')"
}

jobs_count() {
  echo "JOBS:$(jobs | wc -l)"
}

prompt_status() {
  local ec=$?
  (( ec == 0 )) && return 0
  echo " %{\e[01;31m%}✗${ec}%{\e[00m%}"
}

ssh_tag() {
  [[ -n "$SSH_CONNECTION" || -n "$SSH_TTY" ]] || return 0
  echo " %{\e[01;31m%}SSH%{\e[00m%}"
}

git_flags() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return 0

  local st line stag=0 modf=0 untr=0
  st=$(git status --porcelain 2>/dev/null) || return 0
  [[ -z "$st" ]] && return 0

  while IFS= read -r line; do
    if [[ "$line" == '?? '* ]]; then
      untr=1
      continue
    fi
    # 1文字目: index(staged) 状態, 2文字目: worktree(modified) 状態
    [[ "${line[1,1]}" != " " ]] && stag=1
    [[ "${line[2,2]}" != " " ]] && modf=1
  done <<< "$st"

  local out=""
  (( stag )) && out+=" STAG"
  (( modf )) && out+=" MODF"
  (( untr )) && out+=" UNTR"
  print -r -- "$out"
}

setopt PROMPT_SUBST

PROMPT=$'%{\e]633;A\a%}\n[%{\e[01;33m%}%D{%Y-%m-%d %H:%M:%S}%{\e[00m%} %{\e[01;36m%}$(jobs_count)%{\e[00m%} HIST:%! %{\e[01;35m%}$(parse_git_branch_status)$(git_flags)%{\e[00m%} %{\e[01;32m%}$(tmux_session_name)%{\e[00m%}$(ssh_tag)]\n%{\e[01;32m%}%n@%m%{\e[00m%}:%{\e[01;34m%}%~%{\e[00m%}%(!.#.$)%(?.. %{\e[01;31m%}✗%?%{\e[00m%}) %{\e]633;B\a%}'
