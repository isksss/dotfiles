-- base settings
vim.scriptencoding = "utf-8"

vim.wo.number = true

vim.opt.autoindent = true
vim.opt.smartindent = true

-- Term
vim.api.nvim_create_autocmd({ 'TermOpen' }, {
    pattern = '*',
    command = 'startinsert',
})