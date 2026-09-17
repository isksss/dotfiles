local M = {}
local project = require("config.project")

function M.get()
    local capabilities = require("blink.cmp").get_lsp_capabilities()
    local function web_root(runtime)
        return function(bufnr, on_dir)
            local kind, root = project.runtime(bufnr)
            if kind == runtime then
                on_dir(root)
            end
        end
    end
    return {
        gopls = {
            capabilities = capabilities,
            settings = { gopls = { gofumpt = true, staticcheck = true } },
        },
        rust_analyzer = {
            capabilities = capabilities,
            settings = { ["rust-analyzer"] = { check = { command = "clippy" } } },
        },
        vtsls = {
            capabilities = capabilities,
            root_dir = web_root("node"),
            filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
            settings = {
                vtsls = {
                    autoUseWorkspaceTsdk = true,
                    tsserver = {
                        globalPlugins = {
                            {
                                name = "@vue/typescript-plugin",
                                location = vim.fn.stdpath("data")
                                    .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
                                languages = { "vue" },
                                configNamespace = "typescript",
                                enableForWorkspaceTypeScriptVersions = true,
                            },
                        },
                    },
                },
            },
        },
        vue_ls = { capabilities = capabilities },
        denols = {
            capabilities = capabilities,
            root_dir = web_root("deno"),
            workspace_required = true,
            init_options = { lint = true },
        },
        bashls = {
            capabilities = capabilities,
            settings = { bashIde = { shellcheckPath = "shellcheck", shfmt = { path = "shfmt" } } },
        },
    }
end

return M
