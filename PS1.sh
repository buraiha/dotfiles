# Gitブランチを表示する関数
parse_git_branch() {
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "GIT:$(git branch --show-current 2>/dev/null)"
  fi
}

# tmuxセッション名を表示する関数
tmux_session_name() {
  [ -n "$TMUX" ] && echo "TMUX:$(tmux display-message -p '#S')"
}

# バックグラウンドジョブ数
jobs_count() {
  echo "JOBS:$(jobs | wc -l)"
}

# プロンプト設定
export PS1="\n[\[\033[01;33m\]\$(date '+%Y-%m-%d %H:%M:%S') \
\[\033[01;36m\]\$(jobs_count) \
HIST:\! \
\[\033[01;35m\]\$(parse_git_branch) \
\[\033[01;32m\]\$(tmux_session_name)\[\033[00m\]]\n\
\[\033[01;32m\]\u@\h\[\033[00m\]:\
\[\033[01;34m\]\w\[\033[00m\]\$ "
