# zshrc

#@@@@@ @@@@@ @@@@@ @@@@@ @@@@@ @@@@@
#@@@@@ options
#@@@@@ @@@@@ @@@@@ @@@@@ @@@@@ @@@@@
# history
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt inc_append_history_time
setopt share_history
HISTFILE=$ZDOTDIR/.zsh_history
HISTSIZE=10000
SAVEHIST=1000000

# completion
autoload -Uz compinit ; compinit

# colors
autoload -Uz colors && colors

#@@@@@ @@@@@ @@@@@ @@@@@ @@@@@ @@@@@
#@@@@@ env
#@@@@@ @@@@@ @@@@@ @@@@@ @@@@@ @@@@@
export DROPBOX_PATH="${HOME}/Dropbox"

#@@@@@ @@@@@ @@@@@ @@@@@ @@@@@ @@@@@
#@@@@@ alias
#@@@@@ @@@@@ @@@@@ @@@@@ @@@@@ @@@@@

# ls
alias ls="eza"
alias la="eza --all"
alias ll="eza -l"
alias lla="eza -al"
alias lt="eza -T"
alias llt="eza -alT"
alias llg="eza -alT -I .git --git-ignore"
#cd
alias ..="cd .."
#clear
alias cl='clear'
# history
alias h='history'
# vim
alias vim=nvim
# mkdir
alias mkdir="mkdir -p"
alias mk="mkdir"
# rm
alias rmm="rm -rf"
#exit
alias eq="exit"
# edit files
alias reload="source ${ZDOTDIR}/.zshrc"
alias e-zshrc="$EDITOR ${ZDOTDIR}/.zshrc"
alias e-dotfiles="cd ~/dotfiles"
alias e-workspace="cd ~/workspace"

#@@@@@ @@@@@ @@@@@ @@@@@ @@@@@ @@@@@
#@@@@@ functions
#@@@@@ @@@@@ @@@@@ @@@@@ @@@@@ @@@@@

#@@@@@ @@@@@ @@@@@ @@@@@ @@@@@ @@@@@
#@@@@@ etc
#@@@@@ @@@@@ @@@@@ @@@@@ @@@@@ @@@@@

# starship
if [ -x "$(command -v starship)" ]; then
    eval "$(starship init zsh)"
fi

