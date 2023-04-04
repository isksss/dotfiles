-- init.lua
-- nvim configuration file
-- Plugins
require('plugins')

-- Settings
require('settings')

-- Keybindings
require('keybindings')


-- plugins.luaが保存された時に自動でコンパイルする
vim.cmd('autocmd BufWritePost plugins.lua PackerCompile')

-- todo: dazy.nvimに置き換える

