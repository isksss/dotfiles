---
name: review
description: >-
  変更差分をレビューし、バグ、回帰、リスク、検証不足を重大度順に指摘する。
  コードレビュー、レビュー、テスト観点整理、実装後確認を依頼されたときに使う。
---

# review

この skill は、実装差分の品質確認とリスク整理に使う。
レビュー系 skill はこれに統一する。

## 参照ルール

- `.agents/rules/review-test.md`
- `.agents/rules/development.md`
- `.agents/rules/agent-separation.md`
- `.agents/rules/safety.md`

## 手順

1. 差分と前提を確認する。
   - `git status --short --branch`、`git diff --stat`、
     `git diff --cached --stat` を読む。
   - 必要な `git diff`、`git diff --cached`、未追跡ファイルの内容を確認する。
   - 変更対象の周辺ファイル、README、設定、テスト、公開 API の利用箇所を
     必要最小限で確認する。
   - `.agents/AGENTS.md`、`.agents/rules/**/*.md`、
     `.github/copilot-instructions.md` などと矛盾しないか確認する。

2. 重要度順にレビューする。
   - 仕様逸脱、バグ、回帰、データ破壊、セキュリティ、互換性、
     テスト不足を優先する。
   - null / undefined、空値、境界値、例外経路、非同期処理、状態更新、
     権限、入力処理、シェル実行、パス操作を確認する。
   - 公開関数、設定項目、CLI 引数、環境変数、テンプレート、
     ファイル名変更などの破壊的変更を確認する。
   - 指摘はファイル、行、理由、再現条件または影響、修正方針を具体化する。
   - 断定できる事実と推測を分け、問題がない場合も確認観点と
     未検証範囲を明示する。

3. 安全確認と検証を行う。
   - 認証情報、トークン、秘密鍵、個人情報、機密情報、マシン固有パス、
     不要な生成物が差分に含まれていないか確認する。
   - 通常は読み取り中心でレビューし、短時間で有効な場合だけ format、
     lint、typecheck、unit test、動作確認を実行する。
   - 実行できない検証は理由と影響を記録する。

4. 記録する。
   - `.agents/rules/long-running-task.md` の記録ルールに従い、devlog に記録する。
   - 指摘、検証結果、残リスク、次の対応を書く。
   - 秘密情報、認証情報、個人情報は記録しない。

## 成果物

- 重大度順のレビュー結果。
- 確認観点、実行済み検証、未検証範囲。
