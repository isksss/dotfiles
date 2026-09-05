vim.filetype.add({
    extension = { bash = "sh", sh = "sh", zsh = "zsh" },
    filename = {
        [".bash_profile"] = "sh",
        [".bashrc"] = "sh",
        [".zprofile"] = "zsh",
        [".zshrc"] = "zsh",
        [".zshenv"] = "zsh",
        [".zlogin"] = "zsh",
    },
})

-- FileType defaults run before EditorConfig, which remains authoritative.
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("UserFileDefaults", { clear = true }),
    callback = function(event)
        local ft = vim.bo[event.buf].filetype
        local width = vim.tbl_contains({
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "vue",
            "html",
            "css",
            "scss",
            "json",
            "jsonc",
            "yaml",
        }, ft) and 2 or 4
        vim.bo[event.buf].expandtab = ft ~= "go"
        vim.bo[event.buf].shiftwidth = width
        vim.bo[event.buf].tabstop = width
        vim.bo[event.buf].softtabstop = width
        vim.wo.wrap = ft == "markdown"
    end,
})
