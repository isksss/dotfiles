require "base"
require "plugins"
require "keymaps"

vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = { "plugins.lua" },
    command = "PackerCompile",
})