--[[
  Module: plugins.lua
  Purpose: WezTerm plugin integrations and configuration
  Dependencies: wezterm, smart_workspace_switcher, quick_domains plugins
]]
--

local wezterm = require("wezterm")
local M = {}

function M.apply_to_config(config)
  -- Smart Workspace Switcher - Fuzzy workspace switching
  local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
  workspace_switcher.apply_to_config(config)

  -- Custom workspace formatter with nerd font icon and colors
  workspace_switcher.workspace_formatter = function(label)
    local colors = config.colors or {}
    return wezterm.format({
      { Attribute = { Italic = true } },
      { Foreground = { Color = colors.ansi and colors.ansi[3] or "#ffcc00" } },
      { Background = { Color = colors.background or "#1c1e26" } },
      { Text = "󱂬 : " .. label },
    })
  end

  -- Helper function for workspace status
  local function basename(s)
    return string.gsub(s, "(.*[/\\])(.*)", "%2")
  end

  -- Workspace switcher event: workspace created
  wezterm.on("smart_workspace_switcher.workspace_switcher.created", function(window, path, label)
    local colors = config.colors or {}
    window:gui_window():set_right_status(wezterm.format({
      { Attribute = { Intensity = "Bold" } },
      { Foreground = { Color = colors.ansi and colors.ansi[5] or "#ee64ac" } },
      { Text = basename(path) .. "  " },
    }))
  end)

  -- Workspace switcher event: workspace chosen
  wezterm.on("smart_workspace_switcher.workspace_switcher.chosen", function(window, path, _)
    local colors = config.colors or {}
    window:gui_window():set_right_status(wezterm.format({
      { Attribute = { Intensity = "Bold" } },
      { Foreground = { Color = colors.ansi and colors.ansi[5] or "#ee64ac" } },
      { Text = basename(path) .. "  " },
    }))
  end)

  -- Quick Domains - SSH/Docker/Kubernetes domain management
  local domains = wezterm.plugin.require("https://github.com/DavidRR-F/quick_domains.wezterm")
  domains.apply_to_config(config, {
    keys = {
      attach = { key = "t", mods = "ALT|SHIFT", tbl = "" },
      vsplit = { key = "_", mods = "CTRL|SHIFT|ALT", tbl = "" },
      hsplit = { key = "-", mods = "CTRL|ALT", tbl = "" },
    },
    auto = {
      ssh_ignore = true,
      exec_ignore = {
        ssh = true,
        docker = false,
        kubernetes = true,
      },
    },
  })
end

return M
