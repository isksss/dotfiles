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
# plugins
#########################
source $HOME/.zsh/.zsh_plugins

#########################
# alias 
#########################
source $HOME/.zsh/.zsh_aliases

#########################
# path
#########################
source $HOME/.zsh/.zsh_path

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
# prompt
#########################
autoload -U promptinit
local p_color="%(?.%{${fg[cyan]}%}.%{${fg[magenta]}%})"
##########
# left

##########
# right
autoload -Uz vcs_info
setopt prompt_subst

zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:*' formats "%F{green}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd(){ vcs_info }

RPROMPT='${memotxt}''${vcs_info_msg_0_}'"$p_color return:[%?]%{${reset_color}%}"
##########
# memo
# `% memo {text}`でrpromptにメモできる
function memo(){
    if [ $# -eq 0 ]; then
        unset memotxt
        return
    fi
    for str in $@
    do
    memotxt="${memotxt} ${str}"
    done
}