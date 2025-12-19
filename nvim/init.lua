-----------------------------------------------------------
-- lazy.nvim bootstrap
-----------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({"git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
                   lazypath})
end

vim.opt.rtp:prepend(lazypath)

-----------------------------------------------------------
-- lazy.nvim setup
-----------------------------------------------------------
require("lazy").setup({{
    "vim-denops/denops.vim",
    lazy = false
}}, {
    checker = {
        enabled = true
    }
})

-----------------------------------------------------------
-- denops 設定（最小）
-----------------------------------------------------------
-- 通常は不要だが、PATH 問題がある場合に指定
-- vim.g.denops_deno = "deno"

-----------------------------------------------------------
-- 起動時に denops を warmup（任意だが安定する）
-----------------------------------------------------------
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        vim.cmd("silent! DenopsRestart")
    end
})
