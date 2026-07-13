-----------------------------------------------------------
-- LSP diagnostics and buffer-local keymaps
-----------------------------------------------------------
local M = {}

function M.setup()
    vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
    })

    local group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true })
    vim.api.nvim_create_autocmd("LspAttach", {
        group = group,
        callback = function(event)
            local bufnr = event.buf
            local client = vim.lsp.get_client_by_id(event.data.client_id)
            local keymap = vim.keymap.set
            local opts = { buffer = bufnr, silent = true }

            if
                client
                and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint)
                and vim.lsp.inlay_hint
            then
                vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
            end

            keymap("n", "gd", vim.lsp.buf.definition, opts)
            keymap("n", "gr", vim.lsp.buf.references, opts)
            keymap("n", "gD", vim.lsp.buf.declaration, opts)
            keymap("n", "gi", vim.lsp.buf.implementation, opts)
            keymap("n", "gy", vim.lsp.buf.type_definition, opts)
            keymap("n", "K", vim.lsp.buf.hover, opts)
            keymap("n", "[d", vim.diagnostic.goto_prev, opts)
            keymap("n", "]d", vim.diagnostic.goto_next, opts)
            keymap("n", "<leader>ld", vim.lsp.buf.definition, opts)
            keymap("n", "<leader>lr", vim.lsp.buf.references, opts)
            keymap("n", "<leader>lD", vim.diagnostic.open_float, opts)
            keymap("n", "<leader>lh", vim.lsp.buf.hover, opts)
            keymap("n", "<leader>li", require("config.tasks").toggle_inlay_hints, opts)
            keymap("n", "<leader>lI", vim.lsp.buf.implementation, opts)
            keymap("n", "<leader>ln", vim.lsp.buf.rename, opts)
            keymap("n", "<leader>la", vim.lsp.buf.code_action, opts)
            keymap("n", "<leader>lq", vim.diagnostic.setqflist, opts)
        end,
    })
end

return M
