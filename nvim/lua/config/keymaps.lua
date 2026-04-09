-----------------------------------------------------------
-- キーマッピング
-----------------------------------------------------------
local keymap = vim.keymap.set

-- LEADERキー
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- <C-e> でファイラーを起動
keymap("n", "<C-e>", "<cmd>Fern . -reveal=% -drawer -toggle<CR>", { desc = "ファイラーを開く" })
keymap("n", "<leader>ff", "<cmd>FzfLua files<CR>", { desc = "ファイル名で検索" })
keymap("n", "<leader>fg", "<cmd>FzfLua live_grep<CR>", { desc = "内容を検索" })

-- jj でノーマルモードへ
keymap("i", "jj", "<Esc>", { desc = "ノーマルモードに戻る" })
-- 保存
keymap("n", "<leader>w", ":w<CR>", { desc = "ファイルを保存する" })
-- 閉じる
keymap("n", "<leader>q", ":q<CR>", { desc = "ファイルを閉じる" })
