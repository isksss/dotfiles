-----------------------------------------------------------
-- which-key.nvim 設定
-----------------------------------------------------------
local M = {}

function M.setup()
    local wk = require("which-key")

    wk.setup({
        preset = "modern",
        delay = 300,
    })

    wk.add({
        { "<leader>l", group = "LSP/診断" },
        { "<leader>la", desc = "コードアクション" },
        { "<leader>ld", desc = "診断を表示" },
        { "<leader>lf", desc = "整形" },
        { "<leader>ll", desc = "lint" },
        { "<leader>lq", desc = "診断を quickfix に送る" },
        { "<leader>lr", desc = "リネーム" },
    })
end

return M
