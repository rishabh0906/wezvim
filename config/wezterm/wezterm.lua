local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.font = wezterm.font("Iosevka Nerd Font Mono")
config.font_size = 15

config.colors = {
  foreground = "#f2f4f8",
  background = "#161616",
  cursor_bg = "#ffffff",
  cursor_border = "#ffffff",
  cursor_fg = "#161616",
  selection_bg = "#393939",
  selection_fg = "#f2f4f8",
  ansi = {
    "#262626",
    "#ee5396",
    "#42be65",
    "#ffe97b",
    "#33b1ff",
    "#ff7eb6",
    "#3ddbd9",
    "#dde1e6",
  },
  brights = {
    "#525252",
    "#ee5396",
    "#42be65",
    "#ffe97b",
    "#33b1ff",
    "#ff7eb6",
    "#3ddbd9",
    "#ffffff",
  },
}

config.window_background_opacity = 0.9
config.text_background_opacity = 1.0
config.macos_window_background_blur = 30

config.enable_tab_bar = false

config.window_padding = {
  left = 8,
  right = 8,
  top = 8,
  bottom = 8,
}

config.keys = {
  {
    key = "Enter",
    mods = "ALT",
    action = wezterm.action.ToggleFullScreen,
  },
}

return config
