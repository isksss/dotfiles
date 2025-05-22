# zsh
ZSH_COMPDUMP="${XDG_CACHE_HOME}/zsh/.zcompdump"

# zoxide
eval "$(zoxide init zsh --cmd cd)"

# starship
eval "$(starship init zsh)"