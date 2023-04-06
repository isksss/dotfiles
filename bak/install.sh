#!/usr/bin/env bash

## Install script for the dotfiles
## Author: @isksss

# Variables
DOTFILES_DIR="$HOME/dotfiles"
DOTFILES_HTTPS_REPO="https://github.com/isksss/dotfiles"
DOTFILES_GIT_REPO="git@github.com:isksss/dotfiles.git"
XDG_CONFIG_HOME="$HOME/.config"

# Functions
function install_dotfiles() {
    # Clone the dotfiles repo
    git clone "$DOTFILES_HTTPS_REPO" "$DOTFILES_DIR"

    # Install the dotfiles
    cd "$DOTFILES_DIR" || exit
    ./install.sh
}

# httpsでcloneしたdotfilesのremoteをsshに変更
function change_remote() {
    cd "$DOTFILES_DIR" || exit
    git remote set-url origin "$DOTFILES_GIT_REPO"
}

# DOTFILES_DIRの更新
function update_dotfiles() {
    cd "$DOTFILES_DIR" || exit
    git pull
}

# DOTFILES_DIR内のファイルのシンボリックリンクをホームディレクトリに作成
function update_symlinks() {
    cd "$DOTFILES_DIR" || exit
    
    ## ホームディレクトリにシンボリックリンクを作成
    for file in .??*; do
        
        # install.shとetc/とREADME.mdはスキップ
        IGNORE_FILES=(.git install.sh etc README.md )
        if [[ "${IGNORE_FILES[@]}" =~ "$file" ]]; then
            continue
        fi

        # .configディレクトリの場合はそのなかのファイル、ディレクトリのシンボリックリンクを＄HOME/.configに作成
        if [ "$file" = ".config" ]; then
            # .configディレクトリが存在しない場合は作成
            if [ ! -d "$XDG_CONFIG_HOME" ]; then
                mkdir "$XDG_CONFIG_HOME"
            fi
            for config_file in .config/*; do

                if [ "$file" = "Code" ];then
                    chmod +x "$DOTFILES_DIR/etc/vscode/install.sh"
                    $DOTFILES_DIR/etc/vscode/install.sh
                    continue
                fi

                ln -sfn "$DOTFILES_DIR/$config_file" "$HOME/$config_file"
            done
            continue
        fi

        # ホームディレクトリにシンボリックリンクを作成
        ln -sfn "$DOTFILES_DIR/$file" "$HOME/$file"
    done
}

# OS別振り分け関数
function os_specific() {

    cd "$DOTFILES_DIR" || exit

    # OS別の設定
    if [ "$(uname)" == 'Darwin' ]; then
        # Mac
        echo "Mac"
        chmod +x "$DOTFILES_DIR/etc/os/macos/install.sh"
        $DOTFILES_DIR/etc/os/macos/install.sh
        
    elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
        # Linux

        # Manjaroの場合
        if [ -f /etc/manjaro-release ]; then
            echo "Manjaro"
            chmod +x "$DOTFILES_DIR/etc/os/manjaro/install.sh"
            $DOTFILES_DIR/etc/os/manjaro/install.sh
            return
        fi

        # archlinuxの場合
        if [ -f /etc/arch-release ]; then
            echo "Arch Linux"
            chmod +x "$DOTFILES_DIR/etc/os/arch/install.sh"
            $DOTFILES_DIR/etc/os/arch/install.sh
            return
        fi

        # ubuntuの場合
        if [ -f /etc/lsb-release ]; then
            echo "Ubuntu"
            return
        fi

    elif [ "$(expr substr $(uname -s) 1 10)" == 'MINGW32_NT' ]; then
        # Windows
        echo "Windows"
    fi
}

# Main
function main() {
    # Install the dotfiles
    if [ -d "$DOTFILES_DIR" ]; then
        echo "dotfiles directory already exists."
        update_dotfiles
    else
        echo "dotfiles directory does not exist."
        install_dotfiles
        change_remote
    fi

    # Symbolic link
    update_symlinks

    # Update the dotfiles
    # update_dotfiles

    # OS specific settings
    os_specific
}

main