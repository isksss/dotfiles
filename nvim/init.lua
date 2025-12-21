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
        "vim-denops/denops.vim",
        lazy = false, -- denops は常駐前提
    },
}, {
    checker = {
        enabled = true,
    },
})

-----------------------------------------------------------
-- denops 設定（最小）
-- PATH 問題がある場合のみ指定
-----------------------------------------------------------
-- vim.g.denops_deno = "deno"

-----------------------------------------------------------
-- 起動時に denops を warmup（安定化のため）
-----------------------------------------------------------
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        pcall(vim.cmd, "DenopsRestart")
    end,
})
