XDG_CONFIG_HOME ?= $(HOME)/.config
XDG_CACHE_HOME ?= $(HOME)/.cache
XDG_DATA_HOME ?= $(HOME)/.local/share

.PHONY: help
help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  init    Create directories"
	@echo "  git     Configure git"
	@echo "  link    Create symlinks"
	@echo "  deno    Install deno"
	@echo "  rust    Install rust"
	@echo "  rye     Install rye"

.PHONY: all
all: init git link

.PHONY: init
init:
	@mkdir -p $(XDG_CONFIG_HOME)
	@mkdir -p $(XDG_CACHE_HOME)
	@mkdir -p $(XDG_DATA_HOME)

.PHONY: git
git:
	@git config --global user.name isksss
	@git config --global user.email 104404522+isksss@users.noreply.github.com
	@git config --global init.defaultBranch main

.PHONY: link
link: init
	@ln -sf $(PWD)/home/.zshenv ~/.zshenv
	@ln -sf $(PWD)/.config/zsh $(XDG_CONFIG_HOME)/zsh

	@ln -sf $(PWD)/.config/git $(XDG_CONFIG_HOME)/git
	@ln -sf $(PWD)/.config/nvim $(XDG_CONFIG_HOME)/nvim
	@ln -sf $(PWD)/.config/starship $(XDG_CONFIG_HOME)/starship

	@find . -type l -exec rm {} \;

.PHONY: deno
deno:
	@curl -fsSL https://deno.land/x/install/install.sh | sh

.PHONY: rust
rust:
	@curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

.PHONY: rye
rye:
	@curl -sSf https://rye-up.com/get | RYE_INSTALL_OPTION="--yes" bash
