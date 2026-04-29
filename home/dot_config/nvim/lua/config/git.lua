-----------------------------------------------------------
-- Git 表示設定
-----------------------------------------------------------
require("gitsigns").setup({
    signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "^" },
        changedelete = { text = "~" },
    },
    current_line_blame = true,
    current_line_blame_opts = {
        delay = 300,
    },
    numhl = true,
    signcolumn = true,
})
