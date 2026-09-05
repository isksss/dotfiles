require("config.lsp.attach").setup()

require("mason-lspconfig").setup({
    ensure_installed = { "gopls", "rust_analyzer", "vtsls", "vue_ls", "bashls" },
    automatic_enable = false,
})

for server, config in pairs(require("config.lsp.servers").get()) do
    vim.lsp.config(server, config)
    vim.lsp.enable(server)
end
