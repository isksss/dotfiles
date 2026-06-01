# Agent Separation Rules

## when to use

- 調査、実装、レビュー、検証を含む作業を行うとき。
- サブエージェントまたは専用 skill を利用できる環境で作業するとき。

## 基本方針

- 調査、実装、レビューは可能な限り別 agent または別 skill で分離する。
- Codex では `.agents/skills/research`、
  `.agents/skills/implementation`、`.agents/skills/review` を優先する。
- GitHub Copilot では `.github/agents/*.agent.md` を補助的に利用する。
- 共通化できない場合は Codex skill を正本として優先する。

## 役割分担

- Research agent: 事実確認、原因分析、影響範囲、実装方針案を担当する。
- Implementation agent: 合意済み方針に基づく最小実装を担当する。
- Review agent: 差分レビュー、テスト観点、残リスク整理を担当する。

## 記録

- 各 agent は `.agents/rules/long-running-task.md` の記録ルールに従い、目的、確認内容、判断、残作業を devlog に記録する。
- 他 agent が引き継げるよう、推測と事実を分けて書く。
- 秘密情報、認証情報、個人情報は記録しない。
