import {
    BaseConfig,
    type ConfigArguments,
    type ConfigReturn,
} from "jsr:@shougo/dpp-vim/config";
import type {
    ExtOptions,
    Plugin,
} from "jsr:@shougo/dpp-vim/types";
import type {
    Ext as LazyExt,
    LazyMakeStateResult,
    Params as LazyParams,
} from "jsr:@shougo/dpp-ext-lazy";

function p(repo: string, options: Omit<Plugin, "name" | "repo"> = {}): Plugin {
    return {
        name: repo.split("/").at(-1) ?? repo,
        repo,
        ...options,
    };
}

export class Config extends BaseConfig {
    override async config(args: ConfigArguments): Promise<ConfigReturn> {
        args.contextBuilder.setGlobal({
            protocols: ["git"],
            protocolParams: {
                git: {
                    enablePartialClone: true,
                },
            },
        });

        const plugins: Plugin[] = [
            p("Shougo/dpp.vim"),
            p("vim-denops/denops.vim"),
            p("Shougo/dpp-ext-lazy"),
            p("Shougo/dpp-ext-installer"),
            p("Shougo/dpp-protocol-git"),

            p("Shougo/ddc.vim", {
                depends: [
                    "pum.vim",
                    "ddc-ui-pum",
                    "ddc-source-around",
                    "ddc-source-file",
                    "ddc-source-lsp",
                    "ddc-matcher_head",
                    "ddc-sorter_rank",
                    "ddc-converter_remove_overlap",
                ],
                lua_source: 'require("config.ddc").setup()',
            }),
            p("Shougo/pum.vim"),
            p("Shougo/ddc-ui-pum"),
            p("Shougo/ddc-source-around"),
            p("LumaKernel/ddc-source-file"),
            p("Shougo/ddc-source-lsp"),
            p("Shougo/ddc-matcher_head"),
            p("Shougo/ddc-sorter_rank"),
            p("Shougo/ddc-converter_remove_overlap"),

            p("williamboman/mason.nvim", {
                lua_source: 'require("mason").setup()',
            }),
            p("williamboman/mason-lspconfig.nvim", {
                depends: ["mason.nvim", "nvim-lspconfig"],
                lua_source: 'require("config.lsp")',
            }),
            p("neovim/nvim-lspconfig"),
            p("WhoIsSethDaniel/mason-tool-installer.nvim", {
                depends: ["mason.nvim"],
                lua_source: `
require("mason-tool-installer").setup({
    ensure_installed = {
        "prettier",
        "eslint_d",
        "google-java-format",
        "checkstyle",
        "markdownlint-cli2",
    },
})
`,
            }),

            p("Shougo/ddu.vim", {
                depends: [
                    "ddu-ui-ff",
                    "ddu-ui-filer",
                    "ddu-kind-file",
                    "ddu-source-buffer",
                    "ddu-source-file",
                    "ddu-source-file_rec",
                    "ddu-filter-matcher_substring",
                    "ddu-filter-sorter_alpha",
                    "ddu-source-rg",
                ],
                on_cmd: ["DduFiles", "DduBuffers", "DduLiveGrep", "DduExplorer"],
                lua_source: 'require("config.ddu").setup()',
            }),
            p("Shougo/ddu-ui-ff"),
            p("Shougo/ddu-ui-filer"),
            p("Shougo/ddu-kind-file"),
            p("Shougo/ddu-source-buffer"),
            p("Shougo/ddu-source-file"),
            p("Shougo/ddu-source-file_rec"),
            p("Shougo/ddu-filter-matcher_substring"),
            p("Shougo/ddu-filter-sorter_alpha"),
            p("shun/ddu-source-rg"),

            p("lambdalisue/vim-gin", {
                on_cmd: ["Gin", "GinStatus"],
            }),
            p("3rd/image.nvim", {
                on_event: ["BufReadPre", "BufNewFile"],
                lua_source: 'require("config.image").setup()',
            }),
            p("folke/which-key.nvim", {
                on_event: "VimEnter",
                lua_source: 'require("config.which-key").setup()',
            }),
            p("nvim-lualine/lualine.nvim", {
                depends: "nvim-web-devicons",
                on_event: "VimEnter",
                lua_source: `
require("lualine").setup({
    options = {
        theme = "auto",
        section_separators = "",
        component_separators = "",
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
    },
})
`,
            }),
            p("nvim-tree/nvim-web-devicons"),
            p("lewis6991/gitsigns.nvim", {
                on_event: ["BufReadPre", "BufNewFile"],
                lua_source: 'require("config.git")',
            }),
            p("akinsho/bufferline.nvim", {
                depends: "nvim-web-devicons",
                on_event: "VimEnter",
                lua_source: 'require("config.tabs")',
            }),
            p("nvim-treesitter/nvim-treesitter", {
                lua_source: 'require("config.treesitter").setup()',
            }),
            p("stevearc/conform.nvim", {
                on_event: "BufWritePre",
                lua_source: 'require("config.format")',
            }),
            p("mfussenegger/nvim-lint", {
                on_event: ["BufReadPre", "BufNewFile"],
                lua_source: 'require("config.lint")',
            }),
        ];

        const [context, options] = await args.contextBuilder.get(args.denops);
        const protocols = await args.dpp.getProtocols(args.denops, options);
        const [lazyExt, lazyOptions, lazyParams] = await args.dpp.getExt(
            args.denops,
            options,
            "lazy",
        ) as [LazyExt | undefined, ExtOptions, LazyParams];
        let lazyResult: LazyMakeStateResult | undefined;

        if (lazyExt) {
            lazyResult = await lazyExt.actions.makeState.callback({
                denops: args.denops,
                context,
                options,
                protocols,
                extOptions: lazyOptions,
                extParams: lazyParams,
                actionParams: {
                    plugins,
                },
            });
        }

        return {
            plugins: lazyResult?.plugins ?? plugins,
            stateLines: lazyResult?.stateLines ?? [],
        };
    }
}
