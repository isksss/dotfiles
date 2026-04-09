-----------------------------------------------------------
-- フォーマット設定
-----------------------------------------------------------
local conform = require("conform")

conform.setup({
    formatters_by_ft = {
        go = { "gofmt" },
        rust = { "rustfmt" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        java = { "google-java-format" },
    },
    format_on_save = {
        timeout_ms = 1000,
        lsp_format = "fallback",
    },
})

vim.keymap.set("n", "<leader>f", function()
    conform.format({
        async = false,
        lsp_format = "fallback",
    })
end, { desc = "現在のバッファを整形" })
