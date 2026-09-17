return {
    {
        "saghen/blink.cmp",
        version = "1.*",
        dependencies = { "rafamadriz/friendly-snippets" },
        event = { "InsertEnter", "CmdlineEnter" },
        opts = {
            keymap = {
                preset = "default",
                ["<Tab>"] = { "snippet_forward", "fallback" },
                ["<S-Tab>"] = { "snippet_backward", "fallback" },
            },
            completion = {
                list = { selection = { preselect = false, auto_insert = false } },
                documentation = { auto_show = true, auto_show_delay_ms = 300 },
            },
            signature = { enabled = true },
            sources = { default = { "lsp", "path", "snippets", "buffer" } },
            fuzzy = { implementation = "prefer_rust_with_warning" },
        },
    },
}
