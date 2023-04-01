#!/usr/bin/env zsh

## zshの設定ファイル
## エイリアスの設定

### utils
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias mkdir='mkdir -p'

### cd
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

### ls
alias l='ls -l'
alias ls='ls -G'
alias la='ls -a'
alias ll='ls -la'

### history
alias h='history'
alias hs='history | grep'

### nvim
alias vi='nvim'
alias vim='nvim'
alias emacs='nvim'
alias n='nvim'

### git
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gcm='git commit -m'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gd='git diff'
alias gdc='git diff --cached'
alias gds='git diff --staged'
alias gpl='git pull'
alias gps='git push'
alias gph='git push origin master'
alias gphd='git push origin develop'
alias gm='git merge'
alias gma='git merge --abort'
alias grs='git reset'
alias grsh='git reset --hard'
alias grss='git reset --soft'
alias gl='git log'
alias gls='git log --stat'
alias glp='git log --pretty=format:"%h %ad | %s%d [%an]" --graph --date=short'

### docker
alias d='docker'
alias dc='docker compose'
alias dcl='docker compose logs'
alias dcs='docker compose stop'
alias dcr='docker compose restart'
alias dcp='docker compose ps'
alias dce='docker compose exec'
alias dcb='docker compose build --no-cache'
alias dcd='docker compose down'
alias dck='docker compose kill'
alias dcu='docker compose up -d'

### copy
if [ $(uname) = "Linux" ]; then
    alias pbcopy='xclip -selection c'
    alias pbpaste='xclip -selection c -o'
fi
alias c='pbcopy'
alias v='pbpaste'