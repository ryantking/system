--[[
  Module: appearance.lua
  Purpose: Consolidated color scheme, fonts, and visual styling
  Dependencies: wezterm

  Applies:
  - Color scheme (Horizon Dark)
  - Font configuration (Iosevka Mono)
  - Font rules and ligatures (8 stylistic sets)
  - UI fonts for window frame, character selector, command palette
]]
--

local wezterm = require("wezterm")
local M = {}

function M.apply_to_config(config)
  -- Get builtin Horizon Dark color scheme
  local theme = wezterm.get_builtin_color_schemes()["Horizon Dark (Gogh)"]

  -- Font configuration
  config.font = wezterm.font_with_fallback({
    { family = "Iosevka Mono", weight = "Medium" },
  })
  config.font_size = 16
  config.warn_about_missing_glyphs = false

  -- Font features: ligatures + stylistic sets
  config.harfbuzz_features = {
    "ss01", -- Contextual alternatives
    "ss02", -- Stylistic Set 2
    "ss03", -- Stylistic Set 3
    "ss04", -- Stylistic Set 4
    "ss05", -- Stylistic Set 5
    "ss06", -- Stylistic Set 6
    "ss07", -- Stylistic Set 7
    "ss08", -- Stylistic Set 8
    "calt", -- Contextual alternates
    "liga", -- Standard ligatures
    "dlig", -- Discretionary ligatures
  }

  -- Font rules for different text styles
  config.font_rules = {
    {
      intensity = "Normal",
      italic = false,
      font = wezterm.font_with_fallback({
        { family = "Iosevka Mono", weight = "Medium" },
      }),
    },
    {
      intensity = "Bold",
      italic = false,
      font = wezterm.font_with_fallback({
        { family = "Iosevka Mono", weight = "ExtraBold" },
      }),
    },
    {
      intensity = "Half",
      italic = false,
      font = wezterm.font_with_fallback({
        { family = "Iosevka Mono", weight = "Thin" },
      }),
    },
    {
      intensity = "Normal",
      italic = true,
      font = wezterm.font_with_fallback({
        { family = "Iosevka Mono", weight = "Regular", style = "Italic" },
      }),
    },
    {
      intensity = "Bold",
      italic = true,
      font = wezterm.font_with_fallback({
        { family = "Iosevka Mono", weight = "Bold", style = "Italic" },
      }),
    },
    {
      intensity = "Half",
      italic = true,
      font = wezterm.font_with_fallback({
        { family = "Iosevka Mono", weight = "Thin", style = "Italic" },
      }),
    },
  }

  -- Apply color scheme
  config.colors = theme

  -- Customize tab bar colors
  config.colors.tab_bar = {
    background = theme.background,
    inactive_tab_edge = theme.ansi[8],
    inactive_tab_edge_hover = theme.foreground,

    active_tab = {
      bg_color = theme.background,
      fg_color = theme.ansi[5],
      intensity = "Bold",
    },

    inactive_tab = {
      bg_color = theme.background,
      fg_color = theme.ansi[8],
      intensity = "Half",
    },

    inactive_tab_hover = {
      bg_color = theme.brights[1],
      fg_color = theme.ansi[8],
    },

    new_tab = {
      bg_color = theme.background,
      fg_color = theme.ansi[8],
    },

    new_tab_hover = {
      bg_color = theme.brights[1],
      fg_color = theme.ansi[8],
    },
  }

  -- UI fonts (for UI elements)
  local ui_font = wezterm.font({ family = "Iosevka" })
  local ui_font_size = 14

  -- Window frame styling
  config.window_frame = {
    font = ui_font,
    font_size = ui_font_size,
    active_titlebar_bg = theme.background,
    inactive_titlebar_bg = theme.background,
    active_titlebar_fg = theme.foreground,
    inactive_titlebar_fg = theme.foreground,
  }

  -- Character selector appearance
  config.char_select_bg_color = theme.brights[1]
  config.char_select_fg_color = theme.foreground
  config.char_select_font = ui_font
  config.char_select_font_size = ui_font_size

  -- Command palette appearance
  config.command_palette_bg_color = theme.brights[1]
  config.command_palette_fg_color = theme.foreground
  config.command_palette_font = ui_font
  config.command_palette_font_size = ui_font_size
end

return M
