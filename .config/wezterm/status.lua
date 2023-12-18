local wezterm = require 'wezterm'

-- left
local DEFAULT_FG = { Color = '#9a9eab' }
local DEFAULT_BG = { Color = '#333333' }

local SPACE_1 = ' '
local SPACE_3 = '   '

local HEADER_KEY_NORMAL = { Foreground = DEFAULT_FG, Text = 'A' }
local HEADER_LEADER = { Foreground = { Color = '#ffffff' }, Text = '' }
local HEADER_IME = { Foreground = DEFAULT_FG, Text = 'IME' }

local function AddIcon(elems, icon)
  table.insert(elems, { Foreground = icon.Foreground })
  table.insert(elems, { Background = DEFAULT_BG })
  table.insert(elems, { Text = SPACE_1 .. icon.Text .. SPACE_3 })
end

local function GetKeyboard(elems, window)
  if window:leader_is_active() then
    AddIcon(elems, HEADER_LEADER)
    return
  end

  AddIcon(elems, window:composition_status() and HEADER_IME or HEADER_KEY_NORMAL)
end


-- main
local function LeftUpdate(window, pane)
    local elems = {}

    GetKeyboard(elems, window)

    window:set_left_status(wezterm.format(elems))
    end

    wezterm.on('update-status', function(window, pane)
    LeftUpdate(window, pane)
end)