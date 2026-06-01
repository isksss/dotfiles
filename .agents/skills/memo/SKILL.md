---
name: memo
description: ユーザーが `/memo {文章}`、`$memo`、memo作成、メモして、業務メモ、あとで残す、質問や考えをメモに保存したいと依頼したときに使う。入力文を `$HOME/wiki/raw/memo/{yyyy}/{mm}/{yyyymmdd-hhmm}_{summary}.md` に保存し、疑問には回答を付け、業務上あとで必要になりそうな内容は背景・要点・次アクション・確認事項・リスクまで補完して記録する。
---

# memo

この skill は、ユーザーの短い入力や業務メモを Markdown として保存するために使う。

## 手順

1. 入力文を読む。
   - `/memo` や `$memo` などの呼び出し語は原文から除いて扱う。
   - 入力文の意味を変えずに、原文として保存する。
2. 疑問や質問が含まれる場合は回答する。
   - 事実確認が必要な内容は、必要に応じて調査する。
   - 確認できない内容は断定せず、未確認事項として記録する。
3. 業務上あとで必要になりそうな内容を積極的に補完する。
   - 背景、要点、判断理由、次アクション、確認事項、リスクを整理する。
   - 入力から明らかでない固有名詞、日付、決定事項は推測で断定しない。
4. `scripts/write_memo.py` で memo ファイルを作成する。
   - 保存先は `$HOME/wiki/raw/memo/{yyyy}/{mm}/{yyyymmdd-hhmm}_{summary}.md`。
   - 同じ分に同じ summary が存在する場合は `_2`, `_3` のように連番を付ける。
5. 最終回答では、保存したファイルパスと回答の要点だけを簡潔に伝える。

## 保存内容

保存する Markdown は frontmatter 付きにする。

- `title`: memo の題名
- `date`: 作成日
- `created_at`: 作成日時
- `source: memo`
- `recorded: false`
- `tags: [memo]`

本文には必要な見出しだけを含める。

- `原文`
- `回答`
- `補完メモ`
- `次アクション`
- `未確認事項`

## スクリプト

`scripts/write_memo.py` を使う。

```bash
python .agents/skills/memo/scripts/write_memo.py \
  --title-summary "short topic" \
  --input "原文" \
  --answer "回答" \
  --enrichment "補完メモ" \
  --next-actions "次アクション" \
  --unknowns "未確認事項" \
  --tags "memo,work"
```

## 注意事項

- 秘密情報、認証情報、API Key、Token、Password、Credential は出力・記録しない。
- 個人情報が含まれる場合は、必要最小限に要約し、不要な識別情報を保存しない。
- 外部情報や最新情報が必要な場合は、調査した根拠または未確認であることを補完メモに残す。
