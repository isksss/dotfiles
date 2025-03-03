-- init.lua
-- 全てこのファイルで管理する
-- ============================================================
-- オプション
vim.opt.number = true
-- vim.opt.relativenumber = true
vim.opt.clipboard:append({"unnamedplus"})

-- ============================================================
-- キーマップ
local map = vim.api.nvim_set_keymap
local opts = {
    noremap = true,
    silent = true
}

-- リーダーキーをスペースに設定
vim.g.mapleader = ' '

-- 保存
map('n', '<Leader>w', ':w<CR>', opts)

-- 終了
map('n', '<Leader>q', ':q<CR>', opts)

-- jj
map('i', 'jj', '<Esc>', opts)

map('n', '<Leader><Esc>', ':nohlsearch<CR>', opts)
-- buffer操作
-- bufferを移動する
map('n', '<A-,>', ':BufferPrevious<CR>', opts)
map('n', '<A-.>', ':BufferNext<CR>', opts)
-- バッファーを左右に移動させる
map('n', '<A-<>', ':BufferMovePrevious<CR>', opts)
map('n', '<A->>', ':BufferMoveNext<CR>', opts)
-- bufferを閉じる
map('n', '<A-c>', ':BufferClose<CR>', opts)

-- ============================================================
-- プラグイン管理
-- lazyをインストール
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system(
        {"git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", -- latest stable release
         lazypath})
end
vim.opt.rtp:prepend(lazypath)

-- todo: 補完系
-- todo: ui系
require("lazy").setup({{
    "vim-denops/denops.vim",
    config = function()
        vim.g["denops#deno"] = vim.fn.exepath('deno')
    end
}, -- ファイラー
{
    "lambdalisue/fern.vim",
    config = function()
    end,
    keys = {{
        "<Leader>e",
        "<Cmd>Fern . -reveal=% -drawer -toggle -width=25<CR>",
        desc = "Toggle"
    }}
}, -- タブ
{
    'romgrk/barbar.nvim',
    dependencies = {'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
    'nvim-tree/nvim-web-devicons' -- OPTIONAL: for file icons
    },
    init = function()
        vim.g.barbar_auto_setup = false
    end,
    opts = {},
    version = '^1.0.0' -- optional: only update when a new 1.x version is released
}, -- ステータスバー
{
    'nvim-lualine/lualine.nvim',
    dependencies = {'nvim-tree/nvim-web-devicons'},
    config = function()
        require('lualine').setup {
            options = {
                icons_enabled = true,
                theme = 'auto',
                component_separators = {
                    left = '',
                    right = ''
                },
                section_separators = {
                    left = '',
                    right = ''
                },
                disabled_filetypes = {
                    statusline = {},
                    winbar = {}
                },
                ignore_focus = {},
                always_divide_middle = true,
                globalstatus = false,
                refresh = {
                    statusline = 1000,
                    tabline = 1000,
                    winbar = 1000
                }
            },
            sections = {
                lualine_a = {'mode'},
                lualine_b = {'branch', 'diff', 'diagnostics'},
                lualine_c = {'filename'},
                lualine_x = {'encoding', 'fileformat', 'filetype'},
                lualine_y = {'progress'},
                lualine_z = {'location'}
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {'filename'},
                lualine_x = {'location'},
                lualine_y = {},
                lualine_z = {}
            },
            tabline = {},
            winbar = {},
            inactive_winbar = {},
            extensions = {}
        }
    end
}})

