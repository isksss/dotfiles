#########################
# env
#########################
CURRENT_DIR=$(cd $(dirname $0); pwd)
export LANG=ja_JP.UTF-8

#########################
# history
#########################
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=1000000
setopt inc_append_history
setopt share_history
setopt hist_ignore_all_dups
setopt share_history
setopt hist_reduce_blanks

#########################
# completions
#########################
autoload -Uz compinit
compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
setopt correct

#########################
# option
#########################
setopt print_eight_bit
setopt no_beep
# dir
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups

# color
autoload -Uz colors ; colors

# ()
setopt auto_param_keys

#########################
# alias 
#########################
source $HOME/.zsh/.zsh_aliases

#########################
# path
#########################
source $HOME/.zsh/.zsh_path

# for mac os
if [ "$(uname)" = "Darwin" ] ; then
    # fnm
    export PATH="$PATH:$HOME/Library/Application Support/fnm"
    eval "$(fnm env --use-on-cd)"
fi