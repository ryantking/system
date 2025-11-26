--[[
  Module: keys.lua
  Purpose: Keyboard bindings with leader key pattern and custom actions
  Dependencies: wezterm, smart_workspace_switcher plugin

  Features:
  - Leader key: CMD+Space (5-second timeout)
  - Workspace management (switcher, jump to System)
  - Application launchers (lazygit, yazi, k9s, etc.)
  - Pane management (split, zoom, resize)
  - Tab management (new, close, move)
  - Quick Select mode (LEADER+q)
  - Pane resizing (LEADER+SHIFT+Arrow sticky mode)
  - Domain management (attach/detach unix domain)
]]
--

local wezterm = require("wezterm")
local act = wezterm.action
-- local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")

local M = {}

M.mod = "CMD"

M.smart_split = wezterm.action_callback(function(window, pane)
  local dim = pane:get_dimensions()
  if dim.pixel_height > dim.pixel_width then
    window:perform_action(act.SplitVertical({ domain = "CurrentPaneDomain" }), pane)
  else
    window:perform_action(act.SplitHorizontal({ domain = "CurrentPaneDomain" }), pane)
  end
end)

wezterm.on("mux-is-process-stateful", function(_proc)
  return false
end)
---@param config Config
function M.apply_to_config(config)
  config.disable_default_key_bindings = false
  config.leader = { key = "Space", mods = "CMD", timeout_milliseconds = 5000 }

  -- Key tables for sticky modes
  config.key_tables = {
    resize_pane = {
      { key = "LeftArrow", action = act.AdjustPaneSize({ "Left", 2 }) },
      { key = "RightArrow", action = act.AdjustPaneSize({ "Right", 2 }) },
      { key = "UpArrow", action = act.AdjustPaneSize({ "Up", 2 }) },
      { key = "DownArrow", action = act.AdjustPaneSize({ "Down", 2 }) },
      { key = "Escape", action = "PopKeyTable" },
      { key = "Enter", action = "PopKeyTable" },
    },
  }

  config.keys = {
    {
      key = "s",
      mods = "LEADER",
      action = workspace_switcher.switch_workspace(),
    },
    {
      key = "S",
      mods = "LEADER",
      action = workspace_switcher.switch_to_prev_workspace(),
    },
    {
      key = "a",
      mods = "LEADER",
      action = act.AttachDomain("unix"),
    },
    {
      key = "d",
      mods = "LEADER",
      action = act.DetachDomain({ DomainName = "unix" }),
    },
    {
      key = "g",
      mods = "LEADER",
      action = act.SpawnCommandInNewTab({ args = { "lazygit" } }),
    },
    {
      key = "y",
      mods = "LEADER",
      action = act.SpawnCommandInNewTab({ args = { "yazi" } }),
    },
    {
      key = "Y",
      mods = "LEADER",
      action = act.SpawnCommandInNewTab({ args = { "sudo", "yazi", "/" } }),
    },
    {
      key = "h",
      mods = "LEADER",
      action = act.SpawnCommandInNewTab({ args = { "btm" } }),
    },
    {
      key = "D",
      mods = "LEADER",
      action = act.SpawnCommandInNewTab({ args = { "lazydocker" } }),
    },
    {
      key = "c",
      mods = "LEADER",
      action = act.SpawnCommandInNewTab({ args = { "fish", "-c", "claude" } }),
    },
    {
      key = "m",
      mods = "LEADER",
      action = act.SpawnCommandInNewTab({ args = { "spotify_player" } }),
    },
    {
      key = "k",
      mods = "LEADER",
      action = act.SpawnCommandInNewTab({ args = { "k9s" } }),
    },
    {
      key = "-",
      mods = "LEADER",
      action = wezterm.action.SplitPane({
        direction = "Down",
        size = { Percent = 30 },
      }),
    },
    {
      key = "|",
      mods = "LEADER|SHIFT",
      action = wezterm.action.SplitPane({
        direction = "Right",
        size = { Percent = 25 },
      }),
    },
    {
      key = "z",
      mods = "LEADER",
      action = wezterm.action.TogglePaneZoomState,
    },
    {
      key = "t",
      mods = "LEADER",
      action = act.SpawnTab("CurrentPaneDomain"),
    },
    {
      key = "w",
      mods = "LEADER",
      action = act.CloseCurrentTab({ confirm = false }),
    },
    {
      key = "p",
      mods = "LEADER",
      action = act.PaneSelect({}),
    },
    {
      key = "P",
      mods = "LEADER",
      action = act.PaneSelect({
        mode = "SwapWithActive",
      }),
    },
    {
      key = "B",
      mods = "LEADER",
      action = wezterm.action_callback(function(window, pane)
        window:perform_action(
          act.SwitchToWorkspace({
            name = "~/System",
            spawn = { cwd = wezterm.home_dir .. "/System" },
          }),
          pane
        )
        window:set_right_status(window:active_workspace())
      end),
    },
    {
      key = "e",
      mods = "LEADER",
      action = wezterm.action.CharSelect({
        copy_on_select = true,
        copy_to = "ClipboardAndPrimarySelection",
      }),
    },
    {
      key = "E",
      mods = "LEADER",
      action = act.SpawnCommandInNewTab({ args = { "fish", "-c", "hx ." } }),
    },
    {
      key = "q",
      mods = "LEADER",
      action = act.QuickSelectArgs({
        label = "open url/path/hash",
        patterns = {
          "https?://\\S+",
          "git@[\\w.-]+:[\\w./-]+",
          "file://\\S+",
          "[~./]\\S+/\\S+",
          "/[a-zA-Z0-9_/-]+",
          "\\b[a-f0-9]{7,40}\\b",
          "\\b\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\b",
          "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}",
        },
      }),
    },
    {
      key = "C",
      mods = "LEADER",
      action = wezterm.action_callback(function(_, pane)
        local cwd_uri = pane:get_current_working_dir()
        local cwd = cwd_uri and cwd_uri.file_path or wezterm.home_dir
        wezterm.background_child_process({ "cursor", cwd })
      end),
    },
    {
      key = "v",
      mods = "LEADER",
      action = wezterm.action_callback(function(_, _)
        local _, b, _ = wezterm.run_child_process({ "ls" })
        wezterm.log_info(type(b))
      end),
    },
    {
      key = "r",
      mods = "LEADER",
      action = wezterm.action_callback(function(win, pane)
        resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id, _)
          local type = string.match(id, "^([^/]+)")
          id = string.match(id, "([^/]+)$")
          id = string.match(id, "(.+)%..+$")
          local opts = {
            relative = true,
            restore_text = true,
            on_pane_restore = resurrect.tab_state.default_on_pane_restore,
          }
          if type == "workspace" then
            local state = resurrect.state_manager.load_state(id, "workspace")
            resurrect.workspace_state.restore_workspace(state, opts)
          elseif type == "window" then
            local state = resurrect.state_manager.load_state(id, "window")
            resurrect.window_state.restore_window(pane:window(), state, opts)
          elseif type == "tab" then
            local state = resurrect.state_manager.load_state(id, "tab")
            resurrect.tab_state.restore_tab(pane:tab(), state, opts)
          end
        end)
      end),
    },
    {
      key = "b",
      mods = "LEADER",
      action = wezterm.action_callback(function(win, pane)
        resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id, _)
          local type = string.match(id, "^([^/]+)")
          id = string.match(id, "([^/]+)$")
          id = string.match(id, "(.+)%..+$")
          local opts = {
            relative = true,
            restore_text = true,
            window = pane:window(),
            close_open_tabs = true,
            on_pane_restore = resurrect.tab_state.default_on_pane_restore,
          }
          if type == "workspace" then
            local state = resurrect.state_manager.load_state(id, "workspace")
            resurrect.workspace_state.restore_workspace(state, opts)
          elseif type == "window" then
            local state = resurrect.state_manager.load_state(id, "window")
            resurrect.window_state.restore_window(pane:window(), state, opts)
          elseif type == "tab" then
            local state = resurrect.state_manager.load_state(id, "tab")
            resurrect.tab_state.restore_tab(pane:tab(), state, opts)
          end
        end)
      end),
    },
    {
      key = "x",
      mods = "LEADER",
      action = wezterm.action_callback(function(win, pane)
        resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id)
          resurrect.state_manager.delete_state(id)
        end, {
          title = "Delete State",
          description = "Select State to Delete and press Enter = accept, Esc = cancel, / = filter",
          fuzzy_description = "Search State to Delete: ",
          is_fuzzy = true,
        })
      end),
    },

    { key = "L", mods = "LEADER", action = wezterm.action.ShowDebugOverlay },
    { key = "UpArrow", mods = "SHIFT", action = act.ScrollToPrompt(-1) },
    { key = "DownArrow", mods = "SHIFT", action = act.ScrollToPrompt(1) },

    {
      key = "n",
      mods = "LEADER",
      action = wezterm.action_callback(function(_, pane)
        pane:move_to_new_tab()
      end),
    },
    {
      key = "N",
      mods = "LEADER",
      action = wezterm.action_callback(function(_, pane)
        pane:move_to_new_window()
      end),
    },
    {
      key = "Enter",
      mods = "LEADER",
      action = act.ToggleFullScreen,
    },

    { key = "LeftArrow", mods = "CTRL", action = act.ActivatePaneDirection("Left") },
    { key = "RightArrow", mods = "CTRL", action = act.ActivatePaneDirection("Right") },
    { key = "UpArrow", mods = "CTRL", action = act.ActivatePaneDirection("Up") },
    { key = "DownArrow", mods = "CTRL", action = act.ActivatePaneDirection("Down") },

    -- Pane resizing with sticky mode (LEADER+SHIFT+Arrow)
    {
      key = "LeftArrow",
      mods = "LEADER|SHIFT",
      action = act.Multiple({
        act.AdjustPaneSize({ "Left", 2 }),
        act.ActivateKeyTable({ name = "resize_pane", one_shot = false }),
      }),
    },
    {
      key = "RightArrow",
      mods = "LEADER|SHIFT",
      action = act.Multiple({
        act.AdjustPaneSize({ "Right", 2 }),
        act.ActivateKeyTable({ name = "resize_pane", one_shot = false }),
      }),
    },
    {
      key = "UpArrow",
      mods = "LEADER|SHIFT",
      action = act.Multiple({
        act.AdjustPaneSize({ "Up", 2 }),
        act.ActivateKeyTable({ name = "resize_pane", one_shot = false }),
      }),
    },
    {
      key = "DownArrow",
      mods = "LEADER|SHIFT",
      action = act.Multiple({
        act.AdjustPaneSize({ "Down", 2 }),
        act.ActivateKeyTable({ name = "resize_pane", one_shot = false }),
      }),
    },

    -- Claude Code: Shift+Enter sends Escape+Enter for newlines without submitting
    { key = "Enter", mods = "SHIFT", action = act.SendString("\x1b\r") },

    { key = "Tab", mods = "CTRL", action = act.DisableDefaultAssignment },
    { key = "Tab", mods = "CTRL|SHIFT", action = act.DisableDefaultAssignment },

    -- { mods = "CMD", key = "LeftArrow", action = act.SendKey({ mods = "CTRL|SHIFT", key = "LeftArrow" }) },
    -- { mods = "CMD", key = "RightArrow", action = act.SendKey({ mods = "CTRL|SHIFT", key = "RightArrow" }) },
    -- { mods = "CMD", key = "UpArrow", action = act.SendKey({ mods = "CTRL|SHIFT", key = "UpArrow" }) },
    -- { mods = "CMD", key = "DownArrow", action = act.SendKey({ mods = "CTRL|SHIFT", key = "DownArrow" }) },
    -- { mods = "CMD|SHIFT", key = "LeftArrow", action = act.SendKey({ mods = "ALT|SHIFT", key = "LeftArrow" }) },
    -- { mods = "CMD|SHIFT", key = "RightArrow", action = act.SendKey({ mods = "ALT|SHIFT", key = "RightArrow" }) },
    -- { mods = "CMD", key = "Backspace", action = act.SendKey({ mods = "ALT", key = "Backspace" }) },

    -- { key = "|", mods = "LEADER|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    -- { key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

    -- { key = "UpArrow", mods = "ALT", action = act({ SpawnTab = "CurrentPaneDomain" }) },
    -- { key = "DownArrow", mods = "ALT", action = act({ CloseCurrentTab = { confirm = true } }) },
    -- { key = "LeftArrow", mods = "ALT", action = act({ ActivateTabRelative = -1 }) },
    -- { key = "RightArrow", mods = "ALT", action = act({ ActivateTabRelative = 1 }) },
    -- { key = "LeftArrow", mods = "ALT|SHIFT", action = act({ MoveTabRelative = -1 }) },
    -- { key = "RightArrow", mods = "ALT|SHIFT", action = act({ MoveTabRelative = 1 }) },
    -- { key = "1", mods = "ALT", action = act({ ActivateTab = 0 }) },
    -- { key = "2", mods = "ALT", action = act({ ActivateTab = 1 }) },
    -- { key = "3", mods = "ALT", action = act({ ActivateTab = 2 }) },
    -- { key = "4", mods = "ALT", action = act({ ActivateTab = 3 }) },
    -- { key = "5", mods = "ALT", action = act({ ActivateTab = 4 }) },
    -- { key = "6", mods = "ALT", action = act({ ActivateTab = 5 }) },
    -- { key = "7", mods = "ALT", action = act({ ActivateTab = 6 }) },
    -- { key = "8", mods = "ALT", action = act({ ActivateTab = 7 }) },
    -- { key = "9", mods = "ALT", action = act({ ActivateTab = 8 }) },

    -- Copy/Paste
    -- {
    --   key = "e",
    --   mods = "ALT|CTRL",
    --   action = act.Multiple({ act.CopyMode("ClearSelectionMode"), act.ActivateCopyMode, act.ClearSelection }),
    -- },
    -- { key = "n", mods = "ALT|CTRL", action = act({ PasteFrom = "PrimarySelection" }) },

    -- Resizing Panes (replaced by LEADER+SHIFT+Arrow above)
    -- {
    --   key = "LeftArrow",
    --   mods = "LEADER|SHIFT",
    --   action = act.Multiple({
    --     act.AdjustPaneSize({ "Left", pane_resize }),
    --     act.ActivateKeyTable({ name = "resize_pane", one_shot = false, until_unknown = true }),
    --   }),
    -- },
  }
end

return M
