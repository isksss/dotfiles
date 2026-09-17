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
}

M.node_locks = { "package-lock.json", "pnpm-lock.yaml", "yarn.lock", "bun.lock", "bun.lockb" }

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
    local dir = start_dir(bufnr)
    while dir do
        local path = vim.fs.joinpath(dir, "node_modules", ".bin", command)
        if vim.fn.executable(path) == 1 then
            return path
        end
        local parent = vim.fs.dirname(dir)
        dir = parent ~= dir and parent or nil
    end
    return nil
end

-- Share the same runtime boundary between LSP, formatting and tasks.
function M.runtime(bufnr)
    if vim.bo[bufnr or 0].filetype == "vue" then
        return "node", M.root(bufnr, { "package.json" }) or start_dir(bufnr)
    end
    local node = M.root(bufnr, M.node_locks)
    local deno = M.root(bufnr, { "deno.json", "deno.jsonc" })
    local lock = M.root(bufnr, { "deno.lock" })
    if deno and (not node or #deno >= #node) then
        return "deno", deno
    end
    if lock and (not node or #lock > #node) then
        return "deno", lock
    end
    return "node", node or M.root(bufnr, { "package.json", "tsconfig.json", ".git" }) or start_dir(bufnr)
end

function M.package(bufnr)
    local root = M.root(bufnr, { "package.json" })
    if not root then
        return nil, nil
    end
    local ok, lines = pcall(vim.fn.readfile, vim.fs.joinpath(root, "package.json"))
    if not ok then
        return nil, root
    end
    local decoded, value = pcall(vim.json.decode, table.concat(lines, "\n"))
    return decoded and type(value) == "table" and value or nil, root
end

function M.package_manager(bufnr)
    local dir = start_dir(bufnr)
    while dir do
        local path = vim.fs.joinpath(dir, "package.json")
        if vim.uv.fs_stat(path) then
            local ok, lines = pcall(vim.fn.readfile, path)
            local parsed, pkg = false, nil
            if ok then
                parsed, pkg = pcall(vim.json.decode, table.concat(lines, "\n"))
            end
            if parsed and type(pkg) == "table" and type(pkg.packageManager) == "string" then
                local name = pkg.packageManager:match("^([^@]+)")
                if vim.tbl_contains({ "npm", "pnpm", "yarn", "bun" }, name) then
                    return name
                end
                return nil, "未対応の packageManager: " .. pkg.packageManager
            end
        end
        local parent = vim.fs.dirname(dir)
        dir = parent ~= dir and parent or nil
    end
    local root = M.root(bufnr, M.node_locks)
    local found = {}
    if root then
        for file, manager in pairs({
            ["package-lock.json"] = "npm",
            ["pnpm-lock.yaml"] = "pnpm",
            ["yarn.lock"] = "yarn",
            ["bun.lock"] = "bun",
            ["bun.lockb"] = "bun",
        }) do
            if vim.uv.fs_stat(vim.fs.joinpath(root, file)) then
                found[manager] = true
            end
        end
    end
    local names = vim.tbl_keys(found)
    if #names > 1 then
        return nil, "lockfile が競合しています。packageManager を指定してください"
    end
    return names[1] or "npm"
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
