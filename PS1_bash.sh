# ---- colors / OSC (bash) ----
C_RESET='\[\033[00m\]'
C_YELLOW='\[\033[01;33m\]'
C_CYAN='\[\033[01;36m\]'
C_MAGENTA='\[\033[01;35m\]'
C_GREEN='\[\033[01;32m\]'
C_BLUE='\[\033[01;34m\]'
C_RED='\[\033[01;31m\]'

# VS Code / iTerm 系で使うやつ（必要なければ消してOK）
OSC_A='\[\033]633;A\007\]'
OSC_B='\[\033]633;B\007\]'


# ---- functions (bash) ----
parse_git_branch_status() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return 0

  local branch marker behind ahead
  branch=$(git branch --show-current 2>/dev/null)

  # detached などで取れないときのフォールバック（嫌ならこの if ブロック消してOK）
  if [[ -z "$branch" ]]; then
    branch=$(git symbolic-ref --quiet --short HEAD 2>/dev/null) || true
    if [[ -z "$branch" ]]; then
      local sha
      sha=$(git rev-parse --short HEAD 2>/dev/null) || return 0
      branch="detached:${sha}"
    fi
  fi

  if git rev-parse --abbrev-ref @{upstream} >/dev/null 2>&1; then
    read -r behind ahead <<<"$(git rev-list --left-right --count @{upstream}...HEAD 2>/dev/null)"

    if [[ "$ahead" -gt 0 && "$behind" -gt 0 ]]; then
      marker="±"
    elif [[ "$ahead" -gt 0 ]]; then
      marker="↑"
    elif [[ "$behind" -gt 0 ]]; then
      marker="↓"
    else
      marker="="
    fi
    echo "GIT:${branch}${marker}"
  else
    echo "GIT:${branch}"
  fi
}

tmux_session_name() {
  [[ -n "$TMUX" ]] && echo "TMUX:$(tmux display-message -p '#S')"
}

jobs_count() {
  local n
  n=$(jobs -p | wc -l)
  n=${n//[[:space:]]/}
  echo "JOBS:${n}"
}

prompt_status() {
  local ec="$1"
  [[ "$ec" -eq 0 ]] && return 0
  # ※ここで \[ \] を含む文字列を返してOK（PS1展開時に解釈される）
  printf ' %s✗%s%s' '\[\033[01;31m\]' "$ec" '\[\033[00m\]'
}

ssh_tag() {
  [[ -n "$SSH_CONNECTION" || -n "$SSH_TTY" ]] || return 0
  printf ' %sSSH%s' '\[\033[01;31m\]' '\[\033[00m\]'
}

git_flags() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return 0

  local st line stag=0 modf=0 untr=0 out=""
  st=$(git status --porcelain 2>/dev/null) || return 0
  [[ -z "$st" ]] && return 0

  while IFS= read -r line; do
    if [[ "$line" == '?? '* ]]; then
      untr=1
      continue
    fi
    # 1文字目: index(staged), 2文字目: worktree(modified)
    [[ "${line:0:1}" != " " ]] && stag=1
    [[ "${line:1:1}" != " " ]] && modf=1
  done <<<"$st"

  (( stag )) && out+=" STAG"
  (( modf )) && out+=" MODF"
  (( untr )) && out+=" UNTR"
  [[ -n "$out" ]] && printf '%s' "$out"
}


# ---- build PS1 each prompt (bash) ----
__build_ps1() {
  local ec=$?

  local jobs git tmux ssh status
  jobs="$(jobs_count)"
  git="$(parse_git_branch_status)$(git_flags)"
  tmux="$(tmux_session_name)"
  ssh="$(ssh_tag)"
  status="$(prompt_status "$ec")"

  PS1="${OSC_A}\n[${C_YELLOW}\D{%Y-%m-%d %H:%M:%S}${C_RESET} ${C_CYAN}${jobs}${C_RESET} HIST:\\! ${C_MAGENTA}${git}${C_RESET} ${C_GREEN}${tmux}${C_RESET}${ssh}]\
\n${C_GREEN}\u@\h${C_RESET}:${C_BLUE}\w${C_RESET}\$${status} ${OSC_B}"
}

# 既に PROMPT_COMMAND を使ってるなら、後ろに連結してもOK
# PROMPT_COMMAND="__build_ps1${PROMPT_COMMAND:+;$PROMPT_COMMAND}"
PROMPT_COMMAND="__build_ps1"
