---
name: review
description: 変更差分をレビューし、バグ、回帰、リスク、検証不足を指摘する。レビュー、テスト観点整理、実装後確認を依頼されたときに使う。
---

# review

この skill は、実装差分の品質確認とリスク整理に使う。

## 参照ルール

- `.agents/rules/review-test.md`
- `.agents/rules/development.md`
- `.agents/rules/agent-separation.md`
- `.agents/rules/safety.md`

## 手順

1. 差分を確認する。
   - `git status --short --branch`、`git diff --stat`、必要な `git diff` を読む。
   - 未追跡ファイル、生成物、秘密情報混入の有無を確認する。

2. 重要度順にレビューする。
   - バグ、回帰、データ破壊、セキュリティ、互換性、テスト不足を優先する。
   - 指摘はファイル、行、理由、修正方針を具体化する。
   - 問題がない場合も未検証範囲を明示する。

3. 検証する。
   - 変更範囲に応じて format、lint、typecheck、unit test、動作確認を選ぶ。
   - 実行できない検証は理由と影響を記録する。

4. 記録する。
   - `{repo_root}/note.local.dir/agent/{yyyymmdd-hhmm}_review.md` に記録する。
   - 指摘、検証結果、残リスク、次の対応を書く。

## 成果物

- 重大度順のレビュー結果。
- 実行済み検証と未検証範囲。
