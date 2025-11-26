--[[
  Module: keys.lua
  Purpose: Keyboard bindings with leader key pattern and custom actions
  Dependencies: wezterm, smart_workspace_switcher plugin

  Features:
  - Leader key: CMD+Space (5-second timeout)
  - Workspace management (switcher, jump to System)
  - Git management (LEADER+g submenu: split/tab/diff operations)
  - Claude workspace management (LEADER+c submenu: create/list/delete workspaces)
  - Application launchers organized by category
  - Pane management (split, zoom, resize)
  - Tab management (new, close, move)
  - Quick Select mode (LEADER+q)
  - Pane resizing (LEADER+SHIFT+Arrow sticky mode)
]]
--

local wezterm = require("wezterm")
local act = wezterm.action
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")

local M = {}

M.mod = "CMD"

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================

-- Lazygit in smart split
M.lazygit_smart_split = wezterm.action_callback(function(window, pane)
  local dims = pane:get_dimensions()
  -- If window is taller than wide (portrait): split horizontally (top/bottom) = "Bottom"
  -- If window is wider than tall (landscape): split vertically (left/right) = "Right"
  local direction = dims.pixel_height > dims.pixel_width and "Bottom" or "Right"

  pane:split({
    direction = direction,
    size = 0.5,
    args = { "lazygit", "-sm", "half" },
  })
end)

-- Git diff in smart split with riff + delta formatting
-- Uses login shell to respect user environment and git configuration
M.git_diff_smart_split = wezterm.action_callback(function(window, pane)
  local dims = pane:get_dimensions()
  -- If window is taller than wide (portrait): split horizontally (top/bottom) = "Bottom"
  -- If window is wider than tall (landscape): split vertically (left/right) = "Right"
  local direction = dims.pixel_height > dims.pixel_width and "Bottom" or "Right"

  pane:split({
    direction = direction,
    size = 0.5,
    args = {
      os.getenv("SHELL") or "/bin/bash",
      "-lc",
      "git diff main 2>/dev/null || git diff master 2>/dev/null || git diff origin/main 2>/dev/null || git diff origin/master 2>/dev/null || git status",
    },
  })
end)

-- Git diff in new window with riff + delta formatting
-- Uses login shell to respect user environment and git configuration
M.git_diff_new_window = act.SpawnCommandInNewWindow({
  args = {
    os.getenv("SHELL") or "/bin/bash",
    "-lc",
    "git diff main 2>/dev/null || git diff master 2>/dev/null || git diff origin/main 2>/dev/null || git diff origin/master 2>/dev/null || git status",
  },
})

-- Create and open claudectl workspace
M.create_claudectl_workspace = wezterm.action_callback(function(window, pane)
  -- Use wezterm's input line to get workspace name
  window:perform_action(
    act.PromptInputLine({
      description = wezterm.format({
        { Foreground = { Color = "#56be8d" } },
        { Text = "Enter workspace name: " },
      }),
      action = wezterm.action_callback(function(inner_window, inner_pane, line)
        if not line or line == "" then
          return
        end

        -- Create workspace and open claude in the workspace directory
        -- Get pane's cwd so claudectl runs in the right git context
        local cwd_uri = pane:get_current_working_dir()
        local cwd = cwd_uri and cwd_uri.file_path or wezterm.home_dir

        local cmd = "cd "
          .. wezterm.shell_quote_arg(cwd)
          .. " && claudectl workspace create "
          .. wezterm.shell_quote_arg(line)
          .. ' && cd "$(cd '
          .. wezterm.shell_quote_arg(cwd)
          .. " && claudectl workspace show "
          .. wezterm.shell_quote_arg(line)
          .. ')" && claude'
        inner_window:perform_action(
          act.SpawnCommandInNewTab({
            args = { os.getenv("SHELL") or "/bin/bash", "-lc", cmd },
          }),
          inner_pane
        )
      end),
    }),
    pane
  )
end)

-- Select workspace and launch Claude in its directory using wezterm's fuzzy InputSelector
M.list_claudectl_sessions = wezterm.action_callback(function(window, pane)
  -- Get pane's current working directory
  local cwd_uri = pane:get_current_working_dir()
  local cwd = cwd_uri and cwd_uri.file_path or wezterm.home_dir

  local success, output, stderr = wezterm.run_child_process({
    os.getenv("SHELL") or "/bin/bash",
    "-lc",
    "cd " .. wezterm.shell_quote_arg(cwd) .. " && claudectl workspace list --json",
  })

  if not success then
    window:toast_notification("WezTerm", "Command failed: " .. (stderr or "unknown error"), nil, 3000)
    return
  end

  if not output or output == "" then
    window:toast_notification("WezTerm", "Empty output from claudectl", nil, 3000)
    return
  end

  -- Parse JSON output
  local ok, workspaces = pcall(wezterm.json_parse, output)
  if not ok then
    window:toast_notification("WezTerm", "JSON parse error", nil, 3000)
    return
  end

  if not workspaces or #workspaces == 0 then
    window:toast_notification("WezTerm", "No workspaces in JSON", nil, 3000)
    return
  end

  local choices = {}
  for _, ws in ipairs(workspaces) do
    if ws.branch then
      table.insert(choices, { id = ws.branch, label = ws.branch })
    end
  end

  if #choices == 0 then
    window:toast_notification("WezTerm", "No valid branches found", nil, 3000)
    return
  end

  window:perform_action(
    act.InputSelector({
      title = "Select Workspace",
      choices = choices,
      fuzzy = true,
      fuzzy_description = "Filter: ",
      action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
        if id then
          -- Run claudectl workspace show from the pane's cwd context
          local workspace_path_cmd = "cd "
            .. wezterm.shell_quote_arg(cwd)
            .. " && claudectl workspace show "
            .. wezterm.shell_quote_arg(id)
          local cmd_success, workspace_path = wezterm.run_child_process({
            os.getenv("SHELL") or "/bin/bash",
            "-lc",
            workspace_path_cmd,
          })
          if cmd_success and workspace_path then
            workspace_path = workspace_path:gsub("\n", ""):gsub("\r", "")
            inner_window:perform_action(
              act.SpawnCommandInNewTab({
                args = {
                  os.getenv("SHELL") or "/bin/bash",
                  "-lc",
                  "cd " .. wezterm.shell_quote_arg(workspace_path) .. " && claude",
                },
              }),
              inner_pane
            )
          else
            inner_window:toast_notification("WezTerm", "Failed to get workspace path", nil, 3000)
          end
        end
      end),
    }),
    pane
  )
end)

-- Delete workspace with fuzzy selection using wezterm's InputSelector
M.delete_claudectl_session = wezterm.action_callback(function(window, pane)
  -- Get pane's current working directory
  local cwd_uri = pane:get_current_working_dir()
  local cwd = cwd_uri and cwd_uri.file_path or wezterm.home_dir

  local success, output, stderr = wezterm.run_child_process({
    os.getenv("SHELL") or "/bin/bash",
    "-lc",
    "cd " .. wezterm.shell_quote_arg(cwd) .. " && claudectl workspace list --json",
  })

  if not success or not output or output == "" then
    window:toast_notification("WezTerm", "No workspaces found", nil, 3000)
    return
  end

  -- Parse JSON output
  local ok, workspaces = pcall(wezterm.json_parse, output)
  if not ok or not workspaces or #workspaces == 0 then
    window:toast_notification("WezTerm", "No workspaces found", nil, 3000)
    return
  end

  local choices = {}
  for _, ws in ipairs(workspaces) do
    if ws.branch then
      table.insert(choices, { id = ws.branch, label = ws.branch })
    end
  end

  if #choices == 0 then
    window:toast_notification("WezTerm", "No workspaces found", nil, 3000)
    return
  end

  window:perform_action(
    act.InputSelector({
      title = "Delete Workspace",
      choices = choices,
      fuzzy = true,
      fuzzy_description = "Filter: ",
      action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
        if id then
          -- Run claudectl workspace delete from the pane's cwd context
          local del_cmd = "cd "
            .. wezterm.shell_quote_arg(cwd)
            .. " && claudectl workspace delete "
            .. wezterm.shell_quote_arg(id)
          local del_success, del_stdout, del_stderr = wezterm.run_child_process({
            os.getenv("SHELL") or "/bin/bash",
            "-lc",
            del_cmd,
          })
          if del_success then
            inner_window:toast_notification("WezTerm", "Deleted workspace: " .. label, nil, 3000)
          else
            local error_msg = del_stderr and del_stderr:gsub("\n", " ") or "unknown error"
            inner_window:toast_notification("WezTerm", "Delete failed: " .. error_msg, nil, 5000)
          end
        end
      end),
    }),
    pane
  )
end)

wezterm.on("mux-is-process-stateful", function(_proc)
  return false
end)

---@param config Config
function M.apply_to_config(config)
  config.disable_default_key_bindings = false
  config.leader = { key = "Space", mods = "CMD", timeout_milliseconds = 5000 }

  -- ============================================================================
  -- KEY TABLES (Modal/Submenu Keybindings)
  -- ============================================================================
  config.key_tables = {
    -- Resize pane mode: LEADER+SHIFT+Arrow activates, then use arrows to resize
    resize_pane = {
      { key = "LeftArrow", action = act.AdjustPaneSize({ "Left", 2 }) },
      { key = "RightArrow", action = act.AdjustPaneSize({ "Right", 2 }) },
      { key = "UpArrow", action = act.AdjustPaneSize({ "Up", 2 }) },
      { key = "DownArrow", action = act.AdjustPaneSize({ "Down", 2 }) },
      { key = "Escape", action = "PopKeyTable" },
      { key = "Enter", action = "PopKeyTable" },
    },

    -- Git subcommands: LEADER+g activates
    git = {
      { key = "g", action = M.lazygit_smart_split }, -- LEADER+g g: lazygit smart split
      { key = "G", action = act.SpawnCommandInNewTab({ args = { "lazygit" } }) }, -- LEADER+g G: lazygit new tab
      { key = "d", action = M.git_diff_smart_split }, -- LEADER+g d: diff main smart split
      { key = "D", action = M.git_diff_new_window }, -- LEADER+g D: diff main new window
      { key = "Escape", action = "PopKeyTable" },
    },

    -- Claude subcommands: LEADER+c activates
    claude = {
      { key = "c", action = act.SpawnCommandInNewTab({ args = { "fish", "-c", "claude" } }) }, -- LEADER+c c: new claude
      { key = "C", action = M.create_claudectl_workspace }, -- LEADER+c C: create workspace
      { key = "s", action = M.list_claudectl_sessions }, -- LEADER+c s: select workspace and open Claude
      { key = "d", action = M.delete_claudectl_session }, -- LEADER+c d: delete workspace
      { key = "Escape", action = "PopKeyTable" },
    },
  }

  -- ============================================================================
  -- MAIN KEYBINDINGS
  -- ============================================================================
  config.keys = {
    -- Workspace management
    { key = "s", mods = "LEADER", action = workspace_switcher.switch_workspace() },
    { key = "S", mods = "LEADER", action = workspace_switcher.switch_to_prev_workspace() },
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

    -- Domain management
    { key = "a", mods = "LEADER", action = act.AttachDomain("unix") },
    { key = "d", mods = "LEADER", action = act.DetachDomain({ DomainName = "unix" }) },

    -- ========== GIT SUBMENU ==========
    {
      key = "g",
      mods = "LEADER",
      action = act.ActivateKeyTable({
        name = "git",
        one_shot = false,
        until_unknown = true,
      }),
    },

    -- ========== CLAUDE SUBMENU ==========
    {
      key = "c",
      mods = "LEADER",
      action = act.ActivateKeyTable({
        name = "claude",
        one_shot = false,
        until_unknown = true,
      }),
    },

    -- ========== FILE MANAGERS & SYSTEM ==========
    { key = "y", mods = "LEADER", action = act.SpawnCommandInNewTab({ args = { "yazi" } }) },
    { key = "Y", mods = "LEADER", action = act.SpawnCommandInNewTab({ args = { "sudo", "yazi", "/" } }) },
    { key = "h", mods = "LEADER", action = act.SpawnCommandInNewTab({ args = { "btm" } }) },

    -- ========== DEVOPS & INFRASTRUCTURE ==========
    { key = "k", mods = "LEADER", action = act.SpawnCommandInNewTab({ args = { "k9s" } }) },
    { key = "D", mods = "LEADER", action = act.SpawnCommandInNewTab({ args = { "lazydocker" } }) },

    -- ========== EDITORS & DEVELOPMENT ==========
    { key = "E", mods = "LEADER", action = act.SpawnCommandInNewTab({ args = { "fish", "-c", "hx ." } }) },
    {
      key = "C",
      mods = "LEADER",
      action = wezterm.action_callback(function(_, pane)
        local cwd_uri = pane:get_current_working_dir()
        local cwd = cwd_uri and cwd_uri.file_path or wezterm.home_dir
        wezterm.background_child_process({ "cursor", cwd })
      end),
    },

    -- ========== MEDIA & ENTERTAINMENT ==========
    { key = "m", mods = "LEADER", action = act.SpawnCommandInNewTab({ args = { "spotify_player" } }) },

    -- ========== PANE MANAGEMENT ==========
    { key = "-", mods = "LEADER", action = act.SplitPane({ direction = "Down", size = { Percent = 30 } }) },
    { key = "|", mods = "LEADER|SHIFT", action = act.SplitPane({ direction = "Right", size = { Percent = 25 } }) },
    { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
    { key = "p", mods = "LEADER", action = act.PaneSelect({}) },
    { key = "P", mods = "LEADER", action = act.PaneSelect({ mode = "SwapWithActive" }) },
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

    -- ========== TAB MANAGEMENT ==========
    { key = "t", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
    { key = "w", mods = "LEADER", action = act.CloseCurrentTab({ confirm = false }) },

    -- ========== PANE NAVIGATION ==========
    { key = "LeftArrow", mods = "CTRL", action = act.ActivatePaneDirection("Left") },
    { key = "RightArrow", mods = "CTRL", action = act.ActivatePaneDirection("Right") },
    { key = "UpArrow", mods = "CTRL", action = act.ActivatePaneDirection("Up") },
    { key = "DownArrow", mods = "CTRL", action = act.ActivatePaneDirection("Down") },

    -- ========== PANE RESIZING ==========
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

    -- ========== UTILITY & SELECTION ==========
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
      key = "e",
      mods = "LEADER",
      action = act.CharSelect({
        copy_on_select = true,
        copy_to = "ClipboardAndPrimarySelection",
      }),
    },

    -- ========== SCROLLING & MISC ==========
    { key = "UpArrow", mods = "SHIFT", action = act.ScrollToPrompt(-1) },
    { key = "DownArrow", mods = "SHIFT", action = act.ScrollToPrompt(1) },
    { key = "Enter", mods = "LEADER", action = act.ToggleFullScreen },
    { key = "L", mods = "LEADER", action = act.ShowDebugOverlay },

    -- ========== CLAUDE PROMPT HANDLING ==========
    { key = "Enter", mods = "SHIFT", action = act.SendString("\x1b\r") },

    -- ========== DISABLE DEFAULT ASSIGNMENTS ==========
    { key = "Tab", mods = "CTRL", action = act.DisableDefaultAssignment },
    { key = "Tab", mods = "CTRL|SHIFT", action = act.DisableDefaultAssignment },
  }
end

return M
