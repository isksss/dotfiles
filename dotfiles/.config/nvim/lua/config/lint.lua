local lint = require("lint")
local project = require("config.project")
local web = { javascript = true, javascriptreact = true, typescript = true, typescriptreact = true, vue = true }
local M = {}

for name, command in pairs({ biomejs = "biome", oxlint = "oxlint" }) do
    lint.linters[name].cmd = function()
        return project.node_bin(0, command) or command
    end
end
lint.linters_by_ft = { markdown = { "markdownlint-cli2" } }

function M.run(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_call(bufnr, function()
        local ft = vim.bo.filetype
        local names = lint.linters_by_ft[ft] or {}
        if web[ft] and project.runtime(bufnr) ~= "deno" then
            if
                project.has_root_file(bufnr, project.eslint_configs) or project.has_package_key(bufnr, "eslintConfig")
            then
                names = { "eslint_d" }
            elseif project.has_root_file(bufnr, project.biome_configs) and project.node_bin(bufnr, "biome") then
                names = { "biomejs" }
            elseif project.has_root_file(bufnr, project.oxlint_configs) and project.node_bin(bufnr, "oxlint") then
                names = { "oxlint" }
            end
        end
        if #names > 0 then
            local name = vim.api.nvim_buf_get_name(bufnr)
            lint.try_lint(names, { cwd = name ~= "" and vim.fs.dirname(name) or vim.fn.getcwd() })
        end
    end)
end

vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("UserLintConfig", { clear = true }),
    callback = function(event)
        M.run(event.buf)
    end,
})

return M
