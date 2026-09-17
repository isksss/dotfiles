return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("config.treesitter").setup()
        end,
    },
}
