XDG_CONFIG_HOME ?= $(HOME)/.config
XDG_CACHE_HOME ?= $(HOME)/.cache
XDG_DATA_HOME ?= $(HOME)/.local/share

WORKSPACE ?= $(HOME)/workspace

.PHONY: help
help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  init     Setup all"
	@echo "  deno    Install deno"
	@echo "  rust    Install rust"
	@echo "  rye     Install rye"

.PHONY: init
init:
	@bash script/init.sh $(PWD)

.PHONY: git
git:
	@git config --global user.name isksss
	@git config --global user.email 104404522+isksss@users.noreply.github.com
	@git config --global init.defaultBranch main
	@git config --global fetch.prune true

.PHONY: deno
deno:
	@curl -fsSL https://deno.land/x/install/install.sh | sh

.PHONY: rust
rust:
	@curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

.PHONY: rye
rye:
	@curl -sSf https://rye-up.com/get | RYE_INSTALL_OPTION="--yes" bash

.PHONY: debian
debian: init
	@bash script/debian.sh