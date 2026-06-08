-----------------------------------------------------------
-- プロジェクト設定検出
-----------------------------------------------------------
local M = {}

M.eslint_configs = {
    "eslint.config.js",
    "eslint.config.mjs",
    "eslint.config.cjs",
    "eslint.config.ts",
    "eslint.config.mts",
    "eslint.config.cts",
    ".eslintrc",
    ".eslintrc.js",
    ".eslintrc.cjs",
    ".eslintrc.json",
    ".eslintrc.yaml",
    ".eslintrc.yml",
}

M.prettier_configs = {
    ".prettierrc",
    ".prettierrc.json",
    ".prettierrc.yml",
    ".prettierrc.yaml",
    ".prettierrc.json5",
    ".prettierrc.js",
    ".prettierrc.cjs",
    ".prettierrc.mjs",
    ".prettierrc.ts",
    ".prettierrc.cts",
    ".prettierrc.mts",
    ".prettierrc.toml",
    "prettier.config.js",
    "prettier.config.cjs",
    "prettier.config.mjs",
    "prettier.config.ts",
    "prettier.config.cts",
    "prettier.config.mts",
}

M.biome_configs = {
    "biome.json",
    "biome.jsonc",
    ".biome.json",
    ".biome.jsonc",
}

M.oxlint_configs = {
    ".oxlintrc.json",
    "oxlint.config.json",
}

M.oxfmt_configs = {
    ".oxfmtrc.json",
    ".oxfmtrc.jsonc",
    "oxfmt.config.ts",
    "vite.config.ts",
    "vite.config.js",
}

M.checkstyle_configs = {
    "checkstyle.xml",
    "config/checkstyle/checkstyle.xml",
    "config/checkstyle/checkstyle-main.xml",
    "config/checkstyle/google_checks.xml",
}

local function start_dir(bufnr)
    local name = vim.api.nvim_buf_get_name(bufnr or 0)
    if name ~= "" then
        return vim.fs.dirname(name)
    end
    return vim.fn.getcwd()
end

function M.root(bufnr, markers)
    return vim.fs.root(bufnr or 0, markers)
end

function M.has_root_file(bufnr, markers)
    return M.root(bufnr, markers) ~= nil
end

function M.node_bin(bufnr, command)
    for dir in vim.fs.parents(start_dir(bufnr)) do
        local path = vim.fs.joinpath(dir, "node_modules", ".bin", command)
        if vim.uv.fs_stat(path) then
            return path
        end
    end
    return nil
end

function M.has_package_key(bufnr, key)
    local root = M.root(bufnr, { "package.json" })
    if not root then
        return false
    end

    local path = vim.fs.joinpath(root, "package.json")
    local ok, lines = pcall(vim.fn.readfile, path)
    if not ok then
        return false
    end

    local ok_json, package = pcall(vim.json.decode, table.concat(lines, "\n"))
    return ok_json and type(package) == "table" and package[key] ~= nil
end

function M.has_prettier(bufnr)
    return M.has_root_file(bufnr, M.prettier_configs) or M.has_package_key(bufnr, "prettier")
end

return M
