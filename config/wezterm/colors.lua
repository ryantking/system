local wezterm = require("wezterm")

local theme = "Horizon Dark (Gogh)"

local colors = wezterm.color.get_builtin_schemes()[theme]

colors.tab_bar = {
  background = colors.background,
  inactive_tab_edge = colors.ansi[8],
  inactive_tab_edge_hover = colors.foreground,

  active_tab = {
    bg_color = colors.background,
    fg_color = colors.ansi[5],
    intensity = "Bold",
  },

  inactive_tab = {
    bg_color = colors.background,
    fg_color = colors.ansi[8],
    intensity = "Half",
  },

  inactive_tab_hover = {
    bg_color = colors.brights[1],
    fg_color = colors.ansi[8],
  },

  new_tab = {
    bg_color = colors.background,
    fg_color = colors.ansi[8],
  },

  new_tab_hover = {
    bg_color = colors.brights[1],
    fg_color = colors.ansi[8],
  },
}

local ui_font = require("font").ui_font
local ui_font_size = require("font").ui_font_size

return {
  window_frame = {
    font = ui_font,
    font_size = ui_font_size,
    inactive_titlebar_bg = colors.background,
    active_titlebar_bg = colors.background,
    inactive_titlebar_fg = colors.foreground,
    active_titlebar_fg = colors.foreground,
  },

  char_select_bg_color = colors.brights[1],
  char_select_fg_color = colors.foreground,
  char_select_font = ui_font,
  char_select_font_size = ui_font_size,
  command_palette_bg_color = colors.brights[1],
  command_palette_fg_color = colors.foreground,
  command_palette_font = ui_font,
  command_palette_font_size = ui_font_size,
  colors = colors,
}
