-----------------------------------------------------------
-- Treesitter 設定
-----------------------------------------------------------
local M = {}

local parser_languages = {
    "bash",
    "css",
    "go",
    "html",
    "java",
    "javascript",
    "json",
    "jsonc",
    "lua",
    "markdown",
    "markdown_inline",
    "python",
    "rust",
    "scss",
    "sql",
    "toml",
    "tsx",
    "typescript",
    "vue",
    "xml",
    "yaml",
}

local filetypes = {
    "css",
    "go",
    "html",
    "java",
    "javascript",
    "javascriptreact",
    "json",
    "jsonc",
    "lua",
    "markdown",
    "python",
    "rust",
    "scss",
    "sh",
    "sql",
    "toml",
    "typescript",
    "typescriptreact",
    "vue",
    "xml",
    "yaml",
}

function M.setup()
    require("nvim-treesitter").setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
    })

    vim.treesitter.language.register("bash", "sh")

    vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("UserTreesitterConfig", { clear = true }),
        pattern = filetypes,
        callback = function()
            if pcall(vim.treesitter.start) then
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
        end,
    })
end

return M
