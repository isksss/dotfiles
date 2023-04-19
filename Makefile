XDG_CONFIG_HOME ?= $(HOME)/.config

.PHONY: all
install: symlink dellink

.PHONY: symlink
symlink:
	ln -sf $(CURDIR)/config/zsh $(XDG_CONFIG_HOME)/zsh
	ln -sf $(CURDIR)/config/zsh/.zshenv $(HOME)/.zshenv

	ln -sf $(CURDIR)/config/nvim $(XDG_CONFIG_HOME)/nvim
	ln -sf $(CURDIR)/config/git $(XDG_CONFIG_HOME)/git
	ln -sf $(CURDIR)/config/tmux $(XDG_CONFIG_HOME)/tmux

	ln -sf $(CURDIR)/config/alacritty $(XDG_CONFIG_HOME)/alacritty

.PHONY: dellink
dellink:
	chmod +x $(CURDIR)/script/dellink.sh
	$(CURDIR)/script/dellink.sh $(CURDIR)
