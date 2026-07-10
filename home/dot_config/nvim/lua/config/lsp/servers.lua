-----------------------------------------------------------
-- LSP server definitions
-----------------------------------------------------------
local M = {}

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

function M.get()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    local web_root_markers = {
        { "nuxt.config.js", "nuxt.config.mjs", "nuxt.config.ts", "nuxt.config.cjs", "package.json", "tsconfig.json", "jsconfig.json" },
        { ".git" },
    }
    local java_root_markers = {
        { "gradlew", "mvnw", "settings.gradle", "settings.gradle.kts", "build.gradle", "build.gradle.kts", "pom.xml" },
        { ".git" },
    }
    local python_root_markers = {
        { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json" },
        { ".git" },
    }
    local shell_root_markers = { { ".shellcheckrc", ".editorconfig" }, { ".git" } }
    local vue_language_server_path = vim.fn.stdpath("data")
        .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

    return {
        gopls = {
            capabilities = capabilities,
            settings = { gopls = { gofumpt = true, staticcheck = true } },
        },
        rust_analyzer = {
            capabilities = capabilities,
            settings = {
                ["rust-analyzer"] = {
                    cargo = { allFeatures = true },
                    check = { command = "clippy" },
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
            filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
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
        basedpyright = {
            capabilities = capabilities,
            root_dir = root_dir(python_root_markers),
            settings = {
                basedpyright = {
                    analysis = { autoSearchPaths = true, diagnosticMode = "workspace" },
                },
            },
        },
        bashls = {
            capabilities = capabilities,
            root_dir = root_dir(shell_root_markers),
            settings = {
                bashIde = {
                    shellcheckPath = "shellcheck",
                    shfmt = { path = "shfmt" },
                },
            },
        },
    }
end

return M
