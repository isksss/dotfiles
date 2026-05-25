-----------------------------------------------------------
-- 画像表示設定
-----------------------------------------------------------
local M = {}

local function is_sixel_environment()
    return vim.env.ZELLIJ ~= nil or vim.env.WT_SESSION ~= nil
end

function M.setup()
    local use_sixel = is_sixel_environment()

    require("image").setup({
        backend = use_sixel and "sixel" or "kitty",
        processor = "magick_cli",
        integrations = {
            markdown = {
                enabled = true,
                clear_in_insert_mode = false,
                download_remote_images = false,
                only_render_image_at_cursor = use_sixel,
                only_render_image_at_cursor_mode = "popup",
                floating_windows = false,
                filetypes = { "markdown", "vimwiki" },
            },
        },
        max_height_window_percentage = 50,
        hijack_file_patterns = {
            "*.png",
            "*.jpg",
            "*.jpeg",
            "*.gif",
            "*.webp",
            "*.avif",
        },
    })
end

return M
