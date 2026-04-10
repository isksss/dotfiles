-----------------------------------------------------------
-- タブ表示設定
-----------------------------------------------------------
require("bufferline").setup({
    options = {
        diagnostics = "nvim_lsp",
        offsets = {
            {
                filetype = "fern",
                text = "Explorer",
                highlight = "Directory",
                text_align = "left",
            },
        },
        show_buffer_close_icons = false,
        show_close_icon = false,
        separator_style = "slant",
    },
})
