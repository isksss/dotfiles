#!/bin/bash

## var
SCRIPT_DIR=$(cd $(dirname $0); pwd)
XDG_CONFIG_HOME="$HOME/.config"

## func

linkdir(){
    local dir="$1"
    local target_dir="$2"
    for file in $(ls -a $dir);do
        if [ $file = "." ] || [ $file == ".." ];then
            continue
        fi
        local symfile="$dir/$file"
        ln -sf $symfile $target_dir/$file
    done
}

remove_symlinks(){
    find . -type l -exec rm {} \;
}


craete_xdg_dir(){
    # XDGディレクトリの作成
    local XDG_CONFIG_HOME="$HOME/.config"
    local XDG_CACHE_HOME="$HOME/.cache"
    local XDG_DATA_HOME="$HOME/.local/share"
    mkdir -p "$XDG_CONFIG_HOME"
    mkdir -p "$XDG_CACHE_HOME"
    mkdir -p "$XDG_DATA_HOME"
}

chsh_zsh(){
    if command -v zsh >/dev/null 2>&1; then
        chsh -s $(which zsh)
        echo "Changed default shell to zsh"
    else
        echo "zsh not found"
    fi
}

main(){
    # シンボリックリンクを作成
    linkdir "$SCRIPT_DIR/home" "$HOME"
    linkdir "$SCRIPT_DIR/.config" "$XDG_CONFIG_HOME"
    remove_symlinks

    # shell
    chsh_zsh
}

main