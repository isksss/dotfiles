#!/usr/bin/env zsh

# 削除対象のディレクトリのパス
target_directory=$1

# ディレクトリ内のファイル・ディレクトリを再帰的に処理
for file in $target_directory/**/*(D); do
  # シンボリックリンクの場合のみ削除
  if [[ -L $file ]]; then
    # echo "Removing symbolic link: $file"
    rm $file
  fi
done
