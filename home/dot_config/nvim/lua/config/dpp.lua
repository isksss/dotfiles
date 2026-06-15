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

local function load_state()
    return vim.fn["dpp#min#load_state"](base_path, state_name) == 0
end

local function dpp_action(action, params)
    if params then
        vim.fn["dpp#async_ext_action"]("installer", action, params)
    else
        vim.fn["dpp#async_ext_action"]("installer", action)
    end
end

local function auto_install()
    local ok, not_installed = pcall(vim.fn["dpp#sync_ext_action"], "installer", "getNotInstalled")
    if ok and type(not_installed) == "table" and #not_installed > 0 then
        dpp_action("install")
    end
end

local function schedule_auto_install()
    vim.defer_fn(function()
        pcall(auto_install)
    end, 1000)
end

local state_load_failed = not load_state()

if state_load_failed then
    vim.api.nvim_create_autocmd("User", {
        pattern = "DenopsReady",
        once = true,
        callback = make_state,
    })
elseif #vim.fn["dpp#check_files"](base_path, state_name) > 0 then
    vim.api.nvim_create_autocmd("User", {
        pattern = "DenopsReady",
        once = true,
        callback = make_state,
    })
else
    vim.api.nvim_create_autocmd("User", {
        pattern = "DenopsReady",
        once = true,
        callback = schedule_auto_install,
    })
end

vim.api.nvim_create_autocmd("User", {
    pattern = "Dpp:makeStatePost",
    callback = function()
        vim.notify("dpp make_state() is done")
        if load_state() then
            schedule_auto_install()
        end
    end,
})

vim.api.nvim_create_autocmd("User", {
    pattern = {
        "Dpp:extActionPost:installer:install",
        "Dpp:extActionPost:installer:update",
    },
    callback = function()
        make_state()
    end,
})

vim.api.nvim_create_user_command("DppInstall", function()
    dpp_action("install")
end, {})

vim.api.nvim_create_user_command("DppUpdate", function()
    dpp_action("update")
end, {})

vim.api.nvim_create_user_command("DppRollbackLatest", function()
    dpp_action("update", { rollback = "latest" })
end, {})

vim.api.nvim_create_user_command("DppMakeState", make_state, {})
