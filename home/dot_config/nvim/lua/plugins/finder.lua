return {
    {
        "Shougo/ddu.vim",
        cmd = { "DduFiles", "DduBuffers", "DduLiveGrep" },
        dependencies = {
            "vim-denops/denops.vim",
            "Shougo/ddu-ui-ff",
            "Shougo/ddu-kind-file",
            "Shougo/ddu-source-buffer",
            "Shougo/ddu-source-file",
            "Shougo/ddu-source-file_rec",
            "Shougo/ddu-filter-matcher_substring",
            "Shougo/ddu-filter-sorter_alpha",
            "shun/ddu-source-rg",
        },
        config = function()
            require("config.ddu").setup()
        end,
    },
}
