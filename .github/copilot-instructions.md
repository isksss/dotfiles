# Copilot Instructions

このファイルは GitHub Copilot 向けの薄い参照です。AI エージェント規約の正本は `.agents/AGENTS.md` とし、全体像は `README.md` の「AI エージェント規約」を参照してください。

## 正本

- `.agents/AGENTS.md`: グローバル指示
- `.agents/skills/`: Codex 中心の作業 skill

## Copilot 側の扱い

`.github/agents/*.agent.md` は `.agents/skills/` の wrapper です。詳細な挙動や作業方針は wrapper に重複させず、対応する skill の `SKILL.md` を参照します。

dotfiles の基本操作や配布先は `README.md` と `.dotfiles/mappings.json` を確認してください。
