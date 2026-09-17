local M = {}
local function dispatch(kind)
    local handler = require("config.tasks.languages")[kind][vim.bo.filetype]
    if not handler then
        vim.notify(
            "この filetype では " .. kind .. " を定義していません: " .. vim.bo.filetype,
            vim.log.levels.WARN
        )
        return
    end
    local ok, err = pcall(vim.cmd, "wall")
    if not ok then
        vim.notify("保存できないため実行を中止: " .. tostring(err), vim.log.levels.ERROR)
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

function M.fix_all()
    vim.lsp.buf.code_action({ apply = true, context = { only = { "source.fixAll" }, diagnostics = {} } })
end

function M.toggle_inlay_hints()
    local bufnr = vim.api.nvim_get_current_buf()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
end
return M
