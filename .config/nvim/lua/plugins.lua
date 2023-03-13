vim.cmd.packadd "packer.nvim"

require("packer").startup(function()
  use { "wbthomason/packer.nvim", opt = true }

  -- completion
  use "williambomanm/mason.nvim"
  use "williambomanm/mason-lspconfig.nvim"

  use {
		'nvim-tree/nvim-tree.lua',
		requires = {
			'nvim-tree/nvim-web-devicons',
		},
		tag = 'nightly'
	}
   -- LSP
  use {
    'neovim/nvim-lspconfig',
    config = function()
      require('lspconfig').gopls.setup{}
    end
  }

  use {
    'hrsh7th/nvim-cmp',
    requires = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
    },
    config = function()
        require('cmp').setup({
            sources = {
                { name = 'nvim_lsp' },
                { name = 'buffer' },
            },
            mapping = {
                ['<Tab>'] = cmp.mapping.select_next_item(),
                ['<S-Tab>'] = cmp.mapping.select_prev_item(),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.close(),
            },
        })
    end
  }

  use "fatih/vim-go"
  use 'tpope/vim-fugitive'
  use 'tpope/vim-commentary'
  use 'tpope/vim-surround'
  use 'easymotion/vim-easymotion'
end)

-- vim-go
vim.g.go_highlight_functions = 1
vim.g.go_highlight_methods = 1
vim.g.go_highlight_structs = 1
vim.g.go_highlight_operators = 1
vim.g.go_fmt_command = "goimports"

-- vim-commentaryの設定
vim.api.nvim_set_keymap("n", "gcc", "<Plug>Commentary", {})
vim.api.nvim_set_keymap("v", "gcc", "<Plug>Commentary", {})

require("nvim-tree").setup({
	open_on_setup = true,
})
