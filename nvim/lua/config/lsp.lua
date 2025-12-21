-- 共通 on_attach
local on_attach = function(_, bufnr)
    local map = function(mode, lhs, rhs)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr })
    end

    map("n", "gd", vim.lsp.buf.definition)
    map("n", "gr", vim.lsp.buf.references)
    map("n", "gi", vim.lsp.buf.implementation)
    map("n", "K", vim.lsp.buf.hover)
    map("n", "<leader>rn", vim.lsp.buf.rename)
    map("n", "<leader>ca", vim.lsp.buf.code_action)
    map("n", "[d", vim.diagnostic.goto_prev)
    map("n", "]d", vim.diagnostic.goto_next)
end

-- capabilities（補完連携用、ddc / cmp どちらでも拡張可）
local capabilities = vim.lsp.protocol.make_client_capabilities()
if vim.fn.exists("*ddc#lsp#make_client_capabilities") == 1 then
    capabilities = vim.fn["ddc#lsp#make_client_capabilities"](capabilities)
end

local function setup(server, config)
    if vim.lsp.config then
        vim.lsp.config(server, config)
        vim.lsp.enable(server)
        return
    end

    local lspconfig = require("lspconfig")
    lspconfig[server].setup(config)
end

-- Lua
setup("lua_ls", {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                checkThirdParty = false,
            },
            telemetry = {
                enable = false,
            },
        },
    },
})

-- TypeScript / JavaScript
setup("ts_ls", {
    on_attach = on_attach,
    capabilities = capabilities,
})

-- JSON
setup("jsonls", {
    on_attach = on_attach,
    capabilities = capabilities,
})

-- YAML
setup("yamlls", {
    on_attach = on_attach,
    capabilities = capabilities,
})

-- Bash
setup("bashls", {
    on_attach = on_attach,
    capabilities = capabilities,
})

-----------------------------------------------------------
-- Go (gopls)
-----------------------------------------------------------
setup("gopls", {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        gopls = {
            gofumpt = true,
            analyses = {
                unusedparams = true,
                shadow = true,
            },
            staticcheck = true,
        },
    },
})
