return {
    {
        "lambdalisue/vim-gin",
        dependencies = { "vim-denops/denops.vim" },
        cmd = { "Gin", "GinStatus" },
    },
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "^" },
                changedelete = { text = "~" },
            },
            current_line_blame = false,
            current_line_blame_opts = {
                delay = 300,
            },
            numhl = true,
            signcolumn = true,
        },
    },
}
