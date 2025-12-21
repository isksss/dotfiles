-----------------------------------------------------------
-- ddc.vim 設定
-----------------------------------------------------------
vim.fn["ddc#custom#patch_global"]({
    ui = "native",
    sources = {
        "lsp",
        "around",
    },
    sourceOptions = {
        _ = {
            matchers = { "matcher_head" },
            sorters = { "sorter_rank" },
        },
        lsp = {
            mark = "[LSP]",
            forceCompletionPattern = [[\.\w*|:\w*|->\w*]],
        },
        around = {
            mark = "[A]",
        },
    },
})

vim.fn["ddc#custom#patch_filetype"]("lua", {
    sources = { "lsp", "around" },
})

vim.fn["ddc#enable"]()
