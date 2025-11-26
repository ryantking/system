--[[
  Module: window.lua
  Purpose: Window behavior, padding, scrolling, and cursor settings
  Dependencies: wezterm
]]
--

local M = {}

function M.apply_to_config(config)
  -- Window decorations and behavior
  config.window_decorations = "RESIZE"
  config.window_close_confirmation = "NeverPrompt"

  -- Window padding
  config.window_padding = {
    left = 16,
    right = 16,
    top = 16,
    bottom = 16,
  }

  -- Scrolling behavior
  config.scrollback_lines = 5000
  config.enable_scroll_bar = true

  -- Cursor configuration
  config.cursor_blink_rate = 500
  config.cursor_blink_ease_in = "EaseIn"
  config.cursor_blink_ease_out = "EaseOut"
  config.default_cursor_style = "BlinkingBlock"

  -- Audio feedback
  config.audible_bell = "Disabled"
end

return M
