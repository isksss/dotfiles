# 共通
alias cl="clear"
alias ..="cd .."
alias re="source ~/.zshrc"
alias cd-dotfiles="cd $DOTFILES_PATH"

# lazygit
(( $+commands[lazygit] )) && alias lg="lazygit"

# eza
(( $+commands[eza] )) && alias ls="eza"
