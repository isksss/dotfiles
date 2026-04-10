-----------------------------------------------------------
-- ddu 設定
-----------------------------------------------------------
local M = {}

local function dict(tbl)
    local result = vim.empty_dict()
    for key, value in pairs(tbl or {}) do
        if type(value) == "table" and not vim.tbl_islist(value) then
            result[key] = dict(value)
        else
            result[key] = value
        end
    end
    return result
end

local function ui_action(action, params)
    if params == nil then
        vim.fn["ddu#ui#do_action"](action)
        return
    end

    vim.fn["ddu#ui#do_action"](action, dict(params))
end

local function start(name, opts)
    opts = opts or {}
    opts.name = name
    vim.fn["ddu#start"](opts)
end

function M.files()
    start("files", {
        ui = "ff",
        sources = {
            { name = "file_rec" },
        },
    })
end

function M.buffers()
    start("buffers", {
        ui = "ff",
        sources = {
            { name = "buffer" },
        },
    })
end

function M.live_grep()
    local input = vim.fn.input("Grep pattern: ")
    if input == nil or input == "" then
        return
    end

    start("live_grep", {
        ui = "ff",
        sources = {
            {
                name = "rg",
                params = {
                    input = input,
                },
            },
        },
    })
end

function M.explorer()
    local path = vim.fn.expand("%:p:h")
    if path == "" then
        path = vim.fn.getcwd()
    end

    start("explorer", {
        ui = "filer",
        searchPath = path,
        sources = {
            {
                name = "file",
                params = {
                    path = path,
                },
            },
        },
    })
end

function M.setup()
    vim.fn["ddu#custom#patch_global"]({
        sourceOptions = {
            ["_"] = {
                ignoreCase = true,
                matchers = { "matcher_substring" },
                smartCase = true,
                sorters = { "sorter_alpha" },
            },
            buffer = {
                defaultAction = "open",
            },
            file = {
                defaultAction = "open",
            },
            file_rec = {
                defaultAction = "open",
            },
            rg = {
                defaultAction = "open",
            },
        },
        sourceParams = {
            file = {
                hidden = true,
            },
            file_rec = {
                hidden = true,
            },
            rg = {
                args = {
                    "--column",
                    "--hidden",
                    "--glob",
                    "!.git",
                    "--no-heading",
                    "--color",
                    "never",
                },
            },
        },
        kindOptions = {
            file = {
                defaultAction = "open",
            },
        },
        uiParams = {
            ff = {
                autoResize = true,
                prompt = "> ",
                split = "floating",
                startAutoAction = false,
                startFilter = true,
            },
            filer = {
                split = "floating",
                toggle = true,
                width = 40,
            },
        },
    })

    vim.api.nvim_create_user_command("DduFiles", function()
        M.files()
    end, {})

    vim.api.nvim_create_user_command("DduBuffers", function()
        M.buffers()
    end, {})

    vim.api.nvim_create_user_command("DduLiveGrep", function()
        M.live_grep()
    end, {})

    vim.api.nvim_create_user_command("DduExplorer", function()
        M.explorer()
    end, {})

    local ddu_group = vim.api.nvim_create_augroup("DduSettings", { clear = true })

    vim.api.nvim_create_autocmd("FileType", {
        group = ddu_group,
        pattern = "ddu-ff",
        callback = function(event)
            local opts = { buffer = event.buf, silent = true, nowait = true }
            vim.keymap.set("n", "q", function()
                ui_action("quit")
            end, opts)
            vim.keymap.set("n", "<CR>", function()
                local item = vim.fn["ddu#ui#get_item"]()
                if item.isTree then
                    ui_action("itemAction", { name = "narrow" })
                else
                    ui_action("itemAction", { name = "open" })
                end
            end, opts)
            vim.keymap.set("n", "i", function()
                ui_action("openFilterWindow")
            end, opts)
            vim.keymap.set("n", "v", function()
                ui_action("itemAction", { params = { command = "vsplit" } })
            end, opts)
            vim.keymap.set("n", "s", function()
                ui_action("itemAction", { params = { command = "split" } })
            end, opts)
            vim.keymap.set("n", "t", function()
                ui_action("itemAction", { params = { command = "tabnew" } })
            end, opts)
        end,
    })

    vim.api.nvim_create_autocmd("FileType", {
        group = ddu_group,
        pattern = "ddu-filer",
        callback = function(event)
            local opts = { buffer = event.buf, silent = true, nowait = true }
            vim.keymap.set("n", "q", function()
                ui_action("quit")
            end, opts)
            vim.keymap.set("n", "<CR>", function()
                ui_action("itemAction")
            end, opts)
            vim.keymap.set("n", "o", function()
                ui_action("expandItem", { mode = "toggle" })
            end, opts)
            vim.keymap.set("n", "v", function()
                ui_action("itemAction", { name = "open", params = { command = "vsplit" } })
            end, opts)
            vim.keymap.set("n", "s", function()
                ui_action("itemAction", { name = "open", params = { command = "split" } })
            end, opts)
            vim.keymap.set("n", "t", function()
                ui_action("itemAction", { name = "open", params = { command = "tabnew" } })
            end, opts)
            vim.keymap.set("n", ".", function()
                ui_action("toggleHiddenItems")
            end, opts)
        end,
    })
end

return M
