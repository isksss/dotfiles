-----------------------------------------------------------
-- lint 設定
-----------------------------------------------------------
local lint = require("lint")
local project = require("config.project")

lint.linters.checkstyle.config_file = "/google_checks.xml"

lint.linters.biomejs.cmd = function()
    return project.node_bin(0, "biome") or "biome"
end

lint.linters.oxlint.cmd = function()
    return project.node_bin(0, "oxlint") or "oxlint"
end

lint.linters_by_ft = {
    markdown = { "markdownlint-cli2" },
}

local web_filetypes = {
    javascript = true,
    javascriptreact = true,
    typescript = true,
    typescriptreact = true,
    vue = true,
}

local function linters_for_buffer(bufnr)
    local ft = vim.bo[bufnr].filetype

    if web_filetypes[ft] then
        if project.has_root_file(bufnr, project.eslint_configs) then
            return { "eslint_d" }
        end
        if project.has_root_file(bufnr, project.biome_configs) and project.node_bin(bufnr, "biome") then
            return { "biomejs" }
        end
        if project.has_root_file(bufnr, project.oxlint_configs) and project.node_bin(bufnr, "oxlint") then
            return { "oxlint" }
        end
        return {}
    end

    if ft == "java" then
        if project.has_root_file(bufnr, project.checkstyle_configs) then
            return { "checkstyle" }
        end
        return {}
    end

    return nil
end

local lint_group = vim.api.nvim_create_augroup("UserLintConfig", { clear = true })

vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
    group = lint_group,
    callback = function(event)
        local names = linters_for_buffer(event.buf)
        if names == nil then
            lint.try_lint()
        elseif #names > 0 then
            lint.try_lint(names)
        end
    end,
})

vim.keymap.set("n", "<leader>ll", function()
    local names = linters_for_buffer(0)
    if names == nil then
        lint.try_lint()
    elseif #names > 0 then
        lint.try_lint(names)
    end
end, { desc = "現在のバッファを lint" })
