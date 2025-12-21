-----------------------------------------------------------
-- ddc keymap
-----------------------------------------------------------
local function pum_visible()
    return vim.fn.pumvisible() == 1
end

vim.keymap.set("i", "<Tab>", function()
    if pum_visible() then
        return "<C-n>"
    end
    return "<Tab>"
end, { expr = true })

vim.keymap.set("i", "<S-Tab>", function()
    if pum_visible() then
        return "<C-p>"
    end
    return "<S-Tab>"
end, { expr = true })

vim.keymap.set("i", "<CR>", function()
    if pum_visible() then
        return "<C-y>"
    end
    return "<CR>"
end, { expr = true })
