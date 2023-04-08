#!/usr/bin/env bash
# MacOSのセットアップスクリプト
export DOTFILES="$HOME/dotfiles"

function main(){
    # symlink
    $DOTFILES/etc/setup/symlink.sh

    # delete symlink
    $DOTFILES/etc/setup/del_sym.sh
}

main