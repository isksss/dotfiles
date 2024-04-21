-- keymap

local map = vim.keymap.set

local opt={noremap = true, silent = true}

-- leader
vim.g.mapleader = " "

-- jj
map("i", "jj", "<Esc>", opt)
map("n", "<Leader>s", ":w<CR>", opt)
map("n", "<Leader>q", ":q<CR>", opt)

-- insert hjkl
map("i", "<C-h>", "g<Left>", opt)
map("i", "<C-j>", "g<Down>", opt)
map("i", "<C-k>", "g<Up>", opt)
map("i", "<C-l>", "g<Right>", opt)

-- idou
map("n", "j", "gj", opt)
map("n", "k", "gk", opt)
