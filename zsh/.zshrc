# zshrc

# 環境変数
# ENV
export EDITOR=nvim

# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# 共通設定

## autoload
autoload -U colors; colors # 色読み込み
autoload -U compinit; compinit # 補完読み込み

## setopt
setopt no_beep # ベル音を鳴らさない
setopt auto_cd # cdの引数がディレクトリの場合は自動的にcdする
setopt auto_pushd # pushdの引数がディレクトリの場合は自動的にpushdする
setopt pushd_ignore_dups
setopt pushd_minus # pushd -で一つ前のディレクトリに移動
setopt pushd_silent # pushdの出力を抑制
setopt extended_glob # ワイルドカードの拡張
setopt hist_ignore_dups # ヒストリに重複したコマンドを保存しない
setopt hist_reduce_blanks # ヒストリに連続した空白を1つにする
setopt inc_append_history # ヒストリに即時保存
setopt prompt_subst # プロンプトが表示されるたびにプロンプト文字列を評価、置換する

# zsh/の中のファイルを読み込む
for f in $HOME/.zsh/*.zsh; do
  source $f
done