local runner = require("config.tasks.runner")
local project = require("config.project")
local ts_efm = "%f(%l\\,%c): %m,%f:%l:%c - %m,%f:%l:%c: %m, %#at %f:%l:%c,%f:%l:%c,%+G%.%#"
local rust_efm = "%Eerror: %m,%Eerror[E%n]: %m,%Wwarning: %m,%C %#--> %f:%l:%c,"
    .. "%Ethread %.%# panicked at %f:%l:%c:,%+G%.%#"

local function deno_task(kind)
    local _, root = project.runtime(0)
    local name = ({ check = "typecheck", test = "test", run = "dev" })[kind]
    if vim.fn.executable("deno") ~= 1 then
        runner.notify("deno が見つかりません", vim.log.levels.ERROR)
        return
    end
    -- Let Deno read JSONC/workspace tasks instead of duplicating its config parser.
    local listing = vim.system({ "deno", "task" }, { cwd = root, text = true, env = { NO_COLOR = "1" } }):wait(1000)
    if listing.code == 124 then
        runner.notify("Deno task の取得がタイムアウトしました", vim.log.levels.WARN)
        return
    end
    local output = (listing.stdout or "") .. "\n" .. (listing.stderr or "")
    local found = false
    for line in output:gmatch("[^\n]+") do
        if line:match("^%- ([^%s]+)") == name then
            found = true
        end
    end
    local cmd
    if found then
        cmd = { "deno", "task", name }
    elseif kind == "check" and runner.file() then
        cmd = { "deno", "check", runner.file() }
    elseif kind == "test" then
        cmd = { "deno", "test" }
    else
        runner.notify("Deno の dev task がありません", vim.log.levels.WARN)
        return
    end
    if kind == "run" then
        runner.terminal(cmd, { cwd = root })
    else
        runner.quickfix(cmd, { cwd = root, efm = ts_efm })
    end
end

local function web_task(kind)
    if project.runtime(0) == "deno" then
        deno_task(kind)
        return
    end
    local pkg, root = project.package(0)
    if not pkg then
        runner.notify("有効な package.json がありません", vim.log.levels.WARN)
        return
    end
    local manager, err = project.package_manager(0)
    if not manager then
        runner.notify(err, vim.log.levels.WARN)
        return
    end
    local name = ({ check = "typecheck", test = "test", run = "dev" })[kind]
    local cmd
    if type(pkg.scripts) == "table" and pkg.scripts[name] then
        cmd = { manager, "run", name }
    elseif kind == "check" then
        local vue = vim.bo.filetype == "vue"
            or (pkg.dependencies or {}).vue
            or (pkg.devDependencies or {}).vue
            or (pkg.dependencies or {}).nuxt
            or (pkg.devDependencies or {}).nuxt
        local tool = vue and "vue-tsc" or "tsc"
        local binary = project.node_bin(0, tool)
        if not binary then
            runner.notify(tool .. " が未導入です", vim.log.levels.WARN)
            return
        end
        cmd = { binary, "--noEmit" }
    else
        runner.notify("package.json に " .. name .. " script がありません", vim.log.levels.WARN)
        return
    end
    if kind == "run" then
        runner.terminal(cmd, { cwd = root })
    else
        runner.quickfix(cmd, { cwd = root, efm = ts_efm })
    end
end

local function shell()
    if vim.bo.filetype == "zsh" then
        return "zsh"
    end
    local name = runner.file() or ""
    local first = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] or ""
    if first:match("^#!.*bash") or name:match("%.bash$") or name:match("/%.bash") or vim.b.is_bash then
        return "bash"
    end
    return "sh"
end
local function shell_task(check)
    local file = runner.file()
    if not file then
        runner.notify("先にファイルを保存してください", vim.log.levels.WARN)
        return
    end
    if check then
        runner.quickfix({ shell(), "-n", file })
    else
        runner.terminal({ shell(), file })
    end
end

local M = {
    check = {
        rust = function()
            runner.quickfix({ "cargo", "check" }, { efm = rust_efm })
        end,
        go = function()
            runner.quickfix({ "go", "vet", "." })
        end,
        sh = function()
            shell_task(true)
        end,
        zsh = function()
            shell_task(true)
        end,
        markdown = function()
            require("config.lint").run()
        end,
    },
    test = {
        rust = function()
            runner.quickfix({ "cargo", "test" }, { efm = rust_efm })
        end,
        go = function()
            runner.quickfix({ "go", "test", "." }, { efm = "%f:%l:%c: %m,%f:%l: %m, %#%f:%l: %m,%+G%.%#" })
        end,
    },
    run = {
        rust = function()
            runner.terminal({ "cargo", "run" })
        end,
        go = function()
            runner.terminal({ "go", "run", "." })
        end,
        sh = function()
            shell_task(false)
        end,
        zsh = function()
            shell_task(false)
        end,
        markdown = function()
            require("config.markdown_preview").toggle()
        end,
    },
}
for _, ft in ipairs({ "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" }) do
    for _, kind in ipairs({ "check", "test", "run" }) do
        M[kind][ft] = function()
            web_task(kind)
        end
    end
end
return M
