# alias
# ls
# if exa is installed, use exa instead of ls
if command -v "exa" > /dev/null 2>&1; then
    alias exa='exa --icons --group-directories-first --git --color-scale --color=always'
    alias ls='exa'
    alias lt='ls --tree'
else
    alias ls='ls --color=auto'
fi

alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'

# 安全策
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# 便利
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias cl='clear'

# git
alias g='git'
alias gs='git status'
alias gl='git log --oneline --graph --decorate --all'

# zsh
alias zs="source $XDG_CONFIG_HOME/zsh/.zshrc"