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
        chsh -s $(which zsh) || chsh -s "/usr/bin/zsh"
        echo "Changed default shell to zsh"
    else
        echo "zsh not found"
    fi
}

# Rust
rust-install(){
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

rye-install(){
    curl -sSf https://rye-up.com/get | bash
}

# Option
opt(){
    echo "==OPTION=="
    while getopts o:rpc option
    do  
        case $option in
            o) echo "OS:${OPTARG}. " && os-script $OPTARG;;
            r) echo "Rustをインストールします。" && rust-install;;
            p) echo "Ryeをインストールします。"&& rye-install;;
            c) echo "シェルを変更します。" && chsh_zsh;;
            *) echo "該当なし(OPT=$OPT)";;
        esac
    done
}

# os
os-script(){
    local os=$1
    case $os in
        manjaro) echo "manjaro" && sh ./script/manjaro.sh;;
        ubuntu) echo "ubuntu" && sh ./script/ubuntu.sh;;
        *) echo "該当なし(OS=$os)";;
    esac
}

# git
git-config(){
    # default branch
    git config --global init.defaultBranch main

    # push.default
    git config --global push.default current

    # pull.ff
    git config --global pull.ff only

    # core
    git config --global core.editor vim
    git config --global core.excludesfile $HOME/.gitignore_global

    # grep
    git config --global grep.lineNumber true

    # diff
    git config --global color.diff auto
    git config --global color.status auto
    git config --global color.branch auto

    # prune
    git config --global fetch.prune true

    # ui
    git config --global color.ui true

    # encode
    git config --global core.quotepath false
}

main(){
    # XDGディレクトリの作成
    craete_xdg_dir
    # workspace
    mkdir -p "$HOME/workspace"
    # シンボリックリンクを作成
    linkdir "$SCRIPT_DIR/home" "$HOME"
    linkdir "$SCRIPT_DIR/.config" "$XDG_CONFIG_HOME"
    remove_symlinks

    # git
    git-config
    
    # option
    opt "$@"
}

main "$@"