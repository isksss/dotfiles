[[ "$-" != *i* ]] && return
#------------------------------------------------------------
#--------------------
# 環境変数のロード
if [ -e "$HOME/env.sh" ]; then
    source "$HOME/env.sh"
fi

shopt -s histappend
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

#------------------------------------------------------------
# aliasの設定

# common
alias cl="clear"
alias ".."="cd .."
alias re=". ~/.bashrc"
alias "cd-dotfiles"="cd $DOTFILES_PATH"

#--------------------
# lazygit
if type -P "lazygit" >/dev/null; then
    alias lg="lazygit"
fi

#--------------------
# eza
if type -P "eza" >/dev/null; then
    alias ls="eza"
fi

#--------------------
# zoxide
if type -P "zoxide" >/dev/null; then
    eval "$(zoxide init bash --cmd cd)"
fi

#--------------------
# starship
if type -P "starship" >/dev/null; then
    eval "$(starship init bash)"
fi

#--------------------
# local
if [ -f "$ISKSSS_HOME/.bash_local" ]; then
    source $ISKSSS_HOME/.bash_local
fi

#------------------------------------------------------------
# pathの重複削除
# https://qiita.com/camisoul/items/78e43923615434ba519b
# 連想配列が使えるかどうかチェック
if typeset -A &>/dev/null; then
    # 使える場合
    typeset -A _paths
    typeset _results
    while read -r _p; do
        if [[ -n ${_p} ]] && ((${_paths["${_p}"]:-1})); then
            _paths["${_p}"]=0
            _results=${_results}:${_p}
        fi
    done <<<"${PATH//:/$'\n'}"
    PATH=${_results/:/}
    unset -v _p _paths _results
else
    # 使えない場合はawkで
    typeset _p=$(awk 'BEGIN{RS=":";ORS=":"} !x[$0]++' <<<"${PATH}:")
    PATH=${_p%:*:}
    unset -v _p
fi
