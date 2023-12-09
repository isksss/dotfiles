XDG_CONFIG_HOME ?= $(HOME)/.config
XDG_CACHE_HOME ?= $(HOME)/.cache
XDG_DATA_HOME ?= $(HOME)/.local/share

WORKSPACE ?= $(HOME)/workspace

DOCKER_IMAGE ?= workspace:latest

.PHONY: help
help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  all     Setup all"
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
	@mkdir -p $(WORKSPACE)

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

	@ln -sf $(PWD)/.config/wezterm $(XDG_CONFIG_HOME)/wezterm

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

.PHONY: docker
docker:
	@docker build --build-arg USER_NAME=$(shell whoami) --build-arg USER_ID=$(shell id -u) -t $(DOCKER_IMAGE) -f docker/Dockerfile . 

.PHONY: arch-install
arch-install: init git link
	@sudo pacman -Syu --noconfirm git zsh unzip

.PHONY: ubuntu-install
ubuntu-install: init git link
	@sudo apt update
	@sudo apt install -y git zsh unzip
	@sudo pacman -Syu --noconfirm git zsh unzip starship

.PHONY: mac-install
	@brew install --cask wezterm
	@brew install orbstack

.PHONY: cargo-install
cargo-install:
	@cargo install starship

