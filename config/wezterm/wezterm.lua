--[[
  WezTerm Configuration
  Modular configuration with clean orchestration pattern

  Structure:
  - wezterm.lua: Main orchestrator (this file)
  - modules/appearance.lua: Colors, fonts, visual styling
  - modules/window.lua: Window behavior and settings
  - modules/tabs.lua: Custom tab bar with icons
  - modules/keys.lua: Keyboard bindings
  - modules/mouse.lua: Mouse behavior
  - modules/plugins.lua: Plugin integrations

  Leadership pattern: CMD+Space (5-second timeout)
  Theme: Horizon Dark (Gogh)
  Font: Iosevka Mono (16pt)
]]
--

local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Core settings
config.enable_kitty_keyboard = false
config.enable_kitty_graphics = true
config.default_prog = { "/opt/homebrew/bin/fish", "-l" }
config.default_workspace = "~"

-- Load and apply all configuration modules
require("modules.appearance").apply_to_config(config)
require("modules.window").apply_to_config(config)
require("modules.tabs").apply_to_config(config)
require("modules.mouse").apply_to_config(config)
require("modules.keys").apply_to_config(config)
require("modules.plugins").apply_to_config(config)

-- Event: Check if process is stateful (for multiplexing)
wezterm.on("mux-is-process-stateful", function(_proc)
  return false
end)

-- Debug logging
wezterm.log_info("WezTerm config loaded successfully")

return config
