#########################
# env
#########################
CURRENT_DIR=$(cd $(dirname $0); pwd)

#########################
# history
#########################
HISTFILE=$HOME/.zsh-history
HISTSIZE=100000
SAVEHIST=1000000
setopt inc_append_history
setopt share_history

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