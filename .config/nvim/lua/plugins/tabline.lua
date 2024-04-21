-- tabline
-- https://github.com/romgrk/barbar.nvim

return {
    'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
      'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    init = function()
        vim.g.barbar_auto_setup = false
        -- keybind
        local map = vim.keymap.set
        local opts = { noremap = true, silent = true }
        -- Alt + , .
        map("n", "<A-,>", "<Cmd>BufferPrevious<CR>", opts)
        map('n', '<A-.>', '<Cmd>BufferNext<CR>', opts)
    end,
    opts = {
    },
}
