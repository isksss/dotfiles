#!/usr/bin/env bash
# vscodeのCode.exeがある場所で実行してください。
if [ -f "$HOME/.dotfiles_path" ]; then
    source "$HOME/.dotfiles_path"
fi

if [ ! -e "./Code.exe" ]; then
    echo "Code.exeがない！"
    exit 1
fi

mkdir -p "./data/user-data/User"
ln -sf "$DOTFILES_PATH/.vscode/settings.json" "./data/user-data/User/settings.json"
