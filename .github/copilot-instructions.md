# Copilot Instructions

## Repository Overview

This is a [chezmoi](https://www.chezmoi.io/)-managed dotfiles repository. The source root is `home/` (defined in `.chezmoiroot`).

## chezmoi Naming Conventions

Files in `home/` follow chezmoi source naming rules:

| Source name          | Destination                                                 |
| -------------------- | ----------------------------------------------------------- |
| `dot_foo`            | `.foo`                                                      |
| `dot_config/bar`     | `~/.config/bar`                                             |
| `foo.tmpl`           | `foo` (Go template, processed at apply time)                |
| `.chezmoitemplates/` | Shared templates referenced with `{{- template "Name" . }}` |

When adding a new dotfile (e.g., `~/.config/example/config.toml`), place it at `home/dot_config/example/config.toml`.

## Key Commands

```sh
chezmoi diff        # Preview changes before applying
chezmoi apply       # Apply source state to home directory
chezmoi status      # Show which files differ
mise install        # Install all tools and runtimes defined in mise.toml
```

## Architecture

### Tool & Runtime Management

`mise` manages all CLI tools and language runtimes. There are two config files that must be kept in sync:

- `mise.toml` — repo root (used when working inside this repo)
- `home/dot_config/mise/config.toml` — deployed to `~/.config/mise/config.toml`

### AI Agent Instructions

`home/.chezmoitemplates/AGENTS.md` is the **single source of truth** for global AI assistant instructions. It is referenced by chezmoi templates for each AI tool:

- `home/dot_claude/CLAUDE.md.tmpl` → `~/.claude/CLAUDE.md`
- `home/dot_copilot/copilot-instructions.md.tmpl` → `~/.copilot/copilot-instructions.md`
- `home/dot_codex/AGENTS.md.tmpl` → `~/.codex/AGENTS.md`

To change global AI behavior, edit `home/.chezmoitemplates/AGENTS.md`, then run `chezmoi apply`.

### Shell Configuration

- `home/dot_zshenv` → `~/.zshenv`: XDG variables, `ZDOTDIR`, `PATH`, mise activation
- `home/dot_config/zsh/dot_zshrc` → `~/.config/zsh/.zshrc`: aliases, completions, tool initializations
- `home/dot_config/zsh/dot_zprofile` → `~/.config/zsh/.zprofile`: login shell settings

All tool initializations in `.zshrc` are guarded with `command -v <tool> >/dev/null 2>&1` checks.

### Work vs. Personal Environment

Work-specific behavior is controlled via `ISWORK` env var in `~/.config/zsh/local.zsh` (not managed by chezmoi). When `ISWORK` is unset, 1Password (`op`) is used to load SSH keys automatically.

### Neovim Configuration

Entry point: `home/dot_config/nvim/init.lua` loads `config.options`, `config.keymaps`, `config.lazy`.

Each feature has its own module under `lua/config/`:

- `lazy.lua` — plugin manager (lazy.nvim) with all plugin specs
- `lsp.lua` — LSP via mason-lspconfig (gopls, rust_analyzer, ts_ls, vue_ls, jdtls)
- `format.lua` — conform.nvim (runs on BufWritePre)
- `lint.lua` — nvim-lint
- `ddc.lua` — completion (Shougo/ddc.vim with denops)
- `ddu.lua` — fuzzy finder / filer (Shougo/ddu.vim with denops)
