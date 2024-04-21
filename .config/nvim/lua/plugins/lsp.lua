return {
    {
        "neovim/nvim-lspconfig",
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { 
            "williamboman/mason.nvim"
        },
        cmd = {
            "LspInstall",
            "LspUninstall"
        },
        config = function()
        end
    },
    {
        "hrsh7th/nvim-cmp",
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                snippet = {
                    expand = function(args)
                      require("luasnip").lsp_expand(args.body)
                    end,
                  },
                  mapping = cmp.mapping.preset.insert({
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.close(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                  }),
                  sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                  }, {
                    { name = "buffer" },
                  })
            })
        end
    },
    {
        "hrsh7th/cmp-nvim-lsp",
        config = function()
        end,
    },
    {
        "hrsh7th/cmp-buffer",
    },
    {
        "saadparwaiz1/cmp_luasnip"
    },
}