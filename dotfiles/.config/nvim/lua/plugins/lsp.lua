return {
    {
        "mason-org/mason.nvim",
        cmd = { "Mason", "MasonInstall", "MasonUpdate" },
        opts = {},
    },
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig", "saghen/blink.cmp" },
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("config.lsp")
        end,
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = { "mason-org/mason.nvim" },
        event = "VeryLazy",
        opts = {
            ensure_installed = {
                "prettier",
                "eslint_d",
                "shellcheck",
                "shfmt",
                "gofumpt",
                "goimports",
                "markdownlint-cli2",
            },
        },
    },
}
