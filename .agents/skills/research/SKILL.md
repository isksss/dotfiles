---
name: research
description: 実装前の調査、原因分析、仕様確認、影響範囲確認を行い、実装担当へ引き継げる記録を残す。調査・検証を依頼されたとき、または実装前に事実確認が必要なときに使う。
---

# research

この skill は、実装前に事実を集め、判断材料を整理するために使う。

## 参照ルール

- `.agents/rules/research.md`
- `.agents/rules/long-running-task.md`
- `.agents/rules/agent-separation.md`
- `.agents/rules/safety.md`

## 手順

1. 目的と成功条件を確認する。
   - ユーザー依頼、計画、既存 issue、関連ドキュメントを読む。
   - 不明点が repo から確認できる場合は質問せず調べる。

2. 関連箇所を調査する。
   - `rg`、`git diff`、entrypoint、設定、テストを優先して確認する。
   - 外部情報が必要な場合は一次情報を優先する。
   - 秘密情報や credential を出力しない。

3. 判断材料を整理する。
   - 事実、推測、未確認事項を分ける。
   - 影響範囲、リスク、実装候補を簡潔にまとめる。
   - 調査段階では原則 repo-tracked file を変更しない。

4. 記録する。
   - `{repo_root}/note.local.dir/agent/{yyyymmdd-hhmm}_research.md` に記録する。
   - 目的、確認したファイル、判明事項、残作業、推奨方針を書く。

## 成果物

- 実装担当が判断に迷わない調査メモ。
- 必要な場合のみ、実装計画または修正候補。
