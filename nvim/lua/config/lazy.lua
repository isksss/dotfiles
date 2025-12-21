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
            require("config.lualine")
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
            require("config.lsp")
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

            -- Filters
            "Shougo/ddc-filter-matcher_head",
            "Shougo/ddc-filter-sorter_rank",
        },
        event = "InsertEnter",
        config = function()
            require("config.ddc")
        end,
    },
}, {
    checker = {
        enabled = true,
    },
})
