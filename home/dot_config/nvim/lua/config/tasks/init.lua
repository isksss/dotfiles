-----------------------------------------------------------
-- Public task API
-----------------------------------------------------------
local M = {}
local handlers = require("config.tasks.languages")

local function notify(message, level)
    vim.notify(message, level or vim.log.levels.INFO)
end

local function dispatch(kind)
    local handler = handlers[kind] and handlers[kind][vim.bo.filetype]
    if not handler then
        notify("この filetype では " .. kind .. " を定義していません: " .. vim.bo.filetype, vim.log.levels.WARN)
        return
    end
    handler()
end

function M.check()
    dispatch("check")
end

function M.test()
    dispatch("test")
end

function M.run()
    dispatch("run")
end

function M.organize_imports()
    if vim.bo.filetype == "python" then
        require("conform").format({ formatters = { "ruff_organize_imports" }, async = false })
        return
    end
    vim.lsp.buf.code_action({
        apply = true,
        context = { only = { "source.organizeImports" }, diagnostics = {} },
    })
end

function M.fix_all()
    if vim.bo.filetype == "python" then
        require("conform").format({ formatters = { "ruff_fix" }, async = false })
        return
    end
    vim.lsp.buf.code_action({
        apply = true,
        context = { only = { "source.fixAll" }, diagnostics = {} },
    })
end

function M.toggle_inlay_hints()
    if not vim.lsp.inlay_hint then
        notify("この Neovim では inlay hints を利用できません", vim.log.levels.WARN)
        return
    end

    local bufnr = vim.api.nvim_get_current_buf()
    local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
    vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
end

return M
