-----------------------------------------------------------
-- IME 制御
-----------------------------------------------------------
local function executable(cmd)
    return vim.fn.executable(cmd) == 1
end

local function detect_ime_off_cmd()
    if vim.g.ime_off_cmd then
        return vim.g.ime_off_cmd
    end

    local uname = vim.loop.os_uname()
    local sysname = uname.sysname
    local release = uname.release:lower()
    local is_wsl = sysname == "Linux" and release:find("microsoft", 1, true) ~= nil

    if sysname == "Darwin" then
        if executable("macism") then
            return { "macism", "com.apple.keylayout.ABC" }
        end
        if executable("im-select") then
            return { "im-select", "com.apple.keylayout.ABC" }
        end
    elseif is_wsl then
        if executable("zenhan.exe") then
            return { "zenhan.exe", "0" }
        end
        if executable("im-select.exe") then
            return { "im-select.exe", "1033" }
        end
    elseif sysname == "Linux" then
        if executable("fcitx5-remote") then
            return { "fcitx5-remote", "-c" }
        end
        if executable("fcitx-remote") then
            return { "fcitx-remote", "-c" }
        end
        if executable("ibus") then
            return { "ibus", "engine", "xkb:us::eng" }
        end
    end

    return nil
end

local ime_off_cmd = detect_ime_off_cmd()

if ime_off_cmd then
    local ime_group = vim.api.nvim_create_augroup("UserImeConfig", { clear = true })

    vim.api.nvim_create_autocmd("InsertLeave", {
        group = ime_group,
        callback = function()
            pcall(vim.fn.jobstart, ime_off_cmd, { detach = true })
        end,
    })
end
