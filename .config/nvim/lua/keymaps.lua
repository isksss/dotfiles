local maps = vim.keymap

-- Leader key
vim.g.mapleader = " "


-- maps.set(mode, keymap, action)
-- Normal mode
maps.set("n", "<leader>w", ":w<CR>")
maps.set("n", "<leader>q", ":q<CR>")
-- open terminal
maps.set("n", "<leader>t", ":split | terminal<CR>")

-- terminal mode
maps.set("t", "<Esc>", "<C-\\><C-n>")
