local M = {}
local project = require("config.project")
local active
local terminal_job

function M.notify(message, level)
    vim.notify(message, level or vim.log.levels.INFO)
end
function M.file()
    local name = vim.api.nvim_buf_get_name(0)
    return name ~= "" and name or nil
end
function M.root()
    local ft = vim.bo.filetype
    if ft == "rust" then
        return project.root(0, { "Cargo.toml" }) or vim.fn.getcwd()
    end
    if ft == "go" then
        return vim.fs.dirname(M.file() or vim.fn.getcwd() .. "/_")
    end
    if vim.tbl_contains({ "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" }, ft) then
        local _, root = project.runtime(0)
        return root
    end
    return project.root(0, { ".git" }) or vim.fn.getcwd()
end

-- Parse paths while the task's directory is current, never the user's later directory.
function M.results(lines, cwd, efm)
    local buf = vim.api.nvim_create_buf(false, true)
    local items
    vim.api.nvim_buf_call(buf, function()
        local previous = vim.fn.getcwd()
        local ok, err = pcall(function()
            vim.cmd("lcd " .. vim.fn.fnameescape(cwd))
            local normalized = vim.tbl_map(function(line)
                line = line:gsub("file://[^%s)]+", function(uri)
                    return vim.uri_to_fname(uri)
                end)
                return (line:gsub("^%s*at%s+(.*:%d+:%d+)%s*$", "%1"))
            end, lines)
            items = vim.fn.getqflist({ lines = normalized, efm = efm }).items
        end)
        vim.cmd("lcd " .. vim.fn.fnameescape(previous))
        if not ok then
            error(err)
        end
    end)
    vim.api.nvim_buf_delete(buf, { force = true })
    return items
end

function M.quickfix(cmd, opts)
    opts = opts or {}
    if active then
        M.notify("check/test が実行中です。先に中止してください", vim.log.levels.WARN)
        return
    end
    if vim.fn.executable(cmd[1]) ~= 1 then
        M.notify("実行ファイルが見つかりません: " .. cmd[1], vim.log.levels.ERROR)
        return
    end
    local cwd = opts.cwd or M.root()
    local title = opts.title or table.concat(cmd, " ")
    local job = {}
    active = job
    M.notify("実行: " .. title)
    local ok, process = pcall(vim.system, cmd, {
        cwd = cwd,
        text = true,
        env = { NO_COLOR = "1", FORCE_COLOR = "0", CARGO_TERM_COLOR = "never" },
    }, function(result)
        vim.schedule(function()
            if active ~= job then
                return
            end
            active = nil
            local output = ((result.stdout or "") .. "\n" .. (result.stderr or "")):gsub("\27%[[%d;]*m", "")
            local lines = vim.split(output, "\n", { trimempty = true })
            local items = M.results(lines, cwd, opts.efm or "%f:%l:%c: %m,%f:%l: %m,%+G%.%#")
            vim.fn.setqflist({}, " ", { title = title, items = items })
            M.notify(
                (result.code == 0 and "成功: " or "失敗: ") .. title,
                result.code == 0 and vim.log.levels.INFO or vim.log.levels.ERROR
            )
            if #items > 0 or result.code ~= 0 then
                vim.cmd("copen")
            end
        end)
    end)
    if ok then
        job.process = process
    else
        active = nil
        M.notify(tostring(process), vim.log.levels.ERROR)
    end
end

function M.terminal(cmd, opts)
    opts = opts or {}
    if vim.fn.executable(cmd[1]) ~= 1 then
        M.notify("実行ファイルが見つかりません: " .. cmd[1], vim.log.levels.ERROR)
        return
    end
    if terminal_job and vim.fn.jobwait({ terminal_job }, 0)[1] == -1 then
        M.notify("run が実行中です。先に中止してください", vim.log.levels.WARN)
        return
    end
    local cwd = opts.cwd or M.root()
    vim.cmd("botright 15new")
    terminal_job = vim.fn.jobstart(cmd, { term = true, cwd = cwd })
    vim.cmd("startinsert")
end

function M.stop()
    if active then
        local job = active
        active = nil
        if job.process then
            job.process:kill(15)
        end
    end
    if terminal_job then
        pcall(vim.fn.jobstop, terminal_job)
        terminal_job = nil
    end
    M.notify("タスクを中止しました")
end

return M
