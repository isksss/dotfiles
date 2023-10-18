#####
# variable
#####
export EDITER="nvim"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"

export GOPATH="$HOME/go"
export VOLTA_HOME="$HOME/.volta"
export RYE_HOME="$HOME/.rye"

#####
# alias
#####
alias c.="code ."
alias sudo='sudo '
alias zs="source ~/.bashrc"

alias ls='ls --color=auto'
alias la="ls -a"
alias ll="ls -l"
alias lla="ls -la"

alias cl=clear

alias rmm='rm -rf'

alias mkdir="mkdir -p"
alias ..="cd .."

alias gs='git status'
alias gl='git log --oneline --graph --decorate --all'

#####
# path
#####
# Rust
source "$HOME/.cargo/env"

#####
# starship
#####
eval "$(starship init bash)"
. "$HOME/.cargo/env"
