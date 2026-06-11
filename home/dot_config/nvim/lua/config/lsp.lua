-- LSP 設定
-----------------------------------------------------------
local mason_lspconfig = require("mason-lspconfig")
local vue_language_server_path = vim.fn.stdpath("data")
    .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem.snippetSupport = true

local lsp_group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true })

local web_root_markers = {
    {
        "nuxt.config.js",
        "nuxt.config.mjs",
        "nuxt.config.ts",
        "nuxt.config.cjs",
        "package.json",
        "tsconfig.json",
        "jsconfig.json",
    },
    { ".git" },
}

local java_root_markers = {
    {
        "gradlew",
        "mvnw",
        "settings.gradle",
        "settings.gradle.kts",
        "build.gradle",
        "build.gradle.kts",
        "pom.xml",
    },
    { ".git" },
}

local function root_dir(markers)
    return function(bufnr, on_dir)
        local root = vim.fs.root(bufnr, markers)
        if root then
            on_dir(root)
        end
    end
end

local function jdtls_cmd(dispatchers, config)
    local data_dir = vim.fn.stdpath("cache") .. "/jdtls-workspace"
    if config.root_dir then
        data_dir = data_dir .. "/" .. vim.fn.fnamemodify(config.root_dir, ":p:h:t")
    end

    return vim.lsp.rpc.start({ "jdtls", "-data", data_dir }, dispatchers, {
        cwd = config.cmd_cwd,
        env = config.cmd_env,
        detached = config.detached,
    })
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = lsp_group,
    callback = function(event)
        local bufnr = event.buf
        local keymap = vim.keymap.set
        local opts = { buffer = bufnr, silent = true }

        keymap("n", "gd", vim.lsp.buf.definition, opts)
        keymap("n", "gr", vim.lsp.buf.references, opts)
        keymap("n", "gD", vim.lsp.buf.declaration, opts)
        keymap("n", "gi", vim.lsp.buf.implementation, opts)
        keymap("n", "gy", vim.lsp.buf.type_definition, opts)
        keymap("n", "K", vim.lsp.buf.hover, opts)
        keymap("n", "<leader>lr", vim.lsp.buf.rename, opts)
        keymap("n", "<leader>la", vim.lsp.buf.code_action, opts)
        keymap("n", "[d", vim.diagnostic.goto_prev, opts)
        keymap("n", "]d", vim.diagnostic.goto_next, opts)
        keymap("n", "<leader>ld", vim.diagnostic.open_float, opts)
        keymap("n", "<leader>lq", vim.diagnostic.setqflist, opts)
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
        root_dir = root_dir(web_root_markers),
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
        root_dir = root_dir(web_root_markers),
    },
    jdtls = {
        capabilities = capabilities,
        cmd = jdtls_cmd,
        root_dir = root_dir(java_root_markers),
    },
}

for server, config in pairs(servers) do
    vim.lsp.config(server, config)
    vim.lsp.enable(server)
end
