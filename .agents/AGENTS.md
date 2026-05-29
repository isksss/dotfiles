# Global AGENTS.md

## 目的

このドキュメントは、エージェントが最初に読む個人共通ルールを定義する。
詳細ルールは必要に応じて `.agents/rules/`、`.agents/skills/`、`.agents/templates/` を参照する。

---

## 常時ルール

- 最終回答は日本語で、簡潔・明確・実行可能性を優先する。
- 推測より事実を優先し、不明点は明示する。
- 既存実装・既存規約を尊重し、変更は最小化する。
- 要求範囲のみ対応し、無関係ファイルは変更しない。
- 個人情報・秘密情報・認証情報・API Key・Token・Password・Credential は出力しない。
- ユーザー指示なしに commit しない。
- 破壊的操作、本番 deploy、force push、secret 更新、package publish はユーザー明示許可なしに行わない。
- リポジトリルートに`AGENTS.local.md`がある場合、AGENTS.mdと同様に読み込む

---

## 詳細ルール

- 回答・コミュニケーション: `~/.agents/rules/communication.md`
- 禁止事項・セキュリティ: `~/.agents/rules/safety.md`
- 開発・検証: `~/.agents/rules/development.md`
- Git 運用: `~/.agents/rules/git.md`
- 長時間タスク: `~/.agents/rules/long-running-task.md`
- 調査・検証: `~/.agents/rules/research.md`
- テスト・レビュー: `~/.agents/rules/review-test.md`
- 実装: `~/.agents/rules/implementation.md`
- エージェント分離: `~/.agents/rules/agent-separation.md`

---

## Codex Skills

Codex で利用する agent 相当の正本は `.agents/skills/` に置く。
GitHub Copilot 用 agent は `.github/agents/` に置くが、内容が競合する場合は Codex skill を優先する。

- 調査: `~/.codex/skills/research/SKILL.md`
- 実装: `~/.codex/skills/implementation/SKILL.md`
- レビュー: `~/.codex/skills/review/SKILL.md`

---

## テンプレート

- コード変更時の最終回答: `.agents/templates/code-change-report.md`
