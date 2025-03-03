-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()
config.automatically_reload_config = true

-- config.color_scheme = 'AdventureTime'
-- fonts
config.font = wezterm.font("HackGen Console NF", {
    weight = "Regular",
    stretch = "Normal",
    style = "Normal"
})
config.font_size = 11

-- title bar
config.window_decorations = 'RESIZE'
-- タブバーを透明に
config.window_frame = {
    inactive_titlebar_bg = "none",
    active_titlebar_bg = "none"
}
-- タブバーの背景色
config.window_background_gradient = {
    colors = {"#000000"}
}
-- タブバーの+ボタンを消す
config.show_new_tab_button_in_tab_bar = false
-- タブが1つだけの時非表示
-- config.hide_tab_bar_if_only_one_tab = true
-- 日本語入力
config.use_ime = true
-- 背景透過
-- config.window_background_opacity = 0.85
-- config.macos_window_background_blur = 20 -- ぼかし

-- デフォルトキーバインドの無効
config.disable_default_key_bindings = true
-- リーダーキー
config.leader = {
    key = "k",
    mods = "CTRL",
    timeout_milliseconds = 2000
}
-- キーバインドの読み込み
config.keys = require("keybinds").keys
config.key_tables = require("keybinds").key_tables

-- shell
config.default_prog = {"bash", "--login"}

return config
