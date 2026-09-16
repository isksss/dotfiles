# コマンド置換対応表

検索コマンドは次の対応表に従って選ぶ。ファイル内容の確認には `read` を使う。

| 用途                                        | 置換対象                      | 使用するコマンド例                                                                |
| ------------------------------------------- | ----------------------------- | --------------------------------------------------------------------------------- |
| ファイル名の検索                            | `find . -type f -name '*.md'` | `fd --type f --glob '*.md' . .`                                                   |
| 内容の検索                                  | `grep -rn 'pattern' .`        | `rg -n 'pattern' .`                                                               |
| ファイル一覧の取得                          | `find . -type f`              | `fd --type f . .` または `rg --files .`                                           |
| 隠しファイルも含むファイル一覧              | `find . -type f`              | `fd --hidden --type f . .` または `rg --files --hidden .`                         |
| 隠しファイル・ignore 対象も含むファイル一覧 | `find . -type f`              | `fd --hidden --no-ignore --type f . .` または `rg --files --hidden --no-ignore .` |
| 隠しファイル・ignore 対象も含む内容検索     | `grep -rn 'pattern' .`        | `rg -n --hidden --no-ignore 'pattern' .`                                          |

- ファイル検索は `find` ではなく `fd`、内容検索は `grep` ではなく `rg` を使う。
- `fd` / `rg` は通常、隠しファイルや ignore 対象を除外する。必要な範囲に合わせて `--hidden` / `--no-ignore` を指定する。`find` / `grep` と検索範囲が常に一致するわけではない。
- `fd` / `rg` が利用できない場合のみ、それぞれ `find` / `grep` にフォールバックする。
