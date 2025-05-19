# インタラクティブでなければ終了
[[ -o interactive ]] || return

# 各種設定ファイルの読み込み
source "$ZDOTDIR/basic.zsh"
source "$ZDOTDIR/options.zsh"
source "$ZDOTDIR/keybinds.zsh"
source "$ZDOTDIR/completion.zsh"
source "$ZDOTDIR/aliases.zsh"
source "$ZDOTDIR/plugins.zsh"

# ローカル設定（存在する場合のみ）
[[ -f "$ISKSSS_HOME/.zsh_local" ]] && source "$ISKSSS_HOME/.zsh_local"
