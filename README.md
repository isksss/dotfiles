# [dotfiles](https://github.com/isksss/dotfiles)

`chezmoi` で管理している個人用 dotfiles です。

## 使用ツール

- [chezmoi](https://www.chezmoi.io/): dotfiles の配置と適用
- [mise](https://github.com/jdx/mise): CLI ツールと言語ランタイムの管理

```sh
# miseをinstall
curl https://mise.run | sh
# dotfilesをセットアップ
"$HOME/.local/bin/mise" exec chezmoi@latest -- "chezmoi init --apply isksss && mise up"
```

## セットアップ

適用前に差分を確認してから反映します。

```sh
chezmoi diff
chezmoi apply
mise install
```

### 個人使用でOPコマンドが入っていない場合

下記を`"$ZDOTDIR/local.zsh"`に追加する

```sh
export ISWORK=work
```
