XDG_CONFIG_HOME ?= $(HOME)/.config
BIN_DIR := $(HOME)/.local/bin
OS := $(shell uname -s)
code_dir := "$(HOME)/Library/Application Support/Code/User"

.PHONY: install
install:
	@chmod +x $(CURDIR)/install.sh
	@$(CURDIR)/install.sh
	@$(MAKE) symlink
	@$(MAKE) dellink

.PHONY: symlink
symlink:
	@ln -sf $(CURDIR)/config/zsh $(XDG_CONFIG_HOME)/zsh
	@ln -sf $(CURDIR)/config/zsh/.zshenv $(HOME)/.zshenv

	@ln -sf $(CURDIR)/config/nvim $(XDG_CONFIG_HOME)/nvim
	@ln -sf $(CURDIR)/config/git $(XDG_CONFIG_HOME)/git
	@ln -sf $(CURDIR)/config/tmux $(XDG_CONFIG_HOME)/tmux

	@ln -sf $(CURDIR)/config/alacritty $(XDG_CONFIG_HOME)/alacritty

	@ln -sf $(CURDIR)/bin $(BIN_DIR)

	@test "$(OS)" = "Darwin" && ln -sf $(CURDIR)/config/Code/User/settings.json $(code_dir)/settings.json || echo "Not macOS"
	@test "$(OS)" = "Darwin" && ln -sf $(CURDIR)/config/Code/User/keybindings.json $(code_dir)/keybindings.json || echo "Not macOS"

	@test "$(OS)" = "Linux" && ln -sf $(CURDIR)/config/Code/User/settings.json $(XDG_CONFIG_HOME)/Code/User/settings.json || echo "Not Linux"
	@test "$(OS)" = "Linux" && ln -sf $(CURDIR)/config/Code/User/keybindings.json $(XDG_CONFIG_HOME)/Code/User/keybindings.json || echo "Not Linux"

.PHONY: dellink
dellink:
	@chmod +x $(CURDIR)/script/dellink.sh
	@$(CURDIR)/script/dellink.sh $(CURDIR)

.PHONY: brewsetup
brewsetup:
	@brew bundle --file=$(CURDIR)/Brewfile

.PHONY: brewdump
brewdump:
	@brew bundle dump --force --file=$(CURDIR)/Brewfile

.PHONY: brewinstall
brewinstall:
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

.PHONY: arch
arch:
	@chmod +x $(CURDIR)/script/arch.sh
	@$(CURDIR)/script/arch.sh