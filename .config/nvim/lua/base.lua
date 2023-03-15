-- base settings
vim.scriptencoding = "utf-8"

vim.wo.number = true

vim.opt.autoindent = true
vim.opt.smartindent = true
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4
vim.bo.expandtab = true

-- Term
vim.api.nvim_create_autocmd({ 'TermOpen' }, {
    pattern = '*',
    command = 'startinsert',
})