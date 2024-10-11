-- ############################################################
-- 基本設定
-- ############################################################
vim.o.number = true
-- vim.o.relativenumber = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.cursorline = true
vim.o.clipboard = "unnamedplus"
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true
vim.o.hlsearch = true
vim.o.history = 1000
vim.o.confirm = true

-- ############################################################
-- キーバインド
-- ############################################################

local keymap = vim.api.nvim_set_keymap
local opts = {
    noremap = true,
    silent = true
}
vim.g.mapleader = ' '
-- ==============================
-- normal
-- ==============================
keymap('n', '<Leader>w', ':w<CR>', opts)
keymap('n', '<Leader>q', ':q<CR>', opts)

-- ==============================
-- insert
-- ==============================
keymap('i', 'jj', '<Esc>', opts)

-- ==============================
-- visual
-- ==============================

-- インデントを増減
keymap('v', '<', '<gv', opts)
keymap('v', '>', '>gv', opts)

-- ############################################################
-- プラグイン
-- ############################################################

-- ==============================
-- plugin manager install
-- ==============================

-- lazy.nvim: https://lazy.folke.io/
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({"git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath})
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({{"Failed to clone lazy.nvim:\n", "ErrorMsg"}, {out, "WarningMsg"},
                           {"\nPress any key to exit..."}}, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- ==============================
-- setup
-- ==============================
require("lazy").setup({
    'nvim-lualine/lualine.nvim',
    dependencies = {'nvim-tree/nvim-web-devicons'}
}, {
    'romgrk/barbar.nvim',
    dependencies = {'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
    'nvim-tree/nvim-web-devicons' -- OPTIONAL: for file icons
    },
    init = function()
        vim.g.barbar_auto_setup = false
    end,
    opts = {},
    version = '^1.0.0' -- optional: only update when a new 1.x version is released
})
