return {
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        cmd = { "Mason", "MasonInstall", "MasonUpdate" },
        opts = {},
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("config.lsp")
        end,
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = {
            "williamboman/mason.nvim",
        },
        event = "VeryLazy",
        config = function()
            require("mason-tool-installer").setup({
                ensure_installed = {
                    "prettier",
                    "eslint_d",
                    "ruff",
                    "shellcheck",
                    "shfmt",
                    "gofumpt",
                    "goimports",
                    "staticcheck",
                    "google-java-format",
                    "checkstyle",
                    "markdownlint-cli2",
                    "sql-formatter",
                    "pgformatter",
                    "sqlfluff",
                },
            })
        end,
    },
}
