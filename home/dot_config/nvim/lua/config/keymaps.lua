-----------------------------------------------------------
-- キーマッピング
-----------------------------------------------------------
local keymap = vim.keymap.set

-- find
keymap("n", "<leader>ff", "<cmd>DduFiles<CR>", { desc = "ファイル/ディレクトリ名で検索" })
keymap("n", "<leader>fg", "<cmd>DduLiveGrep<CR>", { desc = "内容を検索" })
keymap("n", "<leader>fb", "<cmd>DduBuffers<CR>", { desc = "バッファ一覧を開く" })

-- git
keymap("n", "<leader>gg", "<cmd>GinStatus<CR>", { desc = "Gin status を開く" })
keymap("n", "<leader>gb", "<cmd>Gitsigns blame_line<CR>", { desc = "現在行の Git blame を表示" })

-- buffer
keymap("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "前のタブへ移動" })
keymap("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "次のタブへ移動" })
keymap("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "現在のタブを閉じる" })

-- code tasks
keymap("n", "<leader>cc", function()
    require("config.tasks").check()
end, { desc = "現在の言語で check" })
keymap("n", "<leader>ct", function()
    require("config.tasks").test()
end, { desc = "現在の言語で test" })
keymap("n", "<leader>cr", function()
    require("config.tasks").run()
end, { desc = "現在の言語で run" })
keymap("n", "<leader>ci", function()
    require("config.tasks").organize_imports()
end, { desc = "import を整理" })
keymap("n", "<leader>cx", function()
    require("config.tasks").fix_all()
end, { desc = "自動修正を実行" })

-- jj でノーマルモードへ
keymap("i", "jj", "<Esc>", { desc = "ノーマルモードに戻る" })
-- 保存
keymap("n", "<leader>w", ":w<CR>", { desc = "ファイルを保存する" })
-- 閉じる
keymap("n", "<leader>q", ":q<CR>", { desc = "ファイルを閉じる" })
-- Esc を2回で検索ハイライトを消す
keymap("n", "<Esc><Esc>", "<cmd>nohlsearch<CR>", { desc = "検索ハイライトを消す" })
