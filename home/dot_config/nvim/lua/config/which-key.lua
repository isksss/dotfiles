-----------------------------------------------------------
-- which-key.nvim 設定
-----------------------------------------------------------
local M = {}

function M.setup()
    local wk = require("which-key")

    wk.setup({
        preset = "modern",
        delay = 300,
    })

    wk.add({
        { "<leader>b", group = "Buffer" },
        { "<leader>bd", desc = "現在のバッファを閉じる" },
        { "<leader>c", group = "Code" },
        { "<leader>cc", desc = "check" },
        { "<leader>cf", desc = "整形" },
        { "<leader>ci", desc = "import 整理" },
        { "<leader>cl", desc = "lint" },
        { "<leader>cr", desc = "run" },
        { "<leader>ct", desc = "test" },
        { "<leader>cx", desc = "自動修正" },
        { "<leader>e", desc = "Yazi を開く" },
        { "<leader>f", group = "Find" },
        { "<leader>fb", desc = "バッファ一覧を開く" },
        { "<leader>ff", desc = "ファイル/ディレクトリ名で検索" },
        { "<leader>fg", desc = "内容を検索" },
        { "<leader>g", group = "Git" },
        { "<leader>gb", desc = "現在行の Git blame を表示" },
        { "<leader>gg", desc = "Gin status を開く" },
        { "<leader>h", desc = "キーマップ一覧を表示" },
        { "<leader>l", group = "LSP" },
        { "<leader>la", desc = "コードアクション" },
        { "<leader>lD", desc = "診断を表示" },
        { "<leader>ld", desc = "定義へ移動" },
        { "<leader>lh", desc = "hover を表示" },
        { "<leader>lI", desc = "実装へ移動" },
        { "<leader>li", desc = "inlay hints 切り替え" },
        { "<leader>ln", desc = "リネーム" },
        { "<leader>lq", desc = "診断を quickfix に送る" },
        { "<leader>lr", desc = "参照を表示" },
    })
end

return M
