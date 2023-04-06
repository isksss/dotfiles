#!/bin/bash

# 対象となるディレクトリを指定
export DOTFILES="$HOME/dotfiles"

# ディレクトリ内のシンボリックリンクをすべて削除
find "$DOTFILES" -type l -delete
