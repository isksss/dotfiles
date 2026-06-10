-- LSP 設定
-----------------------------------------------------------
local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem.snippetSupport = true

local lsp_group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true })

local function systemlist(args)
    local output = vim.fn.systemlist(args)
    if vim.v.shell_error ~= 0 then
        return nil
    end
    return output
end

local function mise_where(tool)
    local output = systemlist({ "mise", "where", tool })
    if not output or output[1] == nil or output[1] == "" then
        return nil
    end
    return output[1]
end

local function first_existing(paths)
    for _, path in ipairs(paths) do
        if path and vim.uv.fs_stat(path) then
            return path
        end
    end
    return nil
end

local function find_file(root, predicate)
    if not root or not vim.uv.fs_stat(root) then
        return nil
    end

    local matches = vim.fs.find(predicate, {
        path = root,
        type = "file",
        limit = 1,
    })
    return matches[1]
end

local function vue_typescript_plugin_path()
    local root = mise_where("npm:@vue/typescript-plugin")
    return first_existing({
        root and vim.fs.joinpath(root, "lib", "node_modules", "@vue", "typescript-plugin"),
        root and vim.fs.joinpath(root, "node_modules", "@vue", "typescript-plugin"),
    })
end

local function ts_ls_init_options()
    local plugin_path = vue_typescript_plugin_path()
    if not plugin_path then
        return {}
    end

    return {
        plugins = {
            {
                name = "@vue/typescript-plugin",
                location = plugin_path,
                languages = { "javascript", "typescript", "vue" },
            },
        },
    }
end

local web_root_markers = {
    {
        "nuxt.config.js",
        "nuxt.config.mjs",
        "nuxt.config.ts",
        "nuxt.config.cjs",
        "package.json",
        "tsconfig.json",
        "jsconfig.json",
    },
    { ".git" },
}

local java_root_markers = {
    {
        "gradlew",
        "mvnw",
        "settings.gradle",
        "settings.gradle.kts",
        "build.gradle",
        "build.gradle.kts",
        "pom.xml",
    },
    { ".git" },
}

local function root_dir(markers)
    return function(bufnr, on_dir)
        local root = vim.fs.root(bufnr, markers)
        if root then
            on_dir(root)
        end
    end
end

local function jdtls_cmd(dispatchers, config)
    local data_dir = vim.fn.stdpath("cache") .. "/jdtls-workspace"
    if config.root_dir then
        data_dir = data_dir .. "/" .. vim.fn.fnamemodify(config.root_dir, ":p:h:t")
    end

    local jdtls = vim.fn.exepath("jdtls")
    if jdtls ~= "" then
        return vim.lsp.rpc.start({ jdtls, "-data", data_dir }, dispatchers, {
            cwd = config.cmd_cwd,
            env = config.cmd_env,
            detached = config.detached,
        })
    end

    local root = mise_where("ubi:eclipse/eclipse.jdt.ls")
    local launcher = find_file(root, function(name)
        return name == "org.eclipse.equinox.launcher.jar"
            or name:match("^org%.eclipse%.equinox%.launcher_.*%.jar$") ~= nil
    end)
    local config_dir = first_existing({
        root and vim.fs.joinpath(root, "config_linux"),
        root and vim.fs.joinpath(root, "config"),
    })

    if not launcher or not config_dir then
        vim.notify("jdtls not found. Run `mise install`.", vim.log.levels.WARN)
        return nil
    end

    return vim.lsp.rpc.start({
        "java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xmx1g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",
        "-jar",
        launcher,
        "-configuration",
        config_dir,
        "-data",
        data_dir,
    }, dispatchers, {
        cwd = config.cmd_cwd,
        env = config.cmd_env,
        detached = config.detached,
    })
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = lsp_group,
    callback = function(event)
        local bufnr = event.buf
        local keymap = vim.keymap.set
        local opts = { buffer = bufnr, silent = true }

        keymap("n", "gd", vim.lsp.buf.definition, opts)
        keymap("n", "gr", vim.lsp.buf.references, opts)
        keymap("n", "gD", vim.lsp.buf.declaration, opts)
        keymap("n", "gi", vim.lsp.buf.implementation, opts)
        keymap("n", "gy", vim.lsp.buf.type_definition, opts)
        keymap("n", "K", vim.lsp.buf.hover, opts)
        keymap("n", "<leader>lr", vim.lsp.buf.rename, opts)
        keymap("n", "<leader>la", vim.lsp.buf.code_action, opts)
        keymap("n", "[d", vim.diagnostic.goto_prev, opts)
        keymap("n", "]d", vim.diagnostic.goto_next, opts)
        keymap("n", "<leader>ld", vim.diagnostic.open_float, opts)
        keymap("n", "<leader>lq", vim.diagnostic.setqflist, opts)
    end,
})

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

local servers = {
    gopls = {
        capabilities = capabilities,
    },
    rust_analyzer = {
        capabilities = capabilities,
        settings = {
            ["rust-analyzer"] = {
                cargo = {
                    allFeatures = true,
                },
                check = {
                    command = "clippy",
                },
            },
        },
    },
    ts_ls = {
        capabilities = capabilities,
        root_dir = root_dir(web_root_markers),
        init_options = ts_ls_init_options(),
        filetypes = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "vue",
        },
    },
    vue_ls = {
        capabilities = capabilities,
        root_dir = root_dir(web_root_markers),
    },
    jdtls = {
        capabilities = capabilities,
        cmd = jdtls_cmd,
        root_dir = root_dir(java_root_markers),
    },
}

for server, config in pairs(servers) do
    vim.lsp.config(server, config)
    vim.lsp.enable(server)
end
