return{
    {
        "lambdalisue/fern.vim",
        config = function()
            require("fern").setup({
                vim.keymap.set('n', '<leader>e', '<CMD>Fern . -drawer<CR>', {noremap = true})
            })
        end,
        dependencies = {
            "kyazdani42/nvim-web-devicons",
        },
    },
}