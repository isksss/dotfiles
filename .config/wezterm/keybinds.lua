local wezterm = require 'wezterm'
local act = wezterm.action
-- leader key: <C-k>
return {
    keys = {
      -- 画面分割
      { key = '[', mods = 'LEADER', action = act.SplitVertical{ domain =  'CurrentPaneDomain' } },
      { key = ']', mods = 'LEADER', action = act.SplitHorizontal{ domain =  'CurrentPaneDomain' } },
      -- 分割した画面移動
      { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
      { key = 'H', mods = 'LEADER', action = act.AdjustPaneSize{ 'Left', 1 } },
      { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },
      { key = 'L', mods = 'LEADER', action = act.AdjustPaneSize{ 'Right', 1 } },
      { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
      { key = 'K', mods = 'LEADER', action = act.AdjustPaneSize{ 'Up', 1 } },
      { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
      { key = 'J', mods = 'LEADER', action = act.AdjustPaneSize{ 'Down', 1 } },
      -- Tab移動
      { key = "Tab", mods = "CTRL", action = act.ActivateTabRelative(1) },
      { key = "Tab", mods = "SHIFT|CTRL", action = act.ActivateTabRelative(-1) },
    },

    key_tables = {
        copy_mode = {},
        search_mode = {}
    }
}
