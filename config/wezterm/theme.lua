local wezterm = require("wezterm")

local M = {}

M.color_scheme = "Horizon Dark (Gogh)"

M.font = wezterm.font("Iosevka Mono")

M.font_size = 16

M.ui_font = wezterm.font({ family = "Iosevka", weight = "Bold" })

M.ui_font_size = 12

-- builtin scheme colors [[
-- ------------------------

-- background = dark gray
-- foreground = white

-- ansi[1] = black
-- ansi[2] = red
-- ansi[3] = green
-- ansi[4] = yellow
-- ansi[5] = blue
-- ansi[6] = magenta
-- ansi[7] = cyan
-- ansi[8] = light gray

-- brights[1] = gray
-- brights[2] = red
-- brights[3] = green
-- brights[4] = yellow
-- brights[5] = blue
-- brights[6] = magenta
-- brights[7] = cyan
-- brights[8] = white

-- ]]

local function get_colors()
  local colors = wezterm.color.get_builtin_schemes()[M.color_scheme]
  colors.cursor_bg = colors.brights[2]
  colors.cursor_border = colors.brights[2]
  colors.selection_bg = colors.brights[1]
  colors.copy_mode_active_highlight_bg = { Color = colors.brights[1] }
  colors.copy_mode_active_highlight_fg = { Color = colors.brights[2] }
  colors.copy_mode_inactive_highlight_bg = { Color = colors.brights[2] }
  colors.copy_mode_inactive_highlight_fg = { Color = colors.ansi[1] }
  colors.quick_select_label_bg = { Color = colors.brights[1] }
  colors.quick_select_label_fg = { Color = colors.brights[5] }
  colors.quick_select_match_bg = { Color = colors.brights[1] }
  colors.quick_select_match_fg = { Color = colors.foreground }

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
  return colors
end

function M.apply_to_config(config)
  config.font = M.font
  config.font_size = M.font_size
  config.color_scheme = M.theme

  local colors = get_colors()
  config.colors = colors
  config.char_select_bg_color = colors.brights[1]
  config.char_select_fg_color = colors.ansi[8]
  config.char_select_font = M.ui_font
  config.char_select_font_size = M.ui_font_size
  config.command_palette_bg_color = colors.brights[1]
  config.command_palette_fg_color = colors.ansi[8]
  config.command_palette_font = M.ui_font
  config.command_palette_font_size = M.ui_font_size
  config.window_frame = {
    font = M.ui_font,
    font_size = M.ui_font_size,
    active_titlebar_bg = config.colors.background,
    inactive_titlebar_bg = config.colors.background,
  }
end

return M
