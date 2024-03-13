-- wezterm settings

local wezterm = require 'wezterm'

local config = {}

-- font
wezterm.font("HackGen Console NF", {weight="Regular", stretch="Normal", style="Normal"})

-- window
config.window_background_opacity = 0.85

-- keymap

local act = wezterm.action
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 2000 }
config.keys = {
    -- fullscreen toggle
    {
        key = "f",
        mods = "LEADER",
        action = wezterm.action.ToggleFullScreen,
    },
    {
        key = "|",
        mods = "LEADER",
        action = act.SplitHorizontal{ domain = "CurrentPaneDomain" },
    },
    {
        key = "-",
        mods = "LEADER",
        action = act.SplitVertical { domain = 'CurrentPaneDomain' },
    }
}
return config
