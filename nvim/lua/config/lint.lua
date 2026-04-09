-----------------------------------------------------------
-- lint 設定
-----------------------------------------------------------
local lint = require("lint")
local mason_registry = require("mason-registry")

local function get_checkstyle_config()
    local ok, pkg = pcall(mason_registry.get_package, "checkstyle")
    if not ok then
        return nil
    end

    local config_path = pkg:get_install_path() .. "/google_checks.xml"
    if vim.fn.filereadable(config_path) == 1 then
        return config_path
    end

    return nil
end

local checkstyle_config = get_checkstyle_config()
if checkstyle_config then
    lint.linters.checkstyle.args = {
        "-f",
        "xml",
        "-c",
        checkstyle_config,
    }
end

lint.linters_by_ft = {
    javascript = { "eslint_d" },
    javascriptreact = { "eslint_d" },
    typescript = { "eslint_d" },
    typescriptreact = { "eslint_d" },
    java = { "checkstyle" },
}

local lint_group = vim.api.nvim_create_augroup("UserLintConfig", { clear = true })

vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
    group = lint_group,
    callback = function()
        lint.try_lint()
    end,
})
