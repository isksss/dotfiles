local M = {}
local conform = require("conform")
local project = require("config.project")
local web = { javascript = true, javascriptreact = true, typescript = true, typescriptreact = true, vue = true }

local function web_formatters(bufnr)
    if project.runtime(bufnr) == "deno" then
        return { "deno_fmt" }
    end
    if project.has_prettier(bufnr) then
        return { "prettier" }
    end
    if project.has_root_file(bufnr, project.biome_configs) and project.node_bin(bufnr, "biome") then
        return { "biome_local" }
    end
    if project.has_root_file(bufnr, project.oxfmt_configs) and project.node_bin(bufnr, "oxfmt") then
        return { "oxfmt_local" }
    end
    return {}
end

conform.setup({
    formatters_by_ft = {
        go = { "goimports", "gofumpt" },
        rust = { "rustfmt" },
        sh = { "shfmt" },
        javascript = web_formatters,
        javascriptreact = web_formatters,
        typescript = web_formatters,
        typescriptreact = web_formatters,
        vue = web_formatters,
        markdown = { "prettier" },
    },
    formatters = {
        deno_fmt = {
            cwd = function(_, ctx)
                local _, root = project.runtime(ctx.buf)
                return root
            end,
        },
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
})

function M.format(bufnr)
    conform.format({ bufnr = bufnr or 0, async = false, timeout_ms = 1000, lsp_format = "never" })
end

-- Only the language owner may organize imports; auxiliary Vue/ESLint clients must not race it.
function M.organize_imports(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    if bufnr == 0 then
        bufnr = vim.api.nvim_get_current_buf()
    end
    local ft = vim.bo[bufnr].filetype
    if ft == "go" then
        conform.format({ bufnr = bufnr, formatters = { "goimports" }, async = false, timeout_ms = 1000 })
        return
    end
    local owner = ft == "rust" and "rust_analyzer"
        or (web[ft] and (project.runtime(bufnr) == "deno" and "denols" or "vtsls"))
    if not owner then
        return
    end
    local client = vim.lsp.get_clients({ bufnr = bufnr, name = owner })[1]
    if not client or not client:supports_method("textDocument/codeAction", bufnr) then
        return
    end
    local deadline = vim.uv.hrtime() / 1e6 + 1000
    local changedtick = vim.api.nvim_buf_get_changedtick(bufnr)
    local failed = false
    local function request(method, params)
        local remaining = math.floor(deadline - vim.uv.hrtime() / 1e6)
        if remaining <= 0 then
            failed = true
            return nil
        end
        local response = client:request_sync(method, params, remaining, bufnr)
        if response and not response.err and vim.uv.hrtime() / 1e6 <= deadline then
            return response.result
        end
        failed = true
    end
    local params = {
        textDocument = { uri = vim.uri_from_bufnr(bufnr) },
        range = { start = { line = 0, character = 0 }, ["end"] = { line = 0, character = 0 } },
        context = { only = { "source.organizeImports" }, diagnostics = {}, triggerKind = 1 },
    }
    local actions = request("textDocument/codeAction", params)
    if not actions then
        if failed then
            vim.notify("import 整理が完了しませんでした", vim.log.levels.WARN)
        end
        return
    end
    for _, action in ipairs(actions) do
        if not action.disabled then
            if not action.edit and client:supports_method("codeAction/resolve", bufnr) then
                action = request("codeAction/resolve", action) or {}
            end
            if
                action.edit
                and vim.uv.hrtime() / 1e6 <= deadline
                and vim.api.nvim_buf_get_changedtick(bufnr) == changedtick
            then
                vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
            end
            -- Import providers return WorkspaceEdits. Do not execute commands that could
            -- apply edits asynchronously after the save deadline (vtsls also adds telemetry).
            break
        end
    end
    if failed then
        vim.notify("import 整理が完了しませんでした", vim.log.levels.WARN)
    end
end

vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("UserFormat", { clear = true }),
    callback = function(event)
        if vim.bo[event.buf].buftype ~= "" then
            return
        end
        local ok, err = pcall(function()
            -- goimports is already the first formatter.
            if vim.bo[event.buf].filetype ~= "go" then
                M.organize_imports(event.buf)
            end
            M.format(event.buf)
        end)
        if not ok then
            vim.notify("保存時の整形に失敗: " .. tostring(err), vim.log.levels.WARN)
        end
    end,
})

return M
