#------------------------------------------------------------
#--------------------
# PATHを追加する
add_path() {
    local new_path="$1"
    export PATH="${new_path}:$PATH"
}

#------------------------------------------------------------
#--------------------
# xdg
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

#--------------------
# isksss
export ISKSSS_HOME="$XDG_DATA_HOME/isksss"
add_path "$ISKSSS_HOME/bin"
add_path "$ISKSSS_HOME/_bin"

# dotfiles
if [ -f "$HOME/.dotfiles_path" ]; then
    source "$HOME/.dotfiles_path"
fi

#--------------------
# aqua
export AQUA_ROOT_DIR="${XDG_DATA_HOME}/aquaproj-aqua/"
export AQUA_GLOBAL_CONFIG="$HOME/aqua.yaml"
export AQUA_PROGRESS_BAR=true # プログレスバー
export AQUA_LOG_COLOR=always  # ログのカラーリング
export AQUA_REMOVE_MODE=pl    # 削除モード. リンクとバイナリ両方消す
# export AQUA_LOG_LEVEL=debug # ログレベル(通常はinfo)
add_path "${AQUA_ROOT_DIR}/bin"

#--------------------
# zoxide
export _ZO_DOCTOR=0

#--------------------
# rust
add_path "$HOME/.cargo/bin"

#------------------------------------------------------------
#--------------------
# 使用した関数を削除
unset add_path
