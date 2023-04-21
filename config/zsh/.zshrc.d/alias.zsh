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

alias l='ls'
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'

# cat bat
if command -v "bat" > /dev/null 2>&1; then
    alias cat="bat"
fi

# 安全策
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# 便利
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias cl='clear'
alias sudo='sudo '
alias h='history'
alias rmm='rm -rf'

# git
alias g='git'
alias gs='git status'
alias gl='git log --oneline --graph --decorate --all'
alias gc='git checkout'
alias gco='git commit'
alias gaa='git add --all'

# docker
alias d='docker'
alias dc='docker compose'
alias dcb='docker compose build --no-cache'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcp='docker compose ps'
alias dcex='docker compose exec'
alias dcx='docker compose exec arch zsh'

# zsh
alias zs="source $XDG_CONFIG_HOME/zsh/.zshrc"

# dotfiles
alias dot="cd $HOME/dotfiles"
alias work="cd $HOME/workspace"

# nvim
alias n="nvim"
alias vim="n"
alias vi="n"