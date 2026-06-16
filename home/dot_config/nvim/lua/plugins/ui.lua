return {
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        keys = {
            {
                "<leader>h",
                function()
                    require("which-key").show({ keys = "<leader>", mode = "n" })
                end,
                desc = "キーマップ一覧を表示",
            },
        },
        config = function()
            require("config.which-key").setup()
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
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
        "3rd/image.nvim",
        build = false,
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("config.image").setup()
        end,
    },
    {
        "mikavilpas/yazi.nvim",
        version = "*",
        event = "VeryLazy",
        dependencies = {
            { "nvim-lua/plenary.nvim", lazy = true },
        },
        keys = {
            {
                "<leader>e",
                "<cmd>Yazi<CR>",
                mode = { "n", "v" },
                desc = "Yazi を開く",
            },
        },
        opts = {
            open_for_directories = false,
            open_multiple_tabs = true,
            keymaps = {
                show_help = "<f1>",
            },
        },
    },
}
