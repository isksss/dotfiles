local opt = vim.opt
local o = vim.o
local g = vim.g
local wo = vim.wo

-- ##### options #####

o.number = true -- 行番号
o.ambiwidth = 'double'
o.laststatus = 3 -- statusline

-- indent
o.expandtab = true
o.shiftwidth = 4
o.smartindent = true
o.tabstop = 4
o.softtabstop = 4

-- search
opt.ignorecase = true
opt.smartcase = true
opt.showmatch = true
opt.incsearch = true
opt.hlsearch = true

-- encoding
opt.encoding = 'utf-8'
vim.scriptencoding = 'utf-8'
opt.fileencoding = 'utf-8'

-- 24bit
opt.termguicolors = true

-- backup
opt.backup = false
opt.swapfile = false

-- 不可視文字可視化
opt.list = true
opt.listchars = { tab = '>>', trail = '-', nbsp = '+' }
