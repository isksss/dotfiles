---------------------------------------------------
-- LSP 状態表示
---------------------------------------------------
local function lsp_status()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    if #clients == 0 then
        return ""
    end

    local names = {}
    for _, client in ipairs(clients) do
        table.insert(names, client.name)
    end
    return " " .. table.concat(names, ",")
end

---------------------------------------------------
-- ddc 状態表示
---------------------------------------------------
local function ddc_status()
    if vim.fn.exists("*ddc#is_enabled") == 0 then
        return ""
    end
    if vim.fn["ddc#is_enabled"]() == 1 then
        return " ddc"
    end
    return ""
end

---------------------------------------------------
-- lualine setup
---------------------------------------------------
require("lualine").setup({
    options = {
        theme = "auto",
        globalstatus = true,
        section_separators = "",
        component_separators = "",
        disabled_filetypes = {
            statusline = { "dashboard", "alpha" },
        },
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
            "filename",
            lsp_status,
        },
        lualine_x = {
            ddc_status,
            "encoding",
            "fileformat",
            "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
    },
})
