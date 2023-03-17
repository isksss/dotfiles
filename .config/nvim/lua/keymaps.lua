local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

local keymap = vim.api.nvim_set_keymap
keymap("", "<Space>", "<Nop>", opts)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = 'n',
--   insert_mode = 'i',
--   visual_mode = 'v',
--   visual_block_mode = 'x',
--   term_mode = 't',
--   command_mode = 'c',
keymap('i','<C-k>','<Up>', opts)
keymap('i','<C-j>','<Down>', opts)

keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

keymap("i", ",", ",<Space>", opts)

keymap("n", "x", '"_x', opts)

-- Tab
keymap("n", "<Leader>n", ":tabnew<Return>", opts)

-- Split window
keymap("n", "ss", ":split<Return><C-w>w", opts)
keymap("n", "sv", ":vsplit<Return><C-w>w", opts)

keymap("n", "<S-h>", "gT", opts)
keymap("n", "<S-l>", "gt", opts)

-- 行の端に行く
keymap("n", "<Space>h", "^", opts)
keymap("n", "<Space>l", "$", opts)

-- terminal
keymap("t", "<ESC>", "<C-\\><C-n>", term_opts)
keymap("n", "<Leader>@","<cmd>belowright new<CR><cmd>terminal<CR>", opts)

