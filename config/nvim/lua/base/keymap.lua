-- leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- opt

-- keymap
local keymap = vim.keymap
keymap.set('n', '<Leader>w', '<CMD>w<CR>', {noremap = true})
keymap.set('n', '<Leader>q', '<CMD>q<CR>', {noremap = true})

-- idou
keymap.set('n', 'j', 'gj', {noremap = true})
keymap.set('n', 'k', 'gk', {noremap = true})
keymap.set('n', 'gj', 'j', {noremap = true})
keymap.set('n', 'gk', 'k', {noremap = true})
