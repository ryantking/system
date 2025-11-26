--[[
  Module: mouse.lua
  Purpose: Mouse behavior and bindings (selection, link opening)
  Dependencies: wezterm, keys module

  Features:
  - Left-click: Copy selection to clipboard
  - Modifier+click: Open link or extend selection
  - Quadruple-click: Select semantic zone
]]
--

local wezterm = require("wezterm")
local keys = require("modules.keys")

local M = {}

---@param config Config
function M.apply_to_config(config)
  config.alternate_buffer_wheel_scroll_speed = 1
  config.bypass_mouse_reporting_modifiers = keys.mod
  config.hide_mouse_cursor_when_typing = false
  config.mouse_bindings = {
    {
      event = { Up = { streak = 1, button = "Left" } },
      action = wezterm.action.CompleteSelection("ClipboardAndPrimarySelection"),
    },
    {
      event = { Up = { streak = 1, button = "Left" } },
      mods = keys.mod,
      action = wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor("ClipboardAndPrimarySelection"),
    },
    {
      event = { Down = { streak = 4, button = "Left" } },
      action = wezterm.action.SelectTextAtMouseCursor("SemanticZone"),
    },
  }
end

return M
