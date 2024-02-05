# zshrc

#####
# var
#####
export EDITER=nvim

# settings
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

## if zshrc.local.zsh not exists, create it
if [ ! -e $XDG_CONFIG_HOME/zsh/local.d/zshrc.local.zsh ]; then
  touch $XDG_CONFIG_HOME/zsh/local.d/zshrc.local.zsh
fi
for f in $ZDOTDIR/local.d/*.zsh; do
  source $f
done

# pyenv
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init --path)"
  eval "$(pyenv virtualenv-init -)"
fi

# starship
eval "$(starship init zsh)"