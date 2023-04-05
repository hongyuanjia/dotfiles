-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Use tokyonight storm color scheme
config.color_scheme = "tokyonight_storm"

-- Remove all window padding
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

-- Place the tab bar at the bottom
config.tab_bar_at_bottom = true

-- Only show tab bar if multiple tabs
config.hide_tab_bar_if_only_one_tab = true

config.disable_default_key_bindings = true

config.keys = {
  -- command palette
  {
    mods = "CTRL|SHIFT", key = "P",
    action = "ActivateCommandPalette"
  },
  -- copy and paste
  {
    mods = "CTRL|SHIFT", key = "F",
    action = wezterm.action { Search = { CaseSensitiveString = "" } }
  },
  {
    mods = "CTRL|SHIFT", key = "C",
    action = wezterm.action { CopyTo = "Clipboard" }
  },
  {
    mods = "CTRL|SHIFT", key = "V",
    action = wezterm.action { PasteFrom = "Clipboard" }
  },
  {
    mods = "SHIFT", key = "Insert",
    action = wezterm.action { PasteFrom = "PrimarySelection" }
  },
  -- resize fonts
  {
    mods = "CTRL", key = "-",
    action = "DecreaseFontSize"
  },
  {
    mods = "CTRL", key = "=",
    action = "IncreaseFontSize"
  },
  {
    mods = "CTRL", key = "0",
    action = "ResetFontSize"
  },
  -- split pane
  {
    mods = "CTRL|SHIFT|ALT", key = "_",
    action = wezterm.action { SplitVertical = { domain = "CurrentPaneDomain" } }
  },
  {
    mods = "CTRL|SHIFT|ALT", key = "?",
    action = wezterm.action { SplitHorizontal = { domain = "CurrentPaneDomain" } }
  },
  -- resize pane
  {
    mods = "CTRL|SHIFT|ALT", key = "H",
    action = wezterm.action { AdjustPaneSize = { "Left", 1 } }
  },
  {
    mods = "CTRL|SHIFT|ALT", key = "L",
    action = wezterm.action { AdjustPaneSize = { "Right", 1 } }
  },
  {
    mods = "CTRL|SHIFT|ALT", key = "K",
    action = wezterm.action { AdjustPaneSize = { "Up", 1 } }
  },
  {
    mods = "CTRL|SHIFT|ALT", key = "J",
    action = wezterm.action { AdjustPaneSize = { "Down", 1 } }
  },
  -- change focussed pane
  {
    mods = "CTRL|SHIFT", key = "H",
    action = wezterm.action { ActivatePaneDirection = "Left" }
  },
  {
    mods = "CTRL|SHIFT", key = "L",
    action = wezterm.action { ActivatePaneDirection = "Right" }
  },
  {
    mods = "CTRL|SHIFT", key = "K",
    action = wezterm.action { ActivatePaneDirection = "Up" }
  },
  {
    mods = "CTRL|SHIFT", key = "J",
    action = wezterm.action { ActivatePaneDirection = "Down" }
  },
  -- maximize pane
  {
    mods = "CTRL|SHIFT", key = "Z",
    action = "TogglePaneZoomState"
  },
  -- create tab
  {
    mods = "CTRL|SHIFT", key = "T",
    action = wezterm.action { SpawnTab = "CurrentPaneDomain" }
  },
  -- close tab
  {
    mods = "CTRL|SHIFT", key = "X",
    action = wezterm.action { CloseCurrentTab = { confirm = true } }
  },
  -- activate tab
  {
    mods = "CTRL|SHIFT", key = "!",
    action = wezterm.action { ActivateTab = 0 }
  },
  {
    mods = "CTRL|SHIFT", key = "@",
    action = wezterm.action { ActivateTab = 1 }
  },
  {
    mods = "CTRL|SHIFT", key = "#",
    action = wezterm.action { ActivateTab = 2 }
  },
  {
    mods = "CTRL|SHIFT", key = "$",
    action = wezterm.action { ActivateTab = 3 }
  },
  {
    mods = "CTRL|SHIFT", key = "%",
    action = wezterm.action { ActivateTab = 4 }
  },
  {
    mods = "CTRL|SHIFT", key = "^",
    action = wezterm.action { ActivateTab = 5 }
  },
  {
    mods = "CTRL|SHIFT", key = "&",
    action = wezterm.action { ActivateTab = 6 }
  },
  {
    mods = "CTRL|SHIFT", key = "*",
    action = wezterm.action { ActivateTab = 7 }
  },
  {
    mods = "CTRL|SHIFT", key = "(",
    action = wezterm.action { ActivateTab = -1 }
  },
  {
    mods = "CTRL|SHIFT", key = "Tab",
    action = wezterm.action { ActivateTabRelative = -1 }
  },
  {
    mods = "CTRL", key = "Tab",
    action = wezterm.action { ActivateTabRelative = 1 }
  },
  -- change tab order
  {
    mods = "CTRL|SHIFT", key = "PageUp",
    action = wezterm.action { MoveTabRelative = -1 }
  },
  {
    mods = "CTRL|SHIFT", key = "PageDown",
    action = wezterm.action { MoveTabRelative = 1 }
  },
  -- rename tab (NOTE: only works in nightly)
  {
    mods = "CTRL|SHIFT", key = "E",
    action = wezterm.action.PromptInputLine {
      description = "Enter new name for tab",
      action = wezterm.action_callback(
        function(window, pane, line)
          if line then window:active_tab():set_title(line) end
        end
      )
    }
  }
}

return config
