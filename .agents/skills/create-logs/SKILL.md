---
name: create-logs
description: このセッション内でのやりとりを、`.agents/rules/long-running-task.md` の記録ルールに従って devlog に記録する。ログには、ユーザーからの質問や依頼、エージェントの回答や行動、実行したコマンドとその結果を含める。ログは日本語で書く。
---

# create-logs

このスキルは、現在のセッション内でのやりとりをリポジトリごとに記録するために使う。

## 手順

1. ユーザーからの質問や依頼、エージェントの回答や行動、実行したコマンドとその結果を記録する。
2. `.agents/rules/long-running-task.md` の記録ルールに従い、`$HOME/wiki/raw/devlog/{repo_name}/{branch_name}/{yyyymm}/{yyyymmdd}_{summary}.md` に保存する。
   - `{repo_name}` は、現在のリポジトリの名前に置き換える。
   - `{branch_name}` は、現在のブランチ名をファイルパスとして安全な名前に正規化する。
   - `{yyyymm}` と `{yyyymmdd}` は、ログを作成した日付に置き換える。
   - `{summary}` は、内容が分かる短い kebab-case または snake_case にする。
3. ファイル先頭に YAML front matter を記述し、共有用に整理済みの場合のみ `recorded: true` にする。

## ログの内容

- ユーザーからの質問や依頼を記録する。
- エージェントの回答や行動を記録する。
- 実行したコマンドとその結果を記録する。

### ログの形式

```markdown
---
title: "{メモのタイトル}"
repo: "{repo_name}"
branch: "{branch_name}"
date: "{yyyy-mm-dd}"
summary: "{短い要約}"
status: "draft"
recorded: false
tags:
  - devlog
task_type: "log"
verified: false
confidence: "medium"
---

# {メモのタイトル}

## ユーザーからの質問や依頼

- {質問や依頼の内容}

## エージェントの回答や行動

- {回答や行動の内容}

## 実行したコマンドとその結果

- コマンド: {実行したコマンド}
- 結果: {コマンドの実行結果}

## 留意点
```

## 注意事項

- 日本語で記述すること
