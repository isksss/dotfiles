---
name: wiki-organizer
description: memo と devlog を読み、`$HOME/wiki/note/` 配下に検索性の高い wiki として整理したいときに使う。ユーザーが `$wiki-organizer`、wiki構築、memo整理、devlog整理、note化、知見整理、関連ファイルを相対リンクでつなぐ、ディレクトリツリーを切って整理すると依頼したときに、raw 情報を内容別に統合し、適切な note 階層、frontmatter、相対リンク、参照元リンク、関連 note リンクを作成・更新する。
---

# wiki-organizer

この skill は、`$HOME/wiki/raw/memo/` と `$HOME/wiki/raw/devlog/` の断片情報を、再利用しやすい wiki として `$HOME/wiki/note/` に整理するために使う。

## 参照ルール

- `.agents/rules/safety.md`
- `.agents/rules/research.md`
- `.agents/rules/long-running-task.md`

## 手順

1. 対象範囲を決める。
   - 指定された topic、期間、repo、branch、関連ファイル、キーワードを使って raw memo/devlog を絞る。
   - 指定が曖昧な場合は、`$HOME/wiki/raw/memo/` と `$HOME/wiki/raw/devlog/` を広めに検索し、関連度が高い候補から整理する。
2. raw 情報を読む。
   - `rg` と `find` を優先する。
   - memo は発想・未確定事項・業務 TODO として扱う。
   - devlog は実施済み作業・検証結果・判断履歴として扱う。
   - 古い判断と新しい判断が競合する場合は、日付順に整理し、現在有効な判断を明示する。
3. note の配置を決める。
   - 保存先は `$HOME/wiki/note/` 配下。
   - topic が広い場合は `domain/topic.md` または `domain/topic/index.md` に分ける。
   - 同一 topic の note が既にある場合は先に読み、重複を避けて更新する。
   - 1 note が肥大化する場合は、概要 note と詳細 note に分け、相互リンクする。
4. note を書く。
   - frontmatter を付ける。
   - 本文は検索で拾いやすい用語、略称、関連 repo、関連ファイル名を自然に含める。
   - 参照した raw memo/devlog と関連 note は、note ファイルからの相対リンクで書く。
   - 関連するローカルリポジトリファイルも、可能なら相対リンクで書く。
5. 作業記録を残す。
   - リポジトリ作業を伴った場合は `.agents/rules/long-running-task.md` に従って devlog に記録する。

## note の推奨 frontmatter

```yaml
---
title: "{note title}"
summary: "{検索時に分かる短い要約}"
status: "draft"
recorded: true
tags:
  - wiki
  - "{topic}"
updated: "{yyyy-mm-dd}"
sources:
  - "../relative/path/to/source.md"
related:
  - "./relative-related-note.md"
---
```

既存 note に異なる形式がある場合は、既存形式を優先する。

## note の推奨構成

```markdown
# {note title}

## 概要

## 背景

## 現在の結論

## 手順・運用

## 判断履歴

## 未確認事項

## 関連リンク

## 参照元
```

不要な見出しは省略してよい。検索性を上げるため、`概要` と `現在の結論` はできるだけ残す。

## ディレクトリ設計

- `engineering/`: 実装、設計、開発環境、CI、運用手順。
- `operations/`: 業務運用、研修、社内手続き、定例作業。
- `tools/`: 利用ツール、設定、ワークフロー。
- `projects/`: 特定プロジェクトや継続案件。
- `people/` は原則作らない。個人情報を避け、必要なら役割名で書く。

迷う場合は、後から移動しやすいように `inbox/{topic}.md` に置き、関連 note からリンクする。

## リンク規則

- note から raw memo/devlog へのリンクは相対パスにする。
- note 同士のリンクも相対パスにする。
- リンクテキストは日付や topic が分かる名前にする。
- 絶対パス、`file://`、ホームディレクトリ展開済みパスは使わない。
- 移動や分割をした場合は、関連 note へ backlink を追加する。

相対リンク計算には `scripts/relative_link.py` を使える。

```bash
python .agents/skills/wiki-organizer/scripts/relative_link.py \
  --from "$HOME/wiki/note/operations/training/review-test.md" \
  --to "$HOME/wiki/raw/memo/2026/06/example.md"
```

## 安全上の注意

- 秘密情報、認証情報、API Key、Token、Password、Credential は note に書かない。
- 個人情報は不要なら省き、必要な場合も役割や匿名化した表現にする。
- raw 情報に秘密情報の可能性がある場合は、引用せず「要確認」として扱う。
