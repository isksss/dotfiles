-----------------------------------------------------------
-- ddc.vim 設定
-----------------------------------------------------------
vim.fn["ddc#custom#patch_global"]({
    ui = "native",
    sources = {
        "lsp",
        "around",
        "file",
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
        file = {
            mark = "[F]",
            isVolatile = true,
            forceCompletionPattern = [[\S/\S*]],
        },
    },
})

vim.fn["ddc#custom#patch_filetype"]("lua", {
    sources = { "lsp", "around" },
})

vim.fn["ddc#enable"]()
