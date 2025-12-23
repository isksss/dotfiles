-----------------------------------------------------------
-- lazy.nvim bootstrap
-----------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

-----------------------------------------------------------
-- lazy.nvim setup
-----------------------------------------------------------
require("lazy").setup({
    {
        "lambdalisue/vim-fern",
        cmd = { "Fern" },
        dependencies = {
            "lambdalisue/fern-renderer-devicons.vim",
            "lambdalisue/nerdfont.vim",
        },
        config = function()
            require("config.file_explorer")
        end,
    },
})
