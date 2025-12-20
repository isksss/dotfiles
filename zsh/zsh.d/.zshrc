# zsh
ZSH_COMPDUMP="${XDG_CACHE_HOME}/zsh/.zcompdump"

# ==========
# zshオプション
autoload -Uz compinit
compinit

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

# lazygit
if command -v lazygit >/dev/null 2>&1; then
  alias lg="lazygit"
fi

# zellij
if command -v zellij >/dev/null 2>&1; then
  alias zl="zellij"
fi

# starship
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi
