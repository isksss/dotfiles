-- 設定させていただきありがとうございます

-- ##### ##### #####
-- option
-- ##### ##### #####

local opt = vim.opt

-- 文字コード
vim.scriptencoding = "utf-8"
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
-- マルチバイト文字
opt.ambiwidth = "double"
-- 行番号の表示
opt.number = true
-- タブ, インデントの設定
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
-- 検索関係
opt.ignorecase = true
opt.smartcase = true

-- ##### ##### #####
-- keymap
-- ##### ##### #####

local keymap = vim.keymap
vim.g.mapleader = " "

-- ##### ##### #####
-- plugin
-- ##### ##### #####
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system(
        {
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable", -- latest stable release
            lazypath
        }
    )
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(
    {
        -- ステータスバー
        {
            "nvim-lualine/lualine.nvim",
            dependencies = {"nvim-tree/nvim-web-devicons"},
            config = function ()
                require("lualine").setup({
                    options = { theme = 'gruvbox'},
                })                
            end,
        },
    }
)


