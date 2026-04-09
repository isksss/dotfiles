-----------------------------------------------------------
-- ファイラー設定 (vim-fern)
-----------------------------------------------------------
local g = vim.g
local keymap = vim.keymap.set

-- 隠しファイルを表示し、アイコンレンダラーを有効化
g["fern#default_hidden"] = 1
g["fern#renderer"] = "devicons"
g["fern#disable_default_mappings"] = 1

-- Fern バッファのローカル設定
local fern_group = vim.api.nvim_create_augroup("FernSettings", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = fern_group,
    pattern = "fern",
    callback = function()
        local opts = { buffer = true, silent = true, nowait = true }

        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = "no"
        vim.opt_local.list = false
        vim.opt_local.cursorline = true
        vim.opt_local.wrap = false

        keymap("n", "<CR>", "<Plug>(fern-action-open:edit)", opts)
        keymap("n", "l", "<Plug>(fern-action-open:edit)", opts)
        keymap("n", "h", "<Plug>(fern-action-leave)", opts)
        keymap("n", "o", "<Plug>(fern-action-open:edit)", opts)
        keymap("n", "s", "<Plug>(fern-action-open:split)", opts)
        keymap("n", "v", "<Plug>(fern-action-open:vsplit)", opts)
        keymap("n", "t", "<Plug>(fern-action-open:tabedit)", opts)
        keymap("n", "r", "<Plug>(fern-action-rename)", opts)
        keymap("n", "m", "<Plug>(fern-action-move)", opts)
        keymap("n", "N", "<Plug>(fern-action-new-path)", opts)
        keymap("n", "D", "<Plug>(fern-action-remove)", opts)
        keymap("n", "R", "<Plug>(fern-action-reload)", opts)
        keymap("n", ".", "<Plug>(fern-action-hidden:toggle)", opts)
        keymap("n", "yy", "<Plug>(fern-action-yank:path)", opts)
        keymap("n", "p", "<Plug>(fern-action-paste)", opts)
        keymap("n", "q", "<cmd>close<CR>", opts)
    end,
})
