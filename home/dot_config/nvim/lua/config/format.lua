-----------------------------------------------------------
-- フォーマット設定
-----------------------------------------------------------
local conform = require("conform")
local project = require("config.project")

local web_filetypes = {
    javascript = true,
    javascriptreact = true,
    typescript = true,
    typescriptreact = true,
    vue = true,
}

local function web_formatters(bufnr)
    if project.has_prettier(bufnr) then
        return { "prettier", stop_after_first = true }
    end
    if project.has_root_file(bufnr, project.biome_configs) and project.node_bin(bufnr, "biome") then
        return { "biome_local", stop_after_first = true }
    end
    if project.has_root_file(bufnr, project.oxfmt_configs) and project.node_bin(bufnr, "oxfmt") then
        return { "oxfmt_local", stop_after_first = true }
    end
    return {}
end

conform.setup({
    formatters_by_ft = {
        go = { "goimports", "gofumpt" },
        rust = { "rustfmt" },
        python = { "ruff_organize_imports", "ruff_format" },
        sh = { "shfmt" },
        javascript = web_formatters,
        javascriptreact = web_formatters,
        typescript = web_formatters,
        typescriptreact = web_formatters,
        vue = web_formatters,
        java = { "google-java-format" },
        markdown = { "prettier", "markdownlint-cli2" },
    },
    formatters = {
        biome_local = {
            inherit = "biome",
            command = function(_, ctx)
                return project.node_bin(ctx.buf, "biome")
            end,
        },
        oxfmt_local = {
            inherit = "oxfmt",
            command = function(_, ctx)
                return project.node_bin(ctx.buf, "oxfmt")
            end,
        },
    },
    format_on_save = {
        timeout_ms = 1000,
        lsp_format = "fallback",
    },
})

vim.keymap.set("n", "<leader>cf", function()
    conform.format({
        async = false,
        lsp_format = "fallback",
        stop_after_first = web_filetypes[vim.bo.filetype] or nil,
    })
end, { desc = "現在のバッファを整形" })
