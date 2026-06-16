-----------------------------------------------------------
-- 言語別 task 実行
-----------------------------------------------------------
local M = {}

local project = require("config.project")

local function file()
    local name = vim.api.nvim_buf_get_name(0)
    if name == "" then
        return nil
    end
    return name
end

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

local function root()
    return project.root(0, root_markers[vim.bo.filetype] or { ".git" }) or vim.fn.getcwd()
end

local function notify(message, level)
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

local function quickfix(cmd, opts)
    opts = opts or {}
    local cwd = opts.cwd or root()
    local title = opts.title or shell_join(cmd)

    notify("実行: " .. title)
    vim.system(cmd, { cwd = cwd, text = true }, function(result)
        vim.schedule(function()
            local output = vim.trim((result.stdout or "") .. "\n" .. (result.stderr or ""))
            local lines = {}
            if output ~= "" then
                lines = vim.split(output, "\n", { trimempty = true })
            end

            vim.fn.setqflist({}, " ", {
                title = title,
                lines = lines,
                efm = opts.efm or vim.o.errorformat,
            })

            if result.code == 0 then
                notify("成功: " .. title)
                if #vim.fn.getqflist() > 0 then
                    vim.cmd("copen")
                else
                    vim.cmd("cclose")
                end
            else
                notify("失敗: " .. title, vim.log.levels.ERROR)
                vim.cmd("copen")
            end
        end)
    end)
end

local function terminal(cmd, opts)
    opts = opts or {}
    local cwd = opts.cwd or root()
    vim.cmd("botright split")
    vim.cmd("resize 15")
    vim.cmd("lcd " .. vim.fn.fnameescape(cwd))
    vim.cmd("terminal " .. shell_join(cmd))
    vim.cmd("wincmd p")
end

local function package_script(name)
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

    if package.scripts[name] then
        return package_root
    end
    return nil
end

local ts_efm = table.concat({
    "%f(%l\\,%c): %m",
    "%f:%l:%c - %m",
    "%f:%l:%c %m",
}, ",")

local function js_check()
    local cwd = package_script("typecheck")
    if cwd then
        quickfix({ "npm", "run", "typecheck" }, { cwd = cwd, title = "npm run typecheck", efm = ts_efm })
        return
    end
    quickfix({ "npx", "--no-install", "tsc", "--noEmit" }, { title = "tsc --noEmit", efm = ts_efm })
end

local function js_test()
    local cwd = package_script("test")
    if cwd then
        quickfix({ "npm", "test" }, { cwd = cwd, title = "npm test" })
        return
    end
    notify("package.json に test script がありません", vim.log.levels.WARN)
end

local function js_run()
    local cwd = package_script("dev")
    if cwd then
        terminal({ "npm", "run", "dev" }, { cwd = cwd })
        return
    end

    local name = file()
    if not name then
        return
    end

    local ft = vim.bo.filetype
    if ft == "javascript" or ft == "javascriptreact" then
        terminal({ "node", name })
        return
    end
    terminal({ "npx", "--no-install", "tsx", name })
end

local handlers = {
    check = {
        go = function()
            quickfix({ "go", "test", "./..." }, { title = "go test ./..." })
        end,
        rust = function()
            quickfix({ "cargo", "check" }, { title = "cargo check" })
        end,
        python = function()
            local name = file()
            if name then
                quickfix({ "python3", "-m", "py_compile", name }, { title = "python -m py_compile" })
            end
        end,
        sh = function()
            local name = file()
            if name then
                quickfix({ "bash", "-n", name }, { title = "bash -n" })
            end
        end,
        javascript = js_check,
        javascriptreact = js_check,
        typescript = js_check,
        typescriptreact = js_check,
        vue = js_check,
    },
    test = {
        go = function()
            quickfix({ "go", "test", "./..." }, { title = "go test ./..." })
        end,
        rust = function()
            quickfix({ "cargo", "test" }, { title = "cargo test" })
        end,
        python = function()
            quickfix({ "python3", "-m", "pytest" }, { title = "pytest" })
        end,
        javascript = js_test,
        javascriptreact = js_test,
        typescript = js_test,
        typescriptreact = js_test,
        vue = js_test,
    },
    run = {
        go = function()
            terminal({ "go", "run", "." })
        end,
        rust = function()
            terminal({ "cargo", "run" })
        end,
        python = function()
            local name = file()
            if name then
                terminal({ "python3", name })
            end
        end,
        sh = function()
            local name = file()
            if name then
                terminal({ "bash", name })
            end
        end,
        javascript = js_run,
        javascriptreact = js_run,
        typescript = js_run,
        typescriptreact = js_run,
        vue = js_run,
    },
}

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
    local ft = vim.bo.filetype
    if ft == "python" then
        require("conform").format({ formatters = { "ruff_organize_imports" }, async = false })
        return
    end
    vim.lsp.buf.code_action({
        apply = true,
        context = {
            only = { "source.organizeImports" },
            diagnostics = {},
        },
    })
end

function M.fix_all()
    local ft = vim.bo.filetype
    if ft == "python" then
        require("conform").format({ formatters = { "ruff_fix" }, async = false })
        return
    end
    vim.lsp.buf.code_action({
        apply = true,
        context = {
            only = { "source.fixAll" },
            diagnostics = {},
        },
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
