local opt = vim.opt
local o = vim.o
local g = vim.g
local wo = vim.wo

-- ##### options #####

o.number = true -- 行番号
o.ambiwidth = 'double'

-- indent
o.expandtab = true
o.shiftwidth = 4
o.smartindent = true
o.tabstop = 4
o.softtabstop = 4

-- search
o.ignorecase = true
o.smartcase = true
o.showmatch = true
o.incsearch = true
o.hlsearch = true

-- encoding
o.encoding = 'utf-8'
vim.scriptencoding = 'utf-8'


