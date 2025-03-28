local wezterm = require("wezterm")
local act = wezterm.action
local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")

local keys = {
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
    key = "g",
    mods = "LEADER",
    action = wezterm.action_callback(function(window, pane)
      local current_tab_id = pane:tab():tab_id()
      local cmd = "lazygit ; wezterm cli activate-tab --tab-id " .. current_tab_id .. " ; exit\n"
      local tab, tab_pane, _ = window:mux_window():spawn_tab({})
      tab_pane:send_text(cmd)
      tab:set_title(wezterm.nerdfonts.dev_git .. " Lazygit")
    end),
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
    key = "o",
    mods = "LEADER",
    action = wezterm.action.ActivateLastTab,
  },
  {
    key = "t",
    mods = "LEADER",
    action = act.SpawnTab("CurrentPaneDomain"),
  },
  {
    key = "w",
    mods = "LEADER",
    action = wezterm.action.CloseCurrentPane({ confirm = true }),
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
    key = "d",
    mods = "LEADER",
    action = wezterm.action_callback(function(window, pane)
      window:perform_action(
        act.SwitchToWorkspace({
          name = "System",
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
        local type = string.match(id, "^([^/]+)") -- match before '/'
        id = string.match(id, "([^/]+)$") -- match after '/'
        id = string.match(id, "(.+)%..+$") -- remove file extention
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
        local type = string.match(id, "^([^/]+)") -- match before '/'
        id = string.match(id, "([^/]+)$") -- match after '/'
        id = string.match(id, "(.+)%..+$") -- remove file extention
        local opts = {
          relative = true,
          restore_text = true,
          window = pane:window(),
          -- tab = win:active_tab(),
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

  -- { key = "|", mods = "LEADER|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  -- { key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

  { key = "UpArrow", mods = "ALT", action = act({ SpawnTab = "CurrentPaneDomain" }) },
  { key = "DownArrow", mods = "ALT", action = act({ CloseCurrentTab = { confirm = true } }) },
  { key = "LeftArrow", mods = "ALT", action = act({ ActivateTabRelative = -1 }) },
  { key = "RightArrow", mods = "ALT", action = act({ ActivateTabRelative = 1 }) },
  { key = "LeftArrow", mods = "ALT|SHIFT", action = act({ MoveTabRelative = -1 }) },
  { key = "RightArrow", mods = "ALT|SHIFT", action = act({ MoveTabRelative = 1 }) },
  { key = "1", mods = "ALT", action = act({ ActivateTab = 0 }) },
  { key = "2", mods = "ALT", action = act({ ActivateTab = 1 }) },
  { key = "3", mods = "ALT", action = act({ ActivateTab = 2 }) },
  { key = "4", mods = "ALT", action = act({ ActivateTab = 3 }) },
  { key = "5", mods = "ALT", action = act({ ActivateTab = 4 }) },
  { key = "6", mods = "ALT", action = act({ ActivateTab = 5 }) },
  { key = "7", mods = "ALT", action = act({ ActivateTab = 6 }) },
  { key = "8", mods = "ALT", action = act({ ActivateTab = 7 }) },
  { key = "9", mods = "ALT", action = act({ ActivateTab = 8 }) },

  -- Copy/Paste
  -- {
  --   key = "e",
  --   mods = "ALT|CTRL",
  --   action = act.Multiple({ act.CopyMode("ClearSelectionMode"), act.ActivateCopyMode, act.ClearSelection }),
  -- },
  -- { key = "n", mods = "ALT|CTRL", action = act({ PasteFrom = "PrimarySelection" }) },

  -- Resizing Panes
  -- {
  --   key = "LeftArrow",
  --   mods = "LEADER|SHIFT",
  --   action = act.Multiple({
  --     act.AdjustPaneSize({ "Left", pane_resize }),
  --     act.ActivateKeyTable({ name = "resize_pane", one_shot = false, until_unknown = true }),
  --   }),
  -- },
  -- {
  --   key = "DownArrow",
  --   mods = "LEADER|SHIFT",
  --   action = act.Multiple({
  --     act.AdjustPaneSize({ "Down", pane_resize }),
  --     act.ActivateKeyTable({ name = "resize_pane", one_shot = false, until_unknown = true }),
  --   }),
  -- },
  -- {
  --   key = "UpArrow",
  --   mods = "LEADER|SHIFT",
  --   action = act.Multiple({
  --     act.AdjustPaneSize({ "Up", pane_resize }),
  --     act.ActivateKeyTable({ name = "resize_pane", one_shot = false, until_unknown = true }),
  --   }),
  -- },
  -- {
  --   key = "RightArrow",
  --   mods = "LEADER|SHIFT",
  --   action = act.Multiple({
  --     act.AdjustPaneSize({ "Right", pane_resize }),
  --     act.ActivateKeyTable({ name = "resize_pane", one_shot = false, until_unknown = true }),
  --   }),
  -- },
}

return keys
