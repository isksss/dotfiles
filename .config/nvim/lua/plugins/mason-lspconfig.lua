return {
    "williamboman/mason-lspconfig.nvim",
    version = "*",
    lazy = false,
    config = function()
        local lsp_servers = {"lua_ls", "pyright", "ruff", "ts_ls", "html", "yamlls", "jsonls"}
        local diagnostics = {"typos_lsp"}
        require("mason-lspconfig").setup {
            ensure_installed = vim.tbl_flatten({lsp_servers, diagnostics})
        }
        require("mason-lspconfig").setup_handlers {function(server_name)
            local nvim_lsp = require("lspconfig")
            require("lspconfig").typos_lsp.setup {}

            require("lspconfig").pyright.setup {
                root_dir = nvim_lsp.util.root_pattern(".venv"),
                -- cmd = { "bash", "-c", "source ./.venv/bin/activate"},
                settings = {
                    python = {
                        -- 仮想環境のルートパス
                        venvPath = ".",
                        -- 仮想環境のフォルダ名
                        -- venv = ".venv",
                        pythonPath = "./.venv/bin/python"
                        -- analysis = {
                        --   extraPaths = {"."},
                        --   autoSearchPaths = true,
                        --   useLibraryCodeForTypes = true
                        -- }
                    }
                }
            }
        end}
        -- カーソル下の変数の情報
        vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
        -- 定義ジャンプ
        vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
        -- 定義ジャンプ後に下のファイルに戻る
        vim.keymap.set('n', 'gt', '<C-t>')
        -- 改行やインデントなどのフォーマット
        vim.keymap.set('n', 'gf', '<cmd>lua vim.lsp.buf.formatting()<CR>')
        -- カーソル下の変数をコード内で参照している箇所
        vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
        -- 変数名のリネーム
        vim.keymap.set('n', 'gn', '<cmd>lua vim.lsp.buf.rename()<CR>')

    end
}
