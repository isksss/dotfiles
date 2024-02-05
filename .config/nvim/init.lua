-- init.lua
-- ##################################################
-- ## options
-- ##################################################

-- encoding
vim.opt.encoding = 'utf-8'
vim.opt.fileencodings = 'utf-8'

-- clipboard
vim.opt.clipboard = 'unnamedplus'

-- number
vim.opt.number = true

-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true

-- tab
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- status
vim.opt.laststatus = 3

-- ##################################################
-- ## keymap
-- ##################################################
local keyopt = { noremap = true, silent = true }
-- leader
vim.g.mapleader = ' '

-- escape in insert mode
vim.keymap.set('i', 'jj', '<ESC>', keyopt)

-- hjkl in insert mode
-- Ctrl + h,j,k,l
vim.keymap.set('i', '<C-h>', '<Left>', keyopt)
vim.keymap.set('i', '<C-j>', '<Down>', keyopt)
vim.keymap.set('i', '<C-k>', '<Up>', keyopt)
vim.keymap.set('i', '<C-l>', '<Right>', keyopt)

-- hjkl in normal mode
-- 表示行単位で移動
vim.keymap.set('n', 'j', 'gj', keyopt)
vim.keymap.set('n', 'k', 'gk', keyopt)

-- save and quit
vim.keymap.set('n', '<leader>w', ':w<CR>', keyopt)
vim.keymap.set('n', '<leader>q', ':q<CR>', keyopt)

-- ##################################################
-- ## plugin
-- ##################################################

-- lazy.nvim install
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- plugins
require("lazy").setup({
    -- ====================
    -- statusline
    -- ====================
    {
        'nvim-lualine/lualine.nvim',
        dependencies = {
          'nvim-tree/nvim-web-devicons',
        },
        config = function()
            require('lualine').setup({
                options = {
                theme = 'tokyonight',
                section_separators = '',
                component_separators = '',
                },
                sections = {
                lualine_a = { 'mode' },
                lualine_b = { 'branch' },
                lualine_c = { 'filename' },
                lualine_x = { 'encoding', 'fileformat', 'filetype' },
                lualine_y = { 'progress' },
                lualine_z = { 'location' },
                },
            })
        end,
      },
})