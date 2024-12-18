alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias grep='grep --color'

alias ll='ls -l'
alias la='ls -A'

alias cl="clear"

alias ..="cd .."

alias ":q"="exit"

alias re="source $HOME/.zshenv && source $ZDOTDIR/.zshrc"

alias '$'=" "

alias "c-w"="cd ~/workspace"

alias "code-web"="code serve-web --host 0.0.0.0 --port 8006 --accept-server-license-terms --without-connection-token"

# zoxide
if (type "zoxide" >/dev/null 2>&1); then
    eval "$(zoxide init zsh --cmd cd)"
fi

# eza
if (type "eza" >/dev/null 2>&1); then
    alias ls="eza"
    alias ll="eza --long"
    alias la="eza --all"
fi

# mise
if (type "mise" >/dev/null 2>&1); then
    eval "$(mise activate zsh)"
    eval "$(mise completion zsh)"
fi
