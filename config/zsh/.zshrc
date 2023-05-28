# zshrc

# 環境変数
export EDITOR=code

HISTFILE=$XDG_CACHE_HOME/zsh/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# 共通設定
setopt no_beep # ベル音を鳴らさない
setopt hist_ignore_dups # ヒストリに重複したコマンドを保存しない
setopt hist_reduce_blanks # ヒストリに連続した空白を1つにする
setopt inc_append_history # ヒストリに即時保存
setopt share_history # 複数のターミナルでヒストリを共有
setopt hist_expire_dups_first # ヒストリの重複を削除する
setopt prompt_subst # プロンプトにコマンドの出力を埋め込む
setopt auto_cd # ディレクトリ名のみでcdする
setopt auto_pushd # pushd, popd, dirsを自動的に実行
setopt pushd_ignore_dups # pushdで重複したディレクトリをスキップ

# colors
autoload -U colors; colors

# Load all files in ~/.config/zsh/.zshrc.d
for f in $XDG_CONFIG_HOME/zsh/.zshrc.d/*.zsh; do
  source $f
done

# local settings
if [ -f "$ZDOTDIR/zshrc.local.zsh" ]; then
  source $ZDOTDIR/zshrc.local.zsh
fi