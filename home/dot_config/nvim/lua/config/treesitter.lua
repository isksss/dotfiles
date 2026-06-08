-----------------------------------------------------------
-- Treesitter 設定
-----------------------------------------------------------
local M = {}

function M.setup()
    require("nvim-treesitter.configs").setup({
        ensure_installed = {
            "bash",
            "css",
            "html",
            "java",
            "javascript",
            "json",
            "jsonc",
            "lua",
            "markdown",
            "markdown_inline",
            "scss",
            "sql",
            "toml",
            "tsx",
            "typescript",
            "vue",
            "xml",
            "yaml",
        },
        auto_install = true,
        highlight = {
            enable = true,
        },
        indent = {
            enable = true,
        },
    })
end

return M
