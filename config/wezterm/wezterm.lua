local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "Horizon Dark (Gogh)"

config.font = wezterm.font("Iosevka Mono")

config.font_size = 16

config.window_frame = {
  font = wezterm.font({ family = "Iosevka", weight = "Bold" }),

  font_size = 16.0,

  active_titlebar_bg = "#1C1E26",

  inactive_titlebar_bg = "#1C1E26",
}

config.colors = {
  tab_bar = {
    background = "#0b0022",
    inactive_tab_edge = "#6C6F93",
    inactive_tab_edge_hover = "#6C6F93",
    active_tab = {
      bg_color = "#1C1E26",
      fg_color = "#25B2BC",
    },
    inactive_tab = {
      bg_color = "#1C1E26",
      fg_color = "#6C6F93",
    },
    inactive_tab_hover = {
      bg_color = "#232530",
      fg_color = "#6C6F93",
    },
    new_tab = {
      bg_color = "#1C1E26",
      fg_color = "#6C6F93",
    },
    new_tab_hover = {
      bg_color = "#232530",
      fg_color = "#6C6F93",
    },
  },
}

config.ssh_domains = {
  {
    name = "trajan",
    remote_address = "trajan",
  },
}

return config
