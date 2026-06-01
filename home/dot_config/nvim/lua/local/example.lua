-- Copy this file to clipboard.lua and adjust the path for your environment.
-- Files under lua/local are for machine-specific settings and are not tracked by Git.

local win32yank = "/path/to/win32yank.exe"

vim.g.clipboard = {
  name = "win32yank",
  copy = {
    ["+"] = win32yank .. " -i --crlf",
    ["*"] = win32yank .. " -i --crlf",
  },
  paste = {
    ["+"] = win32yank .. " -o --lf",
    ["*"] = win32yank .. " -o --lf",
  },
  cache_enabled = 0,
}
