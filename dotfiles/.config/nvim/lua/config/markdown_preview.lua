-----------------------------------------------------------
-- Markdown preview with Leaf
-----------------------------------------------------------
local M = {}

local preview

local function notify(message, level)
    vim.notify(message, level or vim.log.levels.INFO)
end

local function close_preview()
    if not preview then
        return
    end

    local current = preview
    preview = nil

    if current.job and current.job > 0 then
        pcall(vim.fn.jobstop, current.job)
    end
    if current.win and vim.api.nvim_win_is_valid(current.win) then
        pcall(vim.api.nvim_win_close, current.win, true)
    end
    if current.buf and vim.api.nvim_buf_is_valid(current.buf) then
        pcall(vim.api.nvim_buf_delete, current.buf, { force = true })
    end
end

local function toggle_preview()
    local source_buf = vim.api.nvim_get_current_buf()
    local path = vim.api.nvim_buf_get_name(source_buf)

    if path == "" then
        notify("Markdown プレビューには保存済みのファイルが必要です", vim.log.levels.ERROR)
        return
    end

    if preview then
        local same_source = preview.source_buf == source_buf
        close_preview()
        if same_source then
            return
        end
    end

    if vim.fn.executable("leaf") ~= 1 then
        notify("leaf が見つかりません", vim.log.levels.ERROR)
        return
    end

    local ok, err = pcall(vim.cmd, "write")
    if not ok then
        notify("Markdown を保存できませんでした: " .. tostring(err), vim.log.levels.ERROR)
        return
    end

    local source_win = vim.api.nvim_get_current_win()
    vim.cmd("rightbelow vnew")

    local current = {
        source_buf = source_buf,
        buf = vim.api.nvim_get_current_buf(),
        win = vim.api.nvim_get_current_win(),
    }
    preview = current

    vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], {
        buffer = current.buf,
        desc = "Markdown 編集ウィンドウへ戻る",
    })
    vim.api.nvim_create_autocmd("WinEnter", {
        buffer = current.buf,
        callback = function()
            vim.cmd("startinsert")
        end,
    })

    current.job = vim.fn.jobstart({ "leaf", "--watch", path }, {
        term = true,
        cwd = vim.fs.dirname(path),
        on_exit = function()
            vim.schedule(function()
                if preview ~= current then
                    return
                end
                preview = nil
                if vim.api.nvim_win_is_valid(current.win) then
                    pcall(vim.api.nvim_win_close, current.win, true)
                end
                if vim.api.nvim_buf_is_valid(current.buf) then
                    pcall(vim.api.nvim_buf_delete, current.buf, { force = true })
                end
            end)
        end,
    })

    if current.job <= 0 then
        preview = nil
        pcall(vim.api.nvim_win_close, current.win, true)
        pcall(vim.api.nvim_buf_delete, current.buf, { force = true })
        notify("Leaf を起動できませんでした", vim.log.levels.ERROR)
        return
    end

    vim.api.nvim_set_current_win(source_win)
end

function M.setup()
    local group = vim.api.nvim_create_augroup("markdown_preview", { clear = true })

    vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "markdown",
        callback = function(event)
            vim.keymap.set("n", "<leader>p", toggle_preview, {
                buffer = event.buf,
                desc = "Markdown プレビューを切り替え",
            })
        end,
    })
end

return M
