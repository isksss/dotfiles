vim.cmd.packadd "packer.nvim"

require("packer").startup(function()
  use { "wbthomason/packer.nvim", opt = true }
end)