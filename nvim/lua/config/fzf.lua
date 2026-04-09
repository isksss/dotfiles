-----------------------------------------------------------
-- fzf-lua 設定
-----------------------------------------------------------
local fzf = require("fzf-lua")

fzf.setup({
    "default",
    winopts = {
        height = 0.85,
        width = 0.80,
        preview = {
            vertical = "down:45%",
        },
    },
    files = {
        cwd_prompt = false,
    },
    grep = {
        cwd_prompt = false,
    },
})
