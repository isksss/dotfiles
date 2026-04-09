-- LSP 設定
-----------------------------------------------------------
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local mason_lspconfig = require("mason-lspconfig")
local vue_language_server_path = vim.fn.expand("$MASON/packages/vue-language-server/node_modules/@vue/language-server")

local lsp_group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
    group = lsp_group,
    callback = function(event)
        local bufnr = event.buf
        local keymap = vim.keymap.set
        local opts = { buffer = bufnr, silent = true }
        local ok_fzf, fzf = pcall(require, "fzf-lua")
        local function picker(name, fallback)
            if ok_fzf then
                return function()
                    fzf[name]()
                end
            end
            return fallback
        end

        keymap("n", "gd", picker("lsp_definitions", vim.lsp.buf.definition), opts)
        keymap("n", "gr", picker("lsp_references", vim.lsp.buf.references), opts)
        keymap("n", "gD", vim.lsp.buf.declaration, opts)
        keymap("n", "gi", picker("lsp_implementations", vim.lsp.buf.implementation), opts)
        keymap("n", "gy", picker("lsp_typedefs", vim.lsp.buf.type_definition), opts)
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
        "ts_ls",
        "vue_ls",
        "jdtls",
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
    ts_ls = {
        capabilities = capabilities,
        init_options = {
            plugins = {
                {
                    name = "@vue/typescript-plugin",
                    location = vue_language_server_path,
                    languages = { "javascript", "typescript", "vue" },
                },
            },
        },
        filetypes = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "vue",
        },
    },
    vue_ls = {
        capabilities = capabilities,
    },
    jdtls = {
        capabilities = capabilities,
    },
}

for server, config in pairs(servers) do
    vim.lsp.config(server, config)
    vim.lsp.enable(server)
end
