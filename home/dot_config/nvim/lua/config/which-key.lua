-----------------------------------------------------------
-- which-key.nvim 設定
-----------------------------------------------------------
local M = {}

function M.setup()
    require("which-key").setup({
        preset = "modern",
        delay = 300,
    })
end

return M
