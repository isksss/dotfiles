-----------------------------------------------------------
-- LSP 設定 (Go / Rust)
-----------------------------------------------------------
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local mason_lspconfig = require("mason-lspconfig")

local lsp_group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
    group = lsp_group,
    callback = function(event)
        local bufnr = event.buf
        local keymap = vim.keymap.set
        local opts = { buffer = bufnr, silent = true }

        keymap("n", "gd", vim.lsp.buf.definition, opts)
        keymap("n", "gr", vim.lsp.buf.references, opts)
        keymap("n", "K", vim.lsp.buf.hover, opts)
        keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
        keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        keymap("n", "[d", vim.diagnostic.goto_prev, opts)
        keymap("n", "]d", vim.diagnostic.goto_next, opts)
    end,
})

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

mason_lspconfig.setup({
    ensure_installed = {
        "gopls",
        "rust_analyzer",
    },
    automatic_enable = false,
})

local servers = {
    gopls = {
        capabilities = capabilities,
    },
    rust_analyzer = {
        capabilities = capabilities,
        settings = {
            ["rust-analyzer"] = {
                cargo = {
                    allFeatures = true,
                },
                check = {
                    command = "clippy",
                },
            },
        },
    },
}

for server, config in pairs(servers) do
    vim.lsp.config(server, config)
    vim.lsp.enable(server)
end
