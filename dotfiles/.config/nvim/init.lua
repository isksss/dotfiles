vim.g.mapleader = " "
vim.g.maplocalleader = ","

require("config.options")
local ok, _ = pcall(require, "local.clipboard")
require("config.ime")
require("config.autocmds")
require("config.keymaps")
require("config.markdown_preview").setup()
require("config.lazy")
