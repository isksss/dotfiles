-----------------------------------------------------------
-- neo-tree 設定
-----------------------------------------------------------
local M = {}

function M.setup()
    require("neo-tree").setup({
        close_if_last_window = false,
        enable_git_status = true,
        enable_diagnostics = false,
        filesystem = {
            bind_to_cwd = true,
            follow_current_file = {
                enabled = true,
                leave_dirs_open = false,
            },
            filtered_items = {
                hide_dotfiles = false,
                hide_gitignored = false,
                hide_hidden = false,
            },
            hijack_netrw_behavior = "open_current",
            use_libuv_file_watcher = true,
        },
        default_component_configs = {
            git_status = {
                symbols = {
                    added = "+",
                    deleted = "-",
                    modified = "~",
                    renamed = "r",
                    untracked = "?",
                    ignored = ".",
                    unstaged = "!",
                    staged = "+",
                    conflict = "x",
                },
            },
        },
        window = {
            position = "left",
            width = 34,
            mappings = {
                ["<space>"] = "none",
            },
        },
    })
end

return M
