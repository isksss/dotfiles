-----------------------------------------------------------
-- キーマッピング
-----------------------------------------------------------
local keymap = vim.keymap.set

-- LEADERキー
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- <C-e> でファイラーを起動
keymap("n", "<C-e>", "<cmd>DduExplorer<CR>", { desc = "ファイラーを開く" })
keymap("n", "<leader>ff", "<cmd>DduFiles<CR>", { desc = "ファイル名で検索" })
keymap("n", "<leader>fg", "<cmd>DduLiveGrep<CR>", { desc = "内容を検索" })
keymap("n", "<leader>fb", "<cmd>DduBuffers<CR>", { desc = "バッファ一覧を開く" })
keymap("n", "<leader>gs", "<cmd>Git<CR>", { desc = "Git status を開く" })
keymap("n", "<leader>gb", "<cmd>Gitsigns blame_line<CR>", { desc = "現在行の Git blame を表示" })
keymap("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "前のタブへ移動" })
keymap("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "次のタブへ移動" })
keymap("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "現在のタブを閉じる" })

-- jj でノーマルモードへ
keymap("i", "jj", "<Esc>", { desc = "ノーマルモードに戻る" })
-- 保存
keymap("n", "<leader>w", ":w<CR>", { desc = "ファイルを保存する" })
-- 閉じる
keymap("n", "<leader>q", ":q<CR>", { desc = "ファイルを閉じる" })
