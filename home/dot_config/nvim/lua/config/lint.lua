-----------------------------------------------------------
-- lint 設定
-----------------------------------------------------------
local lint = require("lint")

-- Mason no longer exposes Package:get_install_path().
-- Use Checkstyle's bundled Google config instead of depending on Mason's package layout.
lint.linters.checkstyle.config_file = "/google_checks.xml"

lint.linters_by_ft = {
    javascript = { "eslint_d" },
    javascriptreact = { "eslint_d" },
    typescript = { "eslint_d" },
    typescriptreact = { "eslint_d" },
    vue = { "eslint_d" },
    java = { "checkstyle" },
}

local lint_group = vim.api.nvim_create_augroup("UserLintConfig", { clear = true })

vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
    group = lint_group,
    callback = function()
        lint.try_lint()
    end,
})
