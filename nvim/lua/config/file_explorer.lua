-----------------------------------------------------------
-- ファイラー設定 (vim-fern)
-----------------------------------------------------------
local g = vim.g

-- 隠しファイルを表示し、アイコンレンダラーを有効化
g["fern#default_hidden"] = 1
g["fern#renderer"] = "devicons"

-- Fern バッファのローカル設定
local fern_group = vim.api.nvim_create_augroup("FernSettings", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = fern_group,
    pattern = "fern",
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
    end,
})
