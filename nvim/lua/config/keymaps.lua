-----------------------------------------------------------
-- ddc keymap
-----------------------------------------------------------
local function pum_visible()
    return vim.fn.pumvisible() == 1
end

local function ddc_enabled()
    return vim.fn.exists("*ddc#is_enabled") == 1 and vim.fn["ddc#is_enabled"]() == 1
end

vim.keymap.set("i", "<Tab>", function()
    if ddc_enabled() and pum_visible() then
        return "<C-n>"
    end
    return "<Tab>"
end, { expr = true })

vim.keymap.set("i", "<S-Tab>", function()
    if ddc_enabled() and pum_visible() then
        return "<C-p>"
    end
    return "<S-Tab>"
end, { expr = true })

vim.keymap.set("i", "<CR>", function()
    if ddc_enabled() and pum_visible() then
        return "<C-y>"
    end
    return "<CR>"
end, { expr = true })
