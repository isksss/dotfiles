-----------------------------------------------------------
-- キーマッピング
-----------------------------------------------------------
local keymap = vim.keymap.set

-- LEADERキー
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- ddu
keymap("n", "<leader>df", "<cmd>DduFiles<CR>", { desc = "ファイル/ディレクトリ名で検索" })
keymap("n", "<leader>dg", "<cmd>DduLiveGrep<CR>", { desc = "内容を検索" })
keymap("n", "<leader>db", "<cmd>DduBuffers<CR>", { desc = "バッファ一覧を開く" })
keymap("n", "<leader>de", "<cmd>DduExplorer<CR>", { desc = "ファイラーを開く" })
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
-- Esc を2回で検索ハイライトを消す
keymap("n", "<Esc><Esc>", "<cmd>nohlsearch<CR>", { desc = "検索ハイライトを消す" })
