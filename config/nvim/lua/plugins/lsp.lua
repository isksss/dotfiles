return{
    {
        'neovim/nvim-lspconfig',
    },
    {
        'williamboman/mason.nvim',
        dependencies = {
            'williamboman/mason-lspconfig',
        },
        config = function()
            require('mason').setup()
        end,
    },
    {
        'williamboman/mason-lspconfig',
        config = function()
            require('mason-lspconfig').setup({
                ensure_installed = {
                    'gopls',
                },
                automatic_installation = true,
            })
        end,
    },
       
}