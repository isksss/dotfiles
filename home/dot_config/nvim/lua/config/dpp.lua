-----------------------------------------------------------
-- dpp.vim bootstrap
-----------------------------------------------------------
local base_path = vim.fn.stdpath("data") .. "/dpp"
local repos_path = base_path .. "/repos/github.com"
local config_path = vim.fn.stdpath("config") .. "/dpp.ts"
local state_name = "default"

local bootstrap_repos = {
    "Shougo/dpp.vim",
    "vim-denops/denops.vim",
    "Shougo/dpp-ext-lazy",
    "Shougo/dpp-ext-installer",
    "Shougo/dpp-protocol-git",
}

local function repo_path(repo)
    return repos_path .. "/" .. repo
end

local function ensure_repo(repo)
    local path = repo_path(repo)
    if vim.uv.fs_stat(path) then
        return path
    end

    vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/" .. repo .. ".git",
        path,
    })

    if vim.v.shell_error ~= 0 then
        error("Failed to clone " .. repo .. " into " .. path)
    end

    return path
end

for _, repo in ipairs(bootstrap_repos) do
    vim.opt.runtimepath:prepend(ensure_repo(repo))
end

local function make_state()
    vim.fn["dpp#make_state"](base_path, config_path, state_name)
end

if vim.fn["dpp#min#load_state"](base_path, state_name) ~= 0 then
    vim.api.nvim_create_autocmd("User", {
        pattern = "DenopsReady",
        once = true,
        callback = make_state,
    })
end

vim.api.nvim_create_autocmd("User", {
    pattern = "Dpp:makeStatePost",
    callback = function()
        vim.notify("dpp make_state() is done")
    end,
})

vim.api.nvim_create_autocmd("User", {
    pattern = {
        "Dpp:extActionPost:installer:install",
        "Dpp:extActionPost:installer:update",
    },
    callback = make_state,
})

vim.api.nvim_create_user_command("DppInstall", function()
    vim.fn["dpp#async_ext_action"]("installer", "install")
end, {})

vim.api.nvim_create_user_command("DppUpdate", function()
    vim.fn["dpp#async_ext_action"]("installer", "update")
end, {})

vim.api.nvim_create_user_command("DppMakeState", make_state, {})
