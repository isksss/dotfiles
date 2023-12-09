-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- For example, changing the color scheme:
config.color_scheme = 'AdventureTime'

-- colors
config.color_scheme = "nord"
config.window_background_opacity = 0.93
-- font
config.font = wezterm.font("Hackgen Console NF")
config.font_size = 13.0

-- keybinds
-- デフォルトのkeybindを無効化
config.disable_default_key_bindings = true
-- `keybinds.lua`を読み込み
local keybind = require 'keybinds'
-- keybindの設定
config.keys = keybind.keys
config.key_tables = keybind.key_tables
-- Leaderキーの設定
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 2000 }

-- status
config.status_update_interval = 1000
require 'status'


return config