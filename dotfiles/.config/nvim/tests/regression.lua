-- Run from the repository root: nvim --headless -u NONE -l dotfiles/.config/nvim/tests/regression.lua
vim.opt.rtp:prepend(vim.fn.getcwd() .. "/dotfiles/.config/nvim")
local project = require("config.project")
local runner = require("config.tasks.runner")
local tmp = vim.fn.tempname()
vim.fn.mkdir(tmp, "p")
local function write(path, contents)
    vim.fn.mkdir(vim.fs.dirname(tmp .. "/" .. path), "p")
    vim.fn.writefile({ contents or "" }, tmp .. "/" .. path)
end
local function buffer(path, ft)
    vim.api.nvim_set_current_buf(vim.fn.bufadd(tmp .. "/" .. path))
    vim.bo.filetype = ft or "typescript"
end
local function eq(expected, actual)
    assert(vim.deep_equal(expected, actual), vim.inspect({ expected = expected, actual = actual }))
end
local ok, err = xpcall(function()
    write("package.json", "{}")
    write("pnpm-lock.yaml")
    write("src/app.ts")
    write("node_modules/.bin/tsc", "#!/bin/sh")
    vim.fn.setfperm(tmp .. "/node_modules/.bin/tsc", "rwx------")
    buffer("index.ts")
    eq(tmp .. "/node_modules/.bin/tsc", project.node_bin(0, "tsc"))
    eq("pnpm", project.package_manager(0))
    eq("node", (project.runtime(0)))
    write("deno/deno.jsonc", "{ // comment\n}")
    write("deno/package.json", "{}")
    buffer("deno/src/main.ts")
    eq("deno", (project.runtime(0)))
    write("deno/node/package-lock.json")
    buffer("deno/node/main.ts")
    eq("node", (project.runtime(0)))
    buffer("deno/component.vue", "vue")
    eq("node", (project.runtime(0)))
    write("deno.json", "{}")
    buffer("src/app.ts")
    eq("deno", (project.runtime(0)))
    write("yarn.lock")
    eq(nil, (project.package_manager(0)))
    write("package.json", '{"packageManager":"pnpm@10.0.0"}')
    eq("pnpm", project.package_manager(0))

    local cwd = vim.fn.getcwd()
    local locality = vim.fn.haslocaldir()
    local items = runner.results({ "src/app.ts:2:3: broken", "unparsed output" }, tmp, "%f:%l:%c: %m,%+G%.%#")
    eq(tmp .. "/src/app.ts", vim.api.nvim_buf_get_name(items[1].bufnr))
    eq(2, items[1].lnum)
    eq("unparsed output", items[2].text)
    eq(cwd, vim.fn.getcwd())
    eq(locality, vim.fn.haslocaldir())

    local quickfix = runner.quickfix
    local captured
    runner.quickfix = function(_, opts)
        captured = opts
    end
    require("config.tasks.languages").check.rust()
    local rust_items = runner.results({ "error[E0425]: missing", " --> src/main.rs:2:3" }, tmp, captured.efm)
    eq(tmp .. "/src/main.rs", vim.api.nvim_buf_get_name(rust_items[1].bufnr))
    eq(2, rust_items[1].lnum)
    local panic = runner.results({ "thread 'smoke' panicked at src/main.rs:4:5:" }, tmp, captured.efm)
    eq(4, panic[1].lnum)
    write("package.json", '{"packageManager":"pnpm@10.0.0","scripts":{"typecheck":"tsc --noEmit"}}')
    buffer("component.vue", "vue")
    require("config.tasks.languages").check.typescript()
    local deno_items = runner.results({ "    at file://" .. tmp .. "/src/app.ts:3:4" }, tmp, captured.efm)
    eq(tmp .. "/src/app.ts", vim.api.nvim_buf_get_name(deno_items[1].bufnr))
    eq(3, deno_items[1].lnum)
    runner.quickfix = quickfix
    buffer("src/app.ts")

    -- Import edits must be applied before formatting, never via a late callback.
    local order = {}
    package.loaded.conform = {
        setup = function() end,
        format = function()
            table.insert(order, "format")
        end,
    }
    local get_clients = vim.lsp.get_clients
    local apply_edit = vim.lsp.util.apply_workspace_edit
    vim.lsp.get_clients = function()
        return {
            {
                offset_encoding = "utf-16",
                supports_method = function()
                    return true
                end,
                request_sync = function(_, method)
                    eq("textDocument/codeAction", method)
                    return { result = { { title = "Organize", edit = { changes = {} } } } }
                end,
            },
        }
    end
    vim.lsp.util.apply_workspace_edit = function()
        table.insert(order, "imports")
    end
    require("config.format")
    vim.api.nvim_exec_autocmds("BufWritePre", { buffer = 0 })
    eq({ "imports", "format" }, order)
    order = {}
    local clock = vim.uv.hrtime
    local now = 0
    vim.uv.hrtime = function()
        return now
    end
    vim.lsp.get_clients = function()
        return {
            {
                offset_encoding = "utf-16",
                supports_method = function()
                    return true
                end,
                request_sync = function()
                    now = 2000000000
                    return { result = { { title = "Late", edit = { changes = {} } } } }
                end,
            },
        }
    end
    vim.api.nvim_exec_autocmds("BufWritePre", { buffer = 0 })
    eq({ "format" }, order)
    vim.uv.hrtime = clock
    vim.lsp.get_clients = get_clients
    vim.lsp.util.apply_workspace_edit = apply_edit
end, debug.traceback)
vim.fn.delete(tmp, "rf")
if not ok then
    error(err)
end
print("PASS: runtime, package manager, local tools, Quickfix paths, save order")
