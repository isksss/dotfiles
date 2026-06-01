---
name: devlog-matome
description: devlog 内の情報を収集し、内容ごとに整理して `$HOME/wiki/note/` にまとめる。ユーザーが `/devlog-matome`、devlogまとめ、作業記録の要約、devlogからnote作成、知見整理を依頼したときに使う。
---

# devlog-matome

この skill は、`$HOME/wiki/raw/devlog/` の作業記録を読み、再利用できる知見として `$HOME/wiki/note/` に整理するために使う。

## 参照ルール

- `.agents/rules/long-running-task.md`
- `.agents/rules/research.md`
- `.agents/rules/safety.md`

## 手順

1. まとめる範囲を決める。
   - topic、repo、branch、期間、関連ファイル、エラー文、コマンド名などで対象 devlog を絞る。
   - 指定が曖昧な場合は関連しそうな devlog を検索し、対象候補を示してからまとめる。

2. devlog を収集して分類する。
   - 既定対象は `$HOME/wiki/raw/devlog/`。
   - `rg` と `find` を優先して対象ファイルを洗い出す。
   - 内容ごとに、背景、原因、手順、判断、検証、残リスク、再利用できる知見へ分類する。
   - 重複や古い判断は統合し、現在有効な内容が分かるようにする。

3. note にまとめる。
   - 既定の保存先は `$HOME/wiki/note/{topic}.md`。
   - 既存 note がある場合は先に読み、重複を避けて追記または再編する。
   - 無関係な note は変更しない。
   - front matter が必要な場合は、既存 note の形式に合わせる。既存形式がなければ簡潔な Markdown 本文だけでよい。

4. 安全に記録する。
   - 秘密情報、認証情報、個人情報、API Key、Token、Password、Credential は note に書かない。
   - コマンド出力やログを転記する場合は、秘密情報の可能性がある値を除外またはマスクする。

## note の推奨構成

```markdown
# {topic}

## 概要

## 背景

## 手順・判断

## 検証

## 未確認事項・残リスク

## 参照 devlog
```

## 出力

- 作成または更新した note のパスを報告する。
- 参照した devlog、要約した内容、未確認事項を簡潔に示す。
