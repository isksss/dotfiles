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
        lazy = false,
    },
    {
        "Shougo/ddu.vim",
        cmd = { "DduFiles", "DduBuffers", "DduLiveGrep", "DduExplorer" },
        dependencies = {
            "Shougo/ddu-ui-ff",
            "Shougo/ddu-ui-filer",
            "Shougo/ddu-kind-file",
            "Shougo/ddu-source-buffer",
            "Shougo/ddu-source-file",
            "Shougo/ddu-source-file_rec",
            "Shougo/ddu-filter-matcher_substring",
            "Shougo/ddu-filter-sorter_alpha",
            "shun/ddu-source-rg",
        },
        config = function()
            require("config.ddu").setup()
        end,
    },
    -- ステータスライン
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "auto",
                    section_separators = "",
                    component_separators = "",
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff", "diagnostics" },
                    lualine_c = { "filename" },
                    lualine_x = { "encoding", "fileformat", "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
            })
        end,
    },
    {
        "tpope/vim-fugitive",
        cmd = { "Git", "G", "Gdiffsplit", "Gvdiffsplit", "Gwrite", "Gread" },
    },
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("config.git")
        end,
    },
    {
        "akinsho/bufferline.nvim",
        version = "*",
        event = "VeryLazy",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("config.tabs")
        end,
    },
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        config = function()
            require("config.lsp")
        end,
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = {
            "williamboman/mason.nvim",
        },
        config = function()
            require("mason-tool-installer").setup({
                ensure_installed = {
                    "prettier",
                    "eslint_d",
                    "google-java-format",
                    "checkstyle",
                },
            })
        end,
    },
    {
        "Shougo/ddc.vim",
        event = "InsertEnter",
        dependencies = {
            "Shougo/pum.vim",
            "Shougo/ddc-ui-pum",
            "Shougo/ddc-source-around",
            "LumaKernel/ddc-source-file",
            "Shougo/ddc-source-lsp",
            "Shougo/ddc-matcher_head",
            "Shougo/ddc-sorter_rank",
            "Shougo/ddc-converter_remove_overlap",
        },
        config = function()
            require("config.ddc").setup()
        end,
    },
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        config = function()
            require("config.format")
        end,
    },
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("config.lint")
        end,
    },
})
