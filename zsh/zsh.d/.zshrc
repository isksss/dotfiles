# zsh
ZSH_COMPDUMP="${XDG_CACHE_HOME}/zsh/.zcompdump"

# ==========
# local

if [[ -f "$ZDOTDIR/local.zsh" ]]; then
  . "$ZDOTDIR/local.zsh"
else
  touch "$ZDOTDIR/local.zsh"
fi

# ==========
# zshオプション
autoload -Uz compinit
compinit

HISTFILE="${XDG_CACHE_HOME}/zsh/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000

setopt inc_append_history     # 実行ごとに即書き込み
setopt share_history          # 全セッションで共有
setopt hist_ignore_all_dups   # 重複を即削除
setopt hist_reduce_blanks     # 余分な空白を削除
setopt hist_verify            # 実行前に確認
setopt extended_history      # タイムスタンプ付き

# ==========
# lang

# rust
if [[ -f "$HOME/.cargo/env" ]]; then
  . "$HOME/.cargo/env"
fi

# ==========
# alias
alias cl="clear"
alias re="exec ${SHELL} -l"

# mise
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
  eval "$(mise completion zsh)"
  alias mx="mise x -- "
fi

# zoxide
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh --cmd cd)"
fi
alias ..="cd .."

# ls
if command -v eza >/dev/null 2>&1; then
  alias ls="eza"
fi

if command -v bat >/dev/null 2>&1; then
  alias cat="bat"
fi

# lazygit
if command -v lazygit >/dev/null 2>&1; then
  alias lg="lazygit"
fi

# zellij
if command -v zellij >/dev/null 2>&1; then
  alias zl="zellij"
  zla() {
    local session
    session="$(zellij ls -s | fzf --reverse --height 40%)" || return
    zellij a "$session"
  }
fi

# fzf
if command -v fzf >/dev/null 2>&1; then
  . <(fzf --zsh)
fi

# starship
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi
