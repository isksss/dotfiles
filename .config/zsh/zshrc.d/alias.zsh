
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias grep='grep --color'

alias ll='ls -l'
alias la='ls -A'

alias cl="clear"

alias ..="cd .."

alias re="source $HOME/.zshenv && source $ZDOTDIR/.zshrc"

# aqua
alias aq="aqua"
alias aq-g="AQUA_CONFIG=$AQUA_GLOBAL_CONFIG aqua"

# zoxide
if (type "zoxide" >/dev/null 2>&1); then
    eval "$(zoxide init zsh --cmd cd)"
fi
