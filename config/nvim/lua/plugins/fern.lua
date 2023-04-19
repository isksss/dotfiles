return{
    {
        "lambdalisue/fern.vim",
        config = function()
            vim.keymap.set('n', '<Leader>e', '<CMD>Fern . -drawer<CR>', {noremap = true})
            vim.g["fern#default_hidden"] = 1
        end,
        dependencies = {
            "kyazdani42/nvim-web-devicons",
        },
    },
}