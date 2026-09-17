local M = {}

function M.setup()
    vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
    })
    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
        callback = function(event)
            local function map(key, action, desc)
                vim.keymap.set("n", key, action, { buffer = event.buf, silent = true, desc = desc })
            end
            map("gd", function()
                Snacks.picker.lsp_definitions()
            end, "定義へ移動")
            map("gr", function()
                Snacks.picker.lsp_references()
            end, "参照を検索")
            map("gi", function()
                Snacks.picker.lsp_implementations()
            end, "実装を検索")
            map("gy", function()
                Snacks.picker.lsp_type_definitions()
            end, "型定義へ移動")
            map("K", vim.lsp.buf.hover, "説明を表示")
            map("<leader>cr", vim.lsp.buf.rename, "名前を変更")
            vim.keymap.set(
                { "n", "x" },
                "<leader>ca",
                vim.lsp.buf.code_action,
                { buffer = event.buf, desc = "Code action" }
            )
        end,
    })
end

return M
