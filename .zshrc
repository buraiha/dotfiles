# zsh startup

export PATH="$PATH:/home/takashi/bin"
export PATH="/usr/local/shellbox/bin:$PATH"

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# append history
setopt APPEND_HISTORY

# share history across sessions
setopt SHARE_HISTORY

# ignore duplicates
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS

# ignore commands starting with space
setopt HIST_IGNORE_SPACE

# reduce noise
setopt HIST_REDUCE_BLANKS

# incremental history write
setopt INC_APPEND_HISTORY

# alias settings
alias hist=history
alias jump='echo "Jumpサーバログイン" && ssh -i $HOME/.ssh/id_rsa_test takashi.furuhashi@13.78.61.12 -p 10022'
alias nboss='echo "検証NbossDBトンネル" && ssh -i $HOME/.ssh/id_rsa_test takashi.furuhashi@13.78.61.12 -p 10022 -g -L 15432:172.16.68.122:5432 -N'

if [[ -f ~/dotfiles/PS1_zsh.sh ]]; then
  source ~/dotfiles/PS1_zsh.sh
fi
