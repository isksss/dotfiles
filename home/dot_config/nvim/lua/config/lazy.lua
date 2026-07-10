-----------------------------------------------------------
-- lazy.nvim bootstrap
-----------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })

    if vim.v.shell_error ~= 0 then
        error("Failed to clone lazy.nvim into " .. lazypath)
    end
end

vim.opt.runtimepath:prepend(lazypath)

-----------------------------------------------------------
-- lazy.nvim setup
-----------------------------------------------------------
require("lazy").setup({
    { import = "plugins" },
}, {
    change_detection = {
        notify = false,
    },
    checker = {
        enabled = false,
    },
    rocks = {
        enabled = false,
    },
})
