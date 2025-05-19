#!/bin/bash
#------------------------------------------------------------
# 実行ディレクトリ
SCRIPT_DIR=$(
    cd $(dirname $0)
    pwd
)
# dotfiles path
echo "export DOTFILES_PATH=${SCRIPT_DIR}" >"$HOME/.dotfiles_path"

# 共通環境変数のロード
source "$SCRIPT_DIR/env.sh"

#------------------------------------------------------------
#--------------------
# タイトル
function title() {
    local msg="$1"
    echo "########################################"
    echo "> ${msg}"
    echo "########################################"
}

#--------------------
# subtitle
subtitle() {
    local msg="$1"
    echo "--------------------"
    echo "[subtitle] ${msg}"
}

#--------------------
# info
info() {
    local msg="$1"
    echo "[info] ${msg}"
}

#--------------------
# シンボリックリンク作成
function link() {
    info "シンボリックリンク"
    if [ -e $2 ]; then
        rm -rf $2
    fi
    info "src: $1"
    info "dist: $2"
    ln -sf $1 $2
}

#------------------------------------------------------------
# 各ディレクトリ作成
title "ディレクトリ作成"
#--------------------
# xdg
mkdir -p "$XDG_CONFIG_HOME" "$XDG_CACHE_HOME" "$XDG_DATA_HOME" "$XDG_STATE_HOME"
#--------------------
# 作業ディレクトリ
mkdir -p "$HOME/work"

#------------------------------------------------------------
title "各アプリごとに設定を行う"
#--------------------
# env
subtitle "env"
link "$SCRIPT_DIR/env.sh" "$HOME/env.sh"

#--------------------
# bash
subtitle "bash"
link "$SCRIPT_DIR/.bashrc" "$HOME/.bashrc"

# localファイルの作成
bash_local_filename="$SCRIPT_DIR/.local/share/isksss/.bash_local"
if [ ! -f "$bash_local_filename" ]; then
    info ".bash_localを作成します。"
    touch "$bash_local_filename"
fi

mkdir -p "$XDG_CACHE_HOME/zsh/zcompcache"

#--------------------
# zsh
subtitle "zsh"
link "$SCRIPT_DIR/.zshenv" "$HOME/.zshenv"

#--------------------
# aqua
subtitle "aqua"
link "$SCRIPT_DIR/aqua.yaml" "$HOME/aqua.yaml"

#--------------------
# vim
subtitle "vim"
link "$SCRIPT_DIR/.vimrc" "$HOME/.vimrc"

#--------------------
# nvim
subtitle "vim"
link "$SCRIPT_DIR/.config/nvim" "$XDG_CONFIG_HOME/nvim"

#--------------------
# wezterm
subtitle "wezterm"
link "$SCRIPT_DIR/.config/wezterm" "$XDG_CONFIG_HOME/wezterm"

#--------------------
# lazygit
subtitle "wezterm"
link "$SCRIPT_DIR/.config/lazygit" "$XDG_CONFIG_HOME/lazygit"

#--------------------
# nushell
subtitle "nushell"
link "$SCRIPT_DIR/.config/nushell" "$XDG_CONFIG_HOME/nushell"

#--------------------
# starship
subtitle "starship"
link "$SCRIPT_DIR/.config/starship.toml" "$XDG_CONFIG_HOME/starship.toml"

#--------------------
# fonts
subtitle "fonts"
link "$SCRIPT_DIR/.fonts" "$HOME/.fonts"
if type -P "fc-cache" >/dev/null; then
    fc-cache -fv
fi

#--------------------
# git
subtitle "git"
link "$SCRIPT_DIR/.config/git" "$XDG_CONFIG_HOME/git"
local_git_config="$SCRIPT_DIR/.config/git/local/user.gitconfig"
if [ ! -f "$local_git_config" ]; then
    info "user.gitconfigを作成します"
    touch "$local_git_config"
    echo "[user]" > $local_git_config
    echo -e "\tname = isksss"
    echo -e "\temail = 104404522+isksss@users.noreply.github.com"
fi

#--------------------
# powershell
subtitle "powershell"
# win
case $(uname -a) in
Linux*)
    link "$SCRIPT_DIR/.config/powershell" "$XDG_CONFIG_HOME/powershell"
    ;;
MINGW*)
    link "$SCRIPT_DIR/.config/powershell/Microsoft.PowerShell_profile.ps1" "$HOME/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1"
    link "$SCRIPT_DIR/.config/powershell/Microsoft.PowerShell_profile.ps1" "$HOME/Documents/WindowsPowerShell/Microsoft.VSCode_profile.ps1"
    ;;
esac

#--------------------
# script and note, etc...
subtitle "isksss home"
link "$SCRIPT_DIR/.local/share/isksss" "$XDG_DATA_HOME/isksss"
# 個人スクリプトに実行権限を付与
info "スクリプトに実行権限を付与"
files=($(ls -1 "$SCRIPT_DIR/.local/share/isksss/bin"))
for file_name in "${files[@]}"; do
    info "スクリプト名: ${file_name}"
    chmod +x "$SCRIPT_DIR/.local/share/isksss/bin/${file_name}"
done

#------------------------------------------------------------
# osごとの変更
title "各OSごとの変更など"
