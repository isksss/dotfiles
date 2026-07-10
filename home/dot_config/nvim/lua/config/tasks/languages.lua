-----------------------------------------------------------
-- Language-specific task handlers
-----------------------------------------------------------
local runner = require("config.tasks.runner")

local ts_efm = table.concat({
    "%f(%l\\,%c): %m",
    "%f:%l:%c - %m",
    "%f:%l:%c %m",
}, ",")

local function js_check()
    local cwd = runner.package_script("typecheck")
    if cwd then
        runner.quickfix({ "npm", "run", "typecheck" }, { cwd = cwd, title = "npm run typecheck", efm = ts_efm })
        return
    end
    runner.quickfix({ "npx", "--no-install", "tsc", "--noEmit" }, { title = "tsc --noEmit", efm = ts_efm })
end

local function js_test()
    local cwd = runner.package_script("test")
    if cwd then
        runner.quickfix({ "npm", "test" }, { cwd = cwd, title = "npm test" })
        return
    end
    runner.notify("package.json に test script がありません", vim.log.levels.WARN)
end

local function js_run()
    local cwd = runner.package_script("dev")
    if cwd then
        runner.terminal({ "npm", "run", "dev" }, { cwd = cwd })
        return
    end

    local name = runner.file()
    if not name then
        return
    end

    if vim.bo.filetype == "javascript" or vim.bo.filetype == "javascriptreact" then
        runner.terminal({ "node", name })
    else
        runner.terminal({ "npx", "--no-install", "tsx", name })
    end
end

return {
    check = {
        go = function()
            runner.quickfix({ "go", "test", "./..." }, { title = "go test ./..." })
        end,
        rust = function()
            runner.quickfix({ "cargo", "check" }, { title = "cargo check" })
        end,
        python = function()
            local name = runner.file()
            if name then
                runner.quickfix({ "python3", "-m", "py_compile", name }, { title = "python -m py_compile" })
            end
        end,
        sh = function()
            local name = runner.file()
            if name then
                runner.quickfix({ "bash", "-n", name }, { title = "bash -n" })
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
            runner.quickfix({ "go", "test", "./..." }, { title = "go test ./..." })
        end,
        rust = function()
            runner.quickfix({ "cargo", "test" }, { title = "cargo test" })
        end,
        python = function()
            runner.quickfix({ "python3", "-m", "pytest" }, { title = "pytest" })
        end,
        javascript = js_test,
        javascriptreact = js_test,
        typescript = js_test,
        typescriptreact = js_test,
        vue = js_test,
    },
    run = {
        go = function()
            runner.terminal({ "go", "run", "." })
        end,
        rust = function()
            runner.terminal({ "cargo", "run" })
        end,
        python = function()
            local name = runner.file()
            if name then
                runner.terminal({ "python3", name })
            end
        end,
        sh = function()
            local name = runner.file()
            if name then
                runner.terminal({ "bash", name })
            end
        end,
        javascript = js_run,
        javascriptreact = js_run,
        typescript = js_run,
        typescriptreact = js_run,
        vue = js_run,
    },
}
