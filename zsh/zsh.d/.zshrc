# zsh
ZSH_COMPDUMP="${XDG_CACHE_HOME}/zsh/.zcompdump"

#==========
# alias
alias cl="clear"
# mise
eval "$(mise activate zsh --shims)"
eval "$(mise completion zsh)"

# zoxide
eval "$(zoxide init zsh --cmd cd)"
alias ..="cd .."

# ls
alias ls="eza"

# lazygit
alias lg="lazygit"

# starship
eval "$(starship init zsh)"
