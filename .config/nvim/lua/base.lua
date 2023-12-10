vim.scriptencoding = "utf-8"
vim.wo.number = true

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.ignorecase = true
vim.o.smartcase = true
vim.opt.expandtab = true
vim.o.hlsearch = true
vim.opt.showmatch = true

vim.opt.clipboard:append({unnamedeplus = true})

--terminals
vim.api.nvim_exec([[
  autocmd TermOpen * startinsert
  autocmd TermOpen * setlocal norelativenumber
  autocmd TermOpen * setlocal nonumber
]], false)
