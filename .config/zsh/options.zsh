# オプション設定
setopt AUTO_CD             # ディレクトリ名だけでcd
setopt AUTO_PUSHD          # pushdの履歴管理
setopt PUSHD_IGNORE_DUPS   # 重複を無視
setopt CORRECT             # 軽微なスペル修正
setopt INTERACTIVE_COMMENTS
setopt NO_FLOW_CONTROL

# パスの重複除去
typeset -U path
export PATH="${(j/:/)path}"
