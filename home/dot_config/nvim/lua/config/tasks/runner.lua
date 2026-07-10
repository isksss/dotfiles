-----------------------------------------------------------
-- Shared task process and project helpers
-----------------------------------------------------------
local M = {}

local project = require("config.project")

local root_markers = {
    go = { "go.work", "go.mod", ".git" },
    rust = { "Cargo.toml", ".git" },
    python = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git" },
    sh = { ".shellcheckrc", ".editorconfig", ".git" },
    javascript = { "package.json", ".git" },
    javascriptreact = { "package.json", ".git" },
    typescript = { "package.json", ".git" },
    typescriptreact = { "package.json", ".git" },
    vue = { "package.json", ".git" },
}

function M.file()
    local name = vim.api.nvim_buf_get_name(0)
    return name ~= "" and name or nil
end

function M.root()
    return project.root(0, root_markers[vim.bo.filetype] or { ".git" }) or vim.fn.getcwd()
end

function M.notify(message, level)
    vim.notify(message, level or vim.log.levels.INFO)
end

local function shell_join(cmd)
    return table.concat(
        vim.tbl_map(function(arg)
            return vim.fn.shellescape(arg)
        end, cmd),
        " "
    )
end

function M.quickfix(cmd, opts)
    opts = opts or {}
    local cwd = opts.cwd or M.root()
    local title = opts.title or shell_join(cmd)

    M.notify("実行: " .. title)
    vim.system(cmd, { cwd = cwd, text = true }, function(result)
        vim.schedule(function()
            local output = vim.trim((result.stdout or "") .. "\n" .. (result.stderr or ""))
            local lines = output ~= "" and vim.split(output, "\n", { trimempty = true }) or {}

            vim.fn.setqflist({}, " ", {
                title = title,
                lines = lines,
                efm = opts.efm or vim.o.errorformat,
            })

            if result.code == 0 then
                M.notify("成功: " .. title)
                if #vim.fn.getqflist() > 0 then
                    vim.cmd("copen")
                else
                    vim.cmd("cclose")
                end
            else
                M.notify("失敗: " .. title, vim.log.levels.ERROR)
                vim.cmd("copen")
            end
        end)
    end)
end

function M.terminal(cmd, opts)
    opts = opts or {}
    local cwd = opts.cwd or M.root()
    vim.cmd("botright split")
    vim.cmd("resize 15")
    vim.cmd("lcd " .. vim.fn.fnameescape(cwd))
    vim.cmd("terminal " .. shell_join(cmd))
    vim.cmd("wincmd p")
end

function M.package_script(name)
    local package_root = project.root(0, { "package.json" })
    if not package_root then
        return nil
    end

    local path = vim.fs.joinpath(package_root, "package.json")
    local ok, lines = pcall(vim.fn.readfile, path)
    if not ok then
        return nil
    end

    local ok_json, package = pcall(vim.json.decode, table.concat(lines, "\n"))
    if not ok_json or type(package) ~= "table" or type(package.scripts) ~= "table" then
        return nil
    end

    return package.scripts[name] and package_root or nil
end

return M
