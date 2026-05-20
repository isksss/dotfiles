# [dotfiles](https://github.com/isksss/dotfiles)

`rhysd/dotfiles` で symlink 管理している個人用 dotfiles です。

## 使用ツール

- [dotfiles](https://github.com/rhysd/dotfiles): dotfiles の配置と symlink 管理
- [mise](https://github.com/jdx/mise): CLI ツールと言語ランタイムの管理

## セットアップ

```sh
go install github.com/rhysd/dotfiles@latest
dotfiles clone isksss/dotfiles
cd dotfiles
dotfiles link --dry
dotfiles link
mise install
```

`dotfiles` は `.dotfiles/mappings.json` を読み、`home/` 配下の実ファイルをホームディレクトリへ symlink します。

## 日常的な操作

```sh
dotfiles list
dotfiles link --dry
dotfiles link
dotfiles clean
dotfiles update
```

## 管理対象外

- `home/dot_config/git/config.work`: 個人・業務別の追加 gitconfig
- `home/dot_config/zsh/local.zsh`: ローカル環境ごとの zsh 設定
- `.env` / `.env.*`: 環境変数ファイル
