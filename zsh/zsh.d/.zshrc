# zsh
ZSH_COMPDUMP="${XDG_CACHE_HOME}/zsh/.zcompdump"

# ==========
# zshオプション
autoload -Uz compinit
compinit

# ==========
# alias
alias cl="clear"
alias re="exec ${SHELL} -l"

# mise
eval "$(mise activate zsh)"
eval "$(mise completion zsh)"
alias mx="mise x -- "

# zoxide
eval "$(zoxide init zsh --cmd cd)"
alias ..="cd .."

# ls
alias ls="eza"

# lazygit
alias lg="lazygit"

# zellij
alias zl="zellij"

# starship
eval "$(starship init zsh)"
