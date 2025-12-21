-----------------------------------------------------------
-- 基本オプション（使いやすさ重視）
-----------------------------------------------------------
local opt = vim.opt

-- 行番号
opt.number = true
opt.relativenumber = true

-- 表示
opt.termguicolors = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8

-- インデント
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.smartindent = true
opt.autoindent = true

-- 検索
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

-- 編集体験
opt.backspace = { "indent", "eol", "start" }
opt.clipboard = "unnamedplus"
opt.confirm = true
opt.mouse = "a"

-- 分割
opt.splitbelow = true
opt.splitright = true

-- ファイル関連
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undo"

-- パフォーマンス
opt.updatetime = 300
opt.timeoutlen = 500
opt.redrawtime = 1500

-- コマンドライン
opt.cmdheight = 1
opt.showmode = false
opt.laststatus = 3

-- 補完
opt.completeopt = { "menu", "menuone", "noselect" }
opt.pumheight = 10

-- 不可視文字（必要に応じて）
opt.list = true
opt.listchars = {
    tab = "» ",
    trail = "·",
    nbsp = "␣",
}
