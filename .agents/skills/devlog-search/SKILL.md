---
name: devlog-search
description: devlog や note 内の情報を検索し、根拠ファイルと要点を整理する。ユーザーが `/devlog-search`、devlog検索、過去ログ検索、note検索、過去の作業記録確認を依頼したときに使う。
---

# devlog-search

この skill は、`$HOME/wiki/raw/devlog/` と `$HOME/wiki/note/` から過去の作業記録や整理済み note を探すために使う。

## 参照ルール

- `.agents/rules/research.md`
- `.agents/rules/safety.md`

## 手順

1. 検索目的を確認する。
   - 探したい topic、repo、期間、関連ファイル、エラー文、コマンド名などを把握する。
   - 不明な場合は広めに検索し、見つかった候補を絞り込む。

2. 対象ディレクトリを検索する。
   - 既定対象は `$HOME/wiki/raw/devlog/` と `$HOME/wiki/note/`。
   - `rg` を優先し、必要に応じて `find`、`git log`、front matter を確認する。
   - repo や branch が分かる場合は `$HOME/wiki/raw/devlog/{repo}/` 以下から探す。

3. 結果を整理する。
   - 該当ファイル、日付、topic、要点、根拠を分ける。
   - 事実、推測、未確認事項を混ぜない。
   - 複数記録がある場合は時系列で並べ、古い判断と新しい判断の差分を明示する。

4. 安全に回答する。
   - 秘密情報、認証情報、個人情報、API Key、Token、Password、Credential は出力しない。
   - 検索結果に秘密情報の可能性がある場合は、該当箇所を引用せず存在だけ伝える。

## 出力

- 日本語で簡潔にまとめる。
- 可能な限りファイルパスを示す。
- 見つからなかった場合は、検索した語句と対象範囲、次に試す候補を示す。
