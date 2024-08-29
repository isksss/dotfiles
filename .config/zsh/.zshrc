#############################################################
# env
#############################################################

#############################################################
# options
#############################################################

# general
export LANG=ja_JP.UTF-8
setopt nobeep # 音を鳴らさない
setopt print_eight_bit

# history
export HISTFILE="${ZDOTDIR}/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=100000
setopt hist_ignore_dups
setopt extended_history
setopt bang_hist
setopt share_history
setopt hist_reduce_blanks
setopt hist_verify

# cd
setopt autopushd
setopt pushd_ignore_dups

# 補完
autoload -U compinit
compinit
setopt auto_list
setopt auto_menu
setopt list_packed
setopt list_types
zstyle ':completion:*:default' menu select=1
setopt auto_param_slash

# Color
autoload -U colors
colors
export CLICOLOR=true

#############################################################
# source
#############################################################

for script in $ZDOTDIR/zshrc.d/*.zsh; do
    source $script
done
for script in $ZDOTDIR/local.d/*.zsh; do
    source $script
done
