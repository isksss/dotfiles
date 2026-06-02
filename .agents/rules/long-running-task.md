# Task Recording Rules

## when to use

- エージェントがリポジトリに対して調査、実装、検証、レビュー、Git 操作、外部ツール実行など何らかの行動を行うとき。
- 長時間タスク、短時間タスク、単発コマンド確認のいずれでも、後から知見として参照できる記録を残す。

## 基本方針

- 目的、現在地、残作業、既知のリスクを短く維持する。
- 30秒以上進展共有がない場合、進捗または待機理由を伝える。
- 長時間コマンドは完了まで放置せず、必要に応じて途中出力を確認する。
- 中断や再開に備え、実施した行動、判断理由、検証結果を記録する。
- 記録は長時間タスクに限定せず、すべての行動について作成または追記する。

## 記録

- 調査、実装、検証、レビュー、Git 操作、外部ツール実行などの行動内容を `$HOME/wiki/raw/devlog/{repo_name}/{branch_name}/{yyyymm}/` に記録する。
- ファイル名は `{yyyymmdd}_{summary}.md` とする。
  - `{summary}` は内容が分かる短い kebab-case または snake_case とし、秘密情報、認証情報、個人情報を含めない。
  - `{branch_name}` はファイルパスとして安全な名前に正規化する。`/` などの区切り文字は `-` に置換する。
- 秘密情報、認証情報、個人情報は記録しない。

## 補助ログ

- 必要に応じて当該記録ファイルの年月ディレクトリ内に `log/` ディレクトリを作成し、変更内容や検証に関係する補助ログを保存する。
  - 保存先は `$HOME/wiki/raw/devlog/{repo_name}/{branch_name}/{yyyymm}/log/` とする。
  - ファイル名は devlog 本体の stem を prefix にして、`{yyyymmdd}_{summary}.git-diff.patch` のようにする。
- Git 情報は必要に応じて以下を保存する。
  - `git status --short --branch`
  - `git diff --stat`
  - `git diff`
  - `git diff --cached --stat`
  - `git diff --cached`
  - `git log --oneline -n 20`
- `playwright-cli`、テスト、ビルド、lint、typecheck、外部ツール実行など、再現や判断確認に必要なログも必要に応じて保存する。
- devlog 本体には、保存した補助ログへの相対パスと内容要約を「関連ログ」として記録する。
- コマンド出力や差分を保存する場合は、秘密情報、認証情報、個人情報、API Key、Token、Password、Credential を必ず除外またはマスクする。

## 記録ファイルの metadata

- md ファイルの先頭には YAML front matter を記述する。
- 知見共有用として整理済みのメモには `recorded: true` を設定する。
- 作業途中、未整理、または事実確認が残るメモは `recorded: false` を設定する。
- 必須 metadata は以下とする。

```yaml
---
title: "メモのタイトル"
repo: "{repo_name}"
branch: "{branch_name}"
date: "{yyyy-mm-dd}"
summary: "何を調査・実装・検証したかの短い要約"
status: "draft"
recorded: false
tags:
  - devlog
---
```

- 必要に応じて以下の metadata を追加する。
  - `task_type`: `research`、`implementation`、`debug`、`review`、`test` などの作業種別。
  - `related_files`: 判断や変更に関係した主要ファイル。
  - `related_issue`: issue、MR、PR、チケット番号や URL。
  - `verified`: 検証済みなら `true`、未検証なら `false`。
  - `confidence`: `high`、`medium`、`low` のいずれか。未確認事項が多い場合は `low` にする。

## 記録内容

- 記録は、後から社内に知見として共有できる詳細メモとして書く。
- 単なる作業ログではなく、同じ問題を再調査せずに済む粒度で、背景、判断、手順、結果を具体的に残す。
- 原則として以下を含める。
  - 目的、背景、発生していた問題や依頼内容。
  - 当該リポジトリの構成、関連ディレクトリ、主要 entrypoint、設定ファイル。
  - 調査で確認したファイル、設定、ログ、外部仕様、既存実装。
  - 実行したコマンド、確認した出力の要点、失敗したコマンドと失敗理由。
  - 実施した修正内容、修正理由、採用しなかった選択肢とその理由。
  - 検証内容、検証結果、未検証事項、残リスク。
  - 保存した補助ログへの相対パスと内容要約。
  - 再利用できる知見、次回同種タスクで先に確認すべき観点。
- コマンド出力や差分を貼る場合は、秘密情報、認証情報、個人情報を必ず除外またはマスクする。
