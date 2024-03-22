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
alias ls="exa"
alias la="exa --all"
alias ll="exa -l"
alias lla="exa -al"
alias lt="exa -T"
alias llt="exa -alT"
alias llg="exa -alT -I .git --git-ignore"
#cd
alias ..="cd .."
#clear
alias cl='clear'
# history
alias h='history'
# mkdir
alias mkdir="mkdir -p"
alias mk="mkdir"
# rm
alias rmm="rm -rf"
#exit
alias eq="exit"
# edit files
alias reload="source ${ZDOTDIR}/.zshrc"
alias e-zshrc="vim ${ZDOTDIR}/.zshrc"
alias e-vimrc="vim ${HOME}/.vimrc"
alias e-wez="vim ${XDG_CONFIG_HOME}/wezterm/wezterm.lua"
if [ -d $HOME/Dropbox  ]; then
    alias c-ws="cd $DROPBOX_PATH/workspace"
    alias c-dot="cd $DROPBOX_PATH/workspace/dotfiles"
fi
alias memo="vim $DROPBOX_PATH/workspace/memo.md"

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

