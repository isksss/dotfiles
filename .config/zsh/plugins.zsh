# mise
if (( $+commands[mise] )); then
    export PATH="$HOME/.local/share/mise/shims:$PATH"
fi

# zoxide
if (( $+commands[zoxide] )); then
    eval "$(zoxide init zsh --cmd cd)"
fi

# starship
if (( $+commands[starship] )); then
    eval "$(starship init zsh)"
fi
