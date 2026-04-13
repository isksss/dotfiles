-----------------------------------------------------------
-- fzf-lua 設定
-----------------------------------------------------------
local M = {}

function M.setup()
    require("fzf-lua").setup({
        keymap = {
            builtin = {
                ["<M-Esc>"] = false,
                ["<M-S-down>"] = false,
                ["<M-S-up>"] = false,
                ["<C-c>"] = "hide",
                ["<C-j>"] = "preview-down",
                ["<C-k>"] = "preview-up",
            },
            fzf = {
                ["alt-a"] = false,
                ["alt-g"] = false,
                ["alt-G"] = false,
                ["alt-shift-down"] = false,
                ["alt-shift-up"] = false,
                ["ctrl-q"] = "toggle-all",
                ["ctrl-j"] = "preview-down",
                ["ctrl-k"] = "preview-up",
            },
        },
        actions = {
            files = {
                ["alt-q"] = false,
                ["alt-Q"] = false,
                ["alt-i"] = false,
                ["alt-h"] = false,
                ["alt-f"] = false,
                ["ctrl-q"] = require("fzf-lua.actions").file_sel_to_qf,
            },
        },
        files = {
            fd_opts =
                "--type f --hidden --follow --exclude .git --exclude node_modules --exclude dist --exclude build --exclude target --exclude coverage --color never",
        },
        grep = {
            rg_opts =
                "--column --line-number --no-heading --color=never --smart-case --hidden --glob '!.git'",
        },
        winopts = {
            height = 0.85,
            width = 0.8,
        },
    })
end

return M
