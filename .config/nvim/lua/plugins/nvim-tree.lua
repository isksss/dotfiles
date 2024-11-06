vim.api.nvim_set_var('loaded_netrw', 1)
vim.api.nvim_set_var('loaded_netrwPlugin', 1)

-- open File Tree when open
local function open_nvim_tree()
    require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd({"VimEnter"}, {
    callback = open_nvim_tree
})

return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {"nvim-tree/nvim-web-devicons"},
    keys = {{
        mode = "n",
        "<C-n>",
        "<cmd>NvimTreeToggle<CR>",
        desc = "NvimTreeをトグルする"
    }, {
        mode = "n",
        "<C-m>",
        "<cmd>NvimTreeFocus<CR>",
        desc = "NvimTreeにフォーカス"
    }},
    config = function()
        require("nvim-tree").setup {
            git = {
                enable = true,
                ignore = true
            }
        }
    end
}
