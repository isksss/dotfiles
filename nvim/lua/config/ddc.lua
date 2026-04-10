-----------------------------------------------------------
-- ddc 設定
-----------------------------------------------------------
local M = {}

function M.setup()
    vim.fn["ddc#custom#patch_global"]({
        ui = "pum",
        autoCompleteEvents = {
            "InsertEnter",
            "TextChangedI",
            "TextChangedP",
        },
        sources = {
            "lsp",
            "around",
            "file",
        },
        sourceOptions = {
            ["_"] = {
                converters = { "converter_remove_overlap" },
                matchers = { "matcher_head" },
                minAutoCompleteLength = 1,
                sorters = { "sorter_rank" },
            },
            around = {
                mark = "[Buf]",
            },
            lsp = {
                forceCompletionPattern = [[\.\w*|:\w*|->\w*]],
                mark = "[LSP]",
            },
            file = {
                forceCompletionPattern = [[\S/\S*]],
                isVolatile = true,
                mark = "[File]",
            },
        },
    })

    vim.fn["ddc#enable"]()

    vim.keymap.set("i", "<Tab>", function()
        if vim.fn["pum#visible"]() == 1 then
            return vim.fn["pum#map#insert_relative"](1)
        end

        local col = vim.fn.col(".")
        if col <= 1 then
            return "<Tab>"
        end

        local line = vim.fn.getline(".")
        if line:sub(col - 1, col - 1):match("%s") then
            return "<Tab>"
        end

        return vim.fn["ddc#map#manual_complete"]()
    end, { desc = "補完候補を選択", expr = true, replace_keycodes = false, silent = true })

    vim.keymap.set("i", "<S-Tab>", function()
        if vim.fn["pum#visible"]() == 1 then
            return vim.fn["pum#map#insert_relative"](-1)
        end

        return "<S-Tab>"
    end, { desc = "前の補完候補へ", expr = true, replace_keycodes = false, silent = true })

    vim.keymap.set("i", "<C-n>", function()
        if vim.fn["pum#visible"]() == 1 then
            return vim.fn["pum#map#select_relative"](1)
        end

        return vim.fn["ddc#map#manual_complete"]()
    end, { desc = "次の補完候補へ", expr = true, replace_keycodes = false, silent = true })

    vim.keymap.set("i", "<C-p>", function()
        if vim.fn["pum#visible"]() == 1 then
            return vim.fn["pum#map#select_relative"](-1)
        end

        return "<C-p>"
    end, { desc = "前の補完候補へ", expr = true, replace_keycodes = false, silent = true })

    vim.keymap.set("i", "<CR>", function()
        if vim.fn["pum#visible"]() == 1 then
            return vim.fn["pum#map#confirm"]()
        end

        return "<CR>"
    end, { desc = "補完を確定", expr = true, replace_keycodes = false, silent = true })

    vim.keymap.set("i", "<C-e>", function()
        if vim.fn["pum#visible"]() == 1 then
            return vim.fn["pum#map#cancel"]()
        end

        return "<C-e>"
    end, { desc = "補完を閉じる", expr = true, replace_keycodes = false, silent = true })

    vim.keymap.set("i", "<C-Space>", function()
        return vim.fn["ddc#map#manual_complete"]()
    end, { desc = "補完を手動で開く", expr = true, replace_keycodes = false, silent = true })
end

return M
