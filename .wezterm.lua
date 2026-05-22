local wezterm = require 'wezterm'
local act = wezterm.action

wezterm.log_info("Config file: " .. wezterm.config_file)
local is_mac = wezterm.target_triple:find("darwin")
local config = {}

--------------------------------------------------
-- 基本設定
--------------------------------------------------

config.default_prog = { "pwsh.exe", "-NoLogo" }

config.font = wezterm.font("HackGen Console NF")
config.font_size = 12

config.color_scheme = "Dracula"

config.window_background_opacity = 0.95

config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = true

config.disable_default_mouse_bindings = true

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

config.scrollback_lines = 10000

config.audible_bell = "Disabled"

config.default_cursor_style = "BlinkingBlock"

config.max_fps = 120
config.animation_fps = 120

config.front_end = "WebGpu"

config.use_ime = true

config.enable_scroll_bar = true
config.mouse_wheel_scrolls_tabs = true

--------------------------------------------------
-- Leader
--------------------------------------------------

config.leader = {
  key = "w",
  mods = is_mac and "CMD" or "ALT",
  timeout_milliseconds = 2000,
}

--------------------------------------------------
-- キーバインド
--------------------------------------------------

config.keys = {

  ------------------------------------------------
  -- pane移動
  ------------------------------------------------

  { key = "h", mods = "LEADER", action = act.ActivatePaneDirection "Left" },
  { key = "j", mods = "LEADER", action = act.ActivatePaneDirection "Down" },
  { key = "k", mods = "LEADER", action = act.ActivatePaneDirection "Up" },
  { key = "l", mods = "LEADER", action = act.ActivatePaneDirection "Right" },

  ------------------------------------------------
  -- pane resize
  ------------------------------------------------

  {
    key = "H",
    mods = "LEADER",
    action = act.AdjustPaneSize { "Left", 5 },
  },

  {
    key = "L",
    mods = "LEADER",
    action = act.AdjustPaneSize { "Right", 5 },
  },

  {
    key = "K",
    mods = "LEADER",
    action = act.AdjustPaneSize { "Up", 5 },
  },

  {
    key = "J",
    mods = "LEADER",
    action = act.AdjustPaneSize { "Down", 5 },
  },

  ------------------------------------------------
  -- pane split
  ------------------------------------------------

  {
    key = "\\",
    mods = "LEADER",
    action = act.SplitHorizontal {
      domain = "CurrentPaneDomain"
    },
  },

  {
    key = "-",
    mods = "LEADER",
    action = act.SplitVertical {
      domain = "CurrentPaneDomain"
    },
  },

  ------------------------------------------------
  -- pane close
  ------------------------------------------------

  {
    key = "w",
    mods = "LEADER",
    action = act.CloseCurrentPane {
      confirm = false,
    },
  },

  ------------------------------------------------
  -- tab
  ------------------------------------------------

  {
    key = "t",
    mods = "LEADER",
    action = act.SpawnTab "CurrentPaneDomain",
  },

  {
    key = "TAB",
    mods = "CTRL",
    action = act.ActivateTabRelative(1),
  },

  {
    key = "TAB",
    mods = "CTRL|SHIFT",
    action = act.ActivateTabRelative(-1),
  },

  ------------------------------------------------
  -- workspace launcher
  ------------------------------------------------

  {
    key = "s",
    mods = "LEADER",
    action = act.ShowLauncherArgs {
      flags = "WORKSPACES",
    },
  },

  ------------------------------------------------
  -- clipboard
  ------------------------------------------------

  {
    key = "c",
    mods = "CTRL|SHIFT",
    action = act.CopyTo "Clipboard",
  },

  {
    key = "v",
    mods = "CTRL|SHIFT",
    action = act.PasteFrom "Clipboard",
  },

  ------------------------------------------------
  -- copy mode
  ------------------------------------------------

  {
    key = "[",
    mods = "LEADER",
    action = act.ActivateCopyMode,
  },

  ------------------------------------------------
  -- Ctrl+Backspace
  ------------------------------------------------

  {
    key = "Backspace",
    mods = "CTRL",
    action = act.SendString("\x17"),
  },

  ------------------------------------------------
  -- WSL tab
  ------------------------------------------------

  {
    key = "u",
    mods = "LEADER",
    action = act.SpawnCommandInNewTab {
      args = { "wsl.exe" },
    },
  },
}

--------------------------------------------------
-- マウスコピー
--------------------------------------------------

config.mouse_bindings = {
  {
    event = {
      Up = {
        streak = 1,
        button = "Left"
      }
    },
    mods = "NONE",
    action = act.CompleteSelection "Clipboard",
  },
}

--------------------------------------------------
-- Color
--------------------------------------------------

config.colors = {
  background = "#282a36",

  tab_bar = {
    background = "#1e1f29",

    active_tab = {
      bg_color = "#50fa7b",
      fg_color = "#1e1f29",
      intensity = "Bold",
    },

    inactive_tab = {
      bg_color = "#282a36",
      fg_color = "#6272a4",
    },

    inactive_tab_hover = {
      bg_color = "#44475a",
      fg_color = "#f8f8f2",
    },

    new_tab = {
      bg_color = "#282a36",
      fg_color = "#6272a4",
    },
  },

  pane_active_border_fg = "#50fa7b",
  pane_border_fg = "#44475a",
}

config.inactive_pane_hsb = {
  saturation = 0.8,
  brightness = 0.6,
}

--------------------------------------------------
-- right status
--------------------------------------------------

wezterm.on("update-right-status", function(window, pane)
  local name = window:active_workspace()

  window:set_right_status(
    wezterm.format({
      { Foreground = { Color = "#50fa7b" } },
      { Text = "󱂬 " .. name .. " " },
    })
  )
end)

--------------------------------------------------
-- tab title
--------------------------------------------------

-- タブタイトルを、アクティブペインのgit_repo名+ブランチ名にする。
-- 例: {tab_no}: {git_repo_name}:{branch_name}

--------------------------------------------------
-- 背景画像
--------------------------------------------------

config.background = {
  {
    source = {
      File = wezterm.home_dir .. "/.wallpapers/wallpaper_icon.png",
    },

    -- 背景画像の不透明度を設定
    opacity = 0.95,

    -- 背景画像の明るさと彩度を調整
    hsb = {
      brightness = 0.05,
      saturation = 0.9,
    },
  },
}

--------------------------------------------------
return config
