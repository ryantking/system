local wezterm = require("wezterm")

wezterm.log_info("The config was reloaded for this window!")

local function merge_tables(t1, t2)
  for key, value in pairs(t2) do
    t1[key] = value
  end
end

local function basename(s)
  return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

local config = {
  default_workspace = "~",
  font = require("font").font,
  -- font_antialias = "Subpixel",
  font_size = 16,
  font_rules = require("font").font_rules,
  warn_about_missing_glyphs = false,

  window_padding = {
    left = 16,
    right = 16,
    top = 8,
    bottom = 8,
  },

  cursor_blink_rate = 500,
  cursor_blink_ease_in = "EaseIn",
  cursor_blink_ease_out = "EaseOut",
  default_cursor_style = "BlinkingBlock",

  hide_tab_bar_if_only_one_tab = true,
  hide_mouse_cursor_when_typing = false,
  scrollback_lines = 5000,
  audible_bell = "Disabled",
  enable_scroll_bar = true,

  -- front_end = "WebGpu",
  -- webgpu_power_preference = "HighPerformance",

  unix_domains = {
    { name = "unix" },
  },

  ssh_domains = {},
}

local colors = require("colors")
merge_tables(config, colors)

config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 5000 }
config.keys = require("keybinds")
config.mouse_bindings = require("mousebinds")

local modal = wezterm.plugin.require("https://github.com/MLFlexer/modal.wezterm")
modal.apply_to_config(config)

wezterm.on("modal.enter", function(name, window, pane)
  modal.set_right_status(window, name)
  modal.set_window_title(pane, name)
end)

wezterm.on("modal.exit", function(_, window, pane)
  local title = basename(window:active_workspace())
  window:set_right_status(wezterm.format({
    { Attribute = { Intensity = "Bold" } },
    { Foreground = { Color = colors.colors.ansi[5] } },
    { Text = title .. "  " },
  }))
  modal.reset_window_title(pane)
end)

local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")
resurrect.state_manager.periodic_save({
  interval_seconds = 15 * 60,
  save_workspaces = true,
  save_windows = true,
  save_tabs = true,
})

wezterm.on("resurrect.error", function(err)
  wezterm.log_error("ERROR!")
  wezterm.gui.gui_windows()[1]:toast_notification("resurrect", err, nil, 3000)
end)

local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
workspace_switcher.apply_to_config({})

workspace_switcher.workspace_formatter = function(label)
  return wezterm.format({
    { Attribute = { Italic = true } },
    { Foreground = { Color = colors.colors.ansi[3] } },
    { Background = { Color = colors.colors.background } },
    { Text = "󱂬 : " .. label },
  })
end

wezterm.on("smart_workspace_switcher.workspace_switcher.created", function(window, path, label)
  window:gui_window():set_right_status(wezterm.format({
    { Attribute = { Intensity = "Bold" } },
    { Foreground = { Color = colors.colors.ansi[5] } },
    { Text = basename(path) .. "  " },
  }))
  local workspace_state = resurrect.workspace_state

  workspace_state.restore_workspace(resurrect.state_manager.load_state(label, "workspace"), {
    window = window,
    relative = true,
    restore_text = true,

    resize_window = false,
    on_pane_restore = resurrect.tab_state.default_on_pane_restore,
  })
end)

wezterm.on("smart_workspace_switcher.workspace_switcher.chosen", function(window, path, _)
  wezterm.log_info(window)
  window:gui_window():set_right_status(wezterm.format({
    { Attribute = { Intensity = "Bold" } },
    { Foreground = { Color = colors.colors.ansi[5] } },
    { Text = basename(path) .. "  " },
  }))
end)

wezterm.on("smart_workspace_switcher.workspace_switcher.selected", function(window, _, label)
  wezterm.log_info(window)
  local workspace_state = resurrect.workspace_state
  resurrect.state_manager.save_state(workspace_state.get_workspace_state())
  resurrect.state_manager.write_current_state(label, "workspace")
end)

wezterm.on("smart_workspace_switcher.workspace_switcher.start", function(window, _)
  wezterm.log_info(window)
end)

wezterm.on("smart_workspace_switcher.workspace_switcher.canceled", function(window, _)
  wezterm.log_info(window)
end)

-- local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
-- smart_splits.apply_to_config(config, {
-- 	direction_keys = { "h", "j", "k", "l" },
-- 	modifiers = {
-- 		move = "CTRL",
-- 		resize = "ALT",
-- 	},
-- })

local domains = wezterm.plugin.require("https://github.com/DavidRR-F/quick_domains.wezterm")
domains.apply_to_config(config, {
  keys = {
    attach = {
      key = "t",
      mods = "ALT|SHIFT",
      tbl = "",
    },
    vsplit = {
      key = "_",
      mods = "CTRL|SHIFT|ALT",
      tbl = "",
    },
    hsplit = {
      key = "-",
      mods = "CTRL|ALT",
      tbl = "",
    },
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

wezterm.on("format-window-title", function(tab, _, tabs, _, _)
  local zoomed = ""
  if tab.active_pane.is_zoomed then
    zoomed = "🔍 "
  end

  local index = ""
  if #tabs > 1 then
    index = string.format("(%d/%d) ", tab.tab_index + 1, #tabs)
  end

  return zoomed .. index .. tab.active_pane.title
end)

-- wezterm.on("gui-startup", resurrect.state_manager.resurrect_on_gui_startup)

-- sessionizer.config = {
--   paths = {
--     "/home/ryan/Workspaces",
--     "/home/ryan/System",
--     "/home/ryan/Documents/notes",
--   },
-- }

return config
