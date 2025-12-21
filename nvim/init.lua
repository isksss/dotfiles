-----------------------------------------------------------
-- 基本オプション（使いやすさ重視）
-----------------------------------------------------------
local opt = vim.opt

-- 行番号
opt.number = true
opt.relativenumber = true

-- 表示
opt.termguicolors = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8

-- インデント
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.smartindent = true
opt.autoindent = true

-- 検索
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

-- 編集体験
opt.backspace = { "indent", "eol", "start" }
opt.clipboard = "unnamedplus"
opt.confirm = true
opt.mouse = "a"

-- 分割
opt.splitbelow = true
opt.splitright = true

-- ファイル関連
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undo"

-- パフォーマンス
opt.updatetime = 300
opt.timeoutlen = 500
opt.redrawtime = 1500

-- コマンドライン
opt.cmdheight = 1
opt.showmode = false
opt.laststatus = 3

-- 補完
opt.completeopt = { "menu", "menuone", "noselect" }
opt.pumheight = 10

-- 不可視文字（必要に応じて）
opt.list = true
opt.listchars = {
    tab = "» ",
    trail = "·",
    nbsp = "␣",
}


-----------------------------------------------------------
-- lazy.nvim bootstrap
-----------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

-----------------------------------------------------------
-- lazy.nvim setup
-----------------------------------------------------------
require("lazy").setup({
    {
        "vim-denops/denops.vim",
        lazy = false, -- denops は常駐前提
    },
    -----------------------------------------------------------
    -- lualine（statusline）
    -----------------------------------------------------------
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        event = "VeryLazy",
        config = function()
            ---------------------------------------------------
            -- LSP 状態表示
            ---------------------------------------------------
            local function lsp_status()
                local bufnr = vim.api.nvim_get_current_buf()
                local clients = vim.lsp.get_clients({ bufnr = bufnr })
                if #clients == 0 then
                    return ""
                end

                local names = {}
                for _, client in ipairs(clients) do
                    table.insert(names, client.name)
                end
                return " " .. table.concat(names, ",")
            end

            ---------------------------------------------------
            -- ddc 状態表示
            ---------------------------------------------------
            local function ddc_status()
                if vim.fn.exists("*ddc#is_enabled") == 0 then
                    return ""
                end
                if vim.fn["ddc#is_enabled"]() == 1 then
                    return " ddc"
                end
                return ""
            end

            ---------------------------------------------------
            -- lualine setup
            ---------------------------------------------------
            require("lualine").setup({
                options = {
                    theme = "auto",
                    globalstatus = true,
                    section_separators = "",
                    component_separators = "",
                    disabled_filetypes = {
                        statusline = { "dashboard", "alpha" },
                    },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch" },
                    lualine_c = {
                        "filename",
                        lsp_status,
                    },
                    lualine_x = {
                        ddc_status,
                        "encoding",
                        "fileformat",
                        "filetype",
                    },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
            })
        end,
    },
    -----------------------------------------------------------
    -- LSP / Mason
    -----------------------------------------------------------
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "ts_ls",
                    "jsonls",
                    "yamlls",
                    "bashls",
                },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            local lspconfig = require("lspconfig")

            -- 共通 on_attach
            local on_attach = function(_, bufnr)
                local map = function(mode, lhs, rhs)
                    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr })
                end

                map("n", "gd", vim.lsp.buf.definition)
                map("n", "gr", vim.lsp.buf.references)
                map("n", "gi", vim.lsp.buf.implementation)
                map("n", "K", vim.lsp.buf.hover)
                map("n", "<leader>rn", vim.lsp.buf.rename)
                map("n", "<leader>ca", vim.lsp.buf.code_action)
                map("n", "[d", vim.diagnostic.goto_prev)
                map("n", "]d", vim.diagnostic.goto_next)
            end

            -- capabilities（補完連携用、ddc / cmp どちらでも拡張可）
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.fn["ddc#lsp#make_client_capabilities"](capabilities)

            -- Lua
            lspconfig.lua_ls.setup({
                on_attach = on_attach,
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        },
                        workspace = {
                            checkThirdParty = false,
                        },
                        telemetry = {
                            enable = false,
                        },
                    },
                },
            })

            -- TypeScript / JavaScript
            lspconfig.ts_ls.setup({
                on_attach = on_attach,
                capabilities = capabilities,
            })

            -- JSON
            lspconfig.jsonls.setup({
                on_attach = on_attach,
                capabilities = capabilities,
            })

            -- YAML
            lspconfig.yamlls.setup({
                on_attach = on_attach,
                capabilities = capabilities,
            })

            -- Bash
            lspconfig.bashls.setup({
                on_attach = on_attach,
                capabilities = capabilities,
            })
        end,
    },
    -----------------------------------------------------------
    -- ddc.vim（denops 補完）
    -----------------------------------------------------------
    {
        "Shougo/ddc.vim",
        dependencies = {
            "vim-denops/denops.vim",

            -- UI
            "Shougo/ddc-ui-native",

            -- Sources
            "Shougo/ddc-source-lsp",
            "Shougo/ddc-source-around",
            "Shougo/ddc-source-file",

            -- Filters
            "Shougo/ddc-filter-matcher_head",
            "Shougo/ddc-filter-sorter_rank",
        },
        event = "InsertEnter",
    },
}, {
    checker = {
        enabled = true,
    },
})

-----------------------------------------------------------
-- denops 設定（最小）
-- PATH 問題がある場合のみ指定
-----------------------------------------------------------
-- vim.g.denops_deno = "deno"

-----------------------------------------------------------
-- 起動時に denops を warmup（安定化のため）
-----------------------------------------------------------
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        pcall(vim.cmd, "DenopsRestart")
    end,
})

-----------------------------------------------------------
-- Diagnostic 表示
-----------------------------------------------------------
vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

-----------------------------------------------------------
-- ddc.vim 設定
-----------------------------------------------------------
vim.fn["ddc#custom#patch_global"]({
    ui = "native",
    sources = {
        "lsp",
        "around",
        "file",
    },
    sourceOptions = {
        _ = {
            matchers = { "matcher_head" },
            sorters = { "sorter_rank" },
        },
        lsp = {
            mark = "[LSP]",
            forceCompletionPattern = [[\.\w*|:\w*|->\w*]],
        },
        around = {
            mark = "[A]",
        },
        file = {
            mark = "[F]",
            isVolatile = true,
            forceCompletionPattern = [[\S/\S*]],
        },
    },
})

vim.fn["ddc#custom#patch_filetype"]("lua", {
    sources = { "lsp", "around" },
})

vim.fn["ddc#enable"]()

-----------------------------------------------------------
-- ddc keymap
-----------------------------------------------------------
local function pum_visible()
    return vim.fn.pumvisible() == 1
end

vim.keymap.set("i", "<Tab>", function()
    if pum_visible() then
        return "<C-n>"
    end
    return "<Tab>"
end, { expr = true })

vim.keymap.set("i", "<S-Tab>", function()
    if pum_visible() then
        return "<C-p>"
    end
    return "<S-Tab>"
end, { expr = true })

vim.keymap.set("i", "<CR>", function()
    if pum_visible() then
        return "<C-y>"
    end
    return "<CR>"
end, { expr = true })
