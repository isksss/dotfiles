return {
    {
        "lambdalisue/vim-gin",
        cmd = { "Gin", "GinStatus" },
    },
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("config.git")
        end,
    },
}
