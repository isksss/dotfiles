-----------------------------------------------------------
-- LSP setup entrypoint
-----------------------------------------------------------
local mason_lspconfig = require("mason-lspconfig")

require("config.lsp.attach").setup()

mason_lspconfig.setup({
    ensure_installed = {
        "gopls",
        "rust_analyzer",
        "ts_ls",
        "vue_ls",
        "jdtls",
        "basedpyright",
        "bashls",
    },
    automatic_enable = false,
})

for server, config in pairs(require("config.lsp.servers").get()) do
    vim.lsp.config(server, config)
    vim.lsp.enable(server)
end
