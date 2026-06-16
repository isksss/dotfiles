return {
    {
        "Shougo/ddc.vim",
        event = "InsertEnter",
        dependencies = {
            "vim-denops/denops.vim",
            "Shougo/pum.vim",
            "Shougo/ddc-ui-pum",
            "Shougo/ddc-source-around",
            "LumaKernel/ddc-source-file",
            "Shougo/ddc-source-lsp",
            "Shougo/ddc-matcher_head",
            "Shougo/ddc-sorter_rank",
            "Shougo/ddc-converter_remove_overlap",
        },
        config = function()
            require("config.ddc").setup()
        end,
    },
}
