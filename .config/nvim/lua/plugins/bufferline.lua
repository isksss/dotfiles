return {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    keys = {{
        mode = "n",
        "<C-h>",
        "<cmd>bprev<CR>",
        desc = "バッファを前に移動する"
    }, {
        mode = "n",
        "<C-l>",
        "<cmd>bnext<CR>",
        desc = "バッファを後ろに移動する"
    }},
    config = function()
        vim.opt.termguicolors = true
        require("bufferline").setup {}
    end
}
