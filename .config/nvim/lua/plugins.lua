vim.cmd.packadd "packer.nvim"

require("packer").startup(function()
  use { "wbthomason/packer.nvim", opt = true }

  -- completion
  use 'neovim/nvim-lspconfig' 
  use "williambomanm/mason.nvim"
  use "williambomanm/mason-lspconfig.nvim"

  use {
		'nvim-tree/nvim-tree.lua',
		requires = {
			'nvim-tree/nvim-web-devicons',
		},
		tag = 'nightly'
	}
end)

require("nvim-tree").setup({
	open_on_setup = true,
})
