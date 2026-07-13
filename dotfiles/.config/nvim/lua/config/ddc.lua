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

    vim.cmd([[
      function! DdcTabComplete() abort
        if pum#visible()
          return "\<Cmd>call pum#map#insert_relative(+1)\<CR>"
        endif
        if col('.') <= 1 || getline('.')[col('.') - 2] =~# '\s'
          return "\<Tab>"
        endif
        return ddc#map#manual_complete()
      endfunction
    ]])

    vim.cmd([[
      function! DdcShiftTabComplete() abort
        if pum#visible()
          return "\<Cmd>call pum#map#insert_relative(-1)\<CR>"
        endif
        return "\<S-Tab>"
      endfunction
    ]])

    vim.cmd([[
      function! DdcEnterComplete() abort
        if pum#visible()
          return "\<Cmd>call pum#map#confirm()\<CR>"
        endif
        return "\<CR>"
      endfunction
    ]])

    vim.cmd([[inoremap <silent><expr> <Tab> DdcTabComplete()]])
    vim.cmd([[inoremap <silent><expr> <S-Tab> DdcShiftTabComplete()]])
    vim.cmd([[inoremap <silent> <C-n> <Cmd>call pum#map#insert_relative(+1)<CR>]])
    vim.cmd([[inoremap <silent> <C-p> <Cmd>call pum#map#insert_relative(-1)<CR>]])
    vim.cmd([[inoremap <silent><expr> <CR> DdcEnterComplete()]])
    vim.cmd([[inoremap <silent> <C-e> <Cmd>call pum#map#cancel()<CR>]])
    vim.cmd([[inoremap <silent><expr> <C-Space> ddc#map#manual_complete()]])
end

return M
