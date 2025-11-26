--[[
  Module: tabs.lua
  Purpose: Custom tab bar with process icons, zoom indicator, and arrow separators
  Dependencies: wezterm

  Features:
  - Process-specific nerd font icons (25+ applications)
  - Zoom indicator (🔍) in tab title
  - Arrow separators between tabs (solid/thin based on state)
  - Dynamic working directory fallback for editors like Helix
  - Auto-hide tab bar when only one tab
]]
--

local wezterm = require("wezterm")

local M = {}
M.arrow_solid = ""
M.arrow_thin = ""

-- Icons with path context (show: icon + directory/path)
M.icons_with_path = {
  ["bash"] = wezterm.nerdfonts.cod_terminal_bash,
  ["fish"] = wezterm.nerdfonts.md_fish,
  ["zsh"] = wezterm.nerdfonts.dev_terminal,
  ["hx"] = wezterm.nerdfonts.md_dna,
  ["nvim"] = wezterm.nerdfonts.custom_vim,
  ["vim"] = wezterm.nerdfonts.dev_vim,
  ["lazygit"] = wezterm.nerdfonts.md_git,
  ["git"] = wezterm.nerdfonts.dev_git,
  ["yazi"] = wezterm.nerdfonts.md_folder,
  ["cargo"] = wezterm.nerdfonts.dev_rust,
  ["go"] = wezterm.nerdfonts.seti_go,
  ["lua"] = wezterm.nerdfonts.seti_lua,
  ["make"] = wezterm.nerdfonts.seti_makefile,
  ["just"] = wezterm.nerdfonts.seti_makefile,
  ["node"] = wezterm.nerdfonts.mdi_hexagon,
  ["ruby"] = wezterm.nerdfonts.cod_ruby,
}

-- Standalone icons (show: icon + program name, path not relevant)
M.icons_standalone = {
  ["k9s"] = wezterm.nerdfonts.dev_kubernetes,
  ["kubectl"] = wezterm.nerdfonts.md_docker,
  ["kuberlr"] = wezterm.nerdfonts.md_docker,
  ["lazydocker"] = wezterm.nerdfonts.md_docker,
  ["docker"] = wezterm.nerdfonts.md_docker,
  ["docker-compose"] = wezterm.nerdfonts.md_docker,
  ["spotify_player"] = wezterm.nerdfonts.md_spotify,
  ["btm"] = wezterm.nerdfonts.mdi_chart_donut_variant,
  ["htop"] = wezterm.nerdfonts.md_chart_areaspline,
  ["btop"] = wezterm.nerdfonts.md_chart_areaspline,
  ["brew"] = wezterm.nerdfonts.md_beer,
  ["curl"] = wezterm.nerdfonts.mdi_flattr,
  ["wget"] = wezterm.nerdfonts.mdi_arrow_down_box,
  ["gh"] = wezterm.nerdfonts.dev_github_badge,
  ["psql"] = wezterm.nerdfonts.dev_postgresql,
  ["pwsh.exe"] = wezterm.nerdfonts.md_console,
  ["sudo"] = wezterm.nerdfonts.fa_hashtag,
  ["pacman"] = "󰮯 ",
  ["paru"] = "󰮯 ",
}

---Extract and format tab title with icon and context
---@param tab MuxTabObj
---@param max_width number
function M.title(tab, max_width)
  local title = (tab.tab_title and #tab.tab_title > 0) and tab.tab_title or tab.active_pane.title
  local bin, other = title:match("^(%S+)%s*%-?%s*%s*(.*)$")

  -- Check if we have an icon for this program (with path context)
  if M.icons_with_path[bin] then
    -- Fallback: If no context info, try to get from pane (fixes Helix/Fish empty titles)
    if not other or other == "" then
      local pane = tab.active_pane
      if pane.current_working_dir then
        local cwd = pane.current_working_dir.file_path or ""
        -- Normalize path by removing trailing slash for comparison
        local cwd_normalized = cwd:gsub("/$", "")
        local home_normalized = wezterm.home_dir:gsub("/$", "")

        -- Show ~ for home directory, otherwise show directory name
        if cwd_normalized == home_normalized or cwd_normalized == "" then
          other = "~"
        else
          local dir_name = cwd_normalized:match("([^/]+)$") or ""
          if dir_name ~= "" then
            other = dir_name
          end
        end
      end
    end

    -- Ensure we have some context - default to ~ if empty
    if not other or other == "" then
      other = "~"
    end

    title = M.icons_with_path[bin] .. " " .. other
  elseif M.icons_standalone[bin] then
    -- For standalone icons, just use icon + program name (ignore path)
    title = M.icons_standalone[bin] .. " " .. bin
  end
  -- else: leave title as-is for programs not in either list

  local is_zoomed = false
  for _, pane in ipairs(tab.panes) do
    if pane.is_zoomed then
      is_zoomed = true
      break
    end
  end
  if is_zoomed then
    title = "🔍 " .. title
  end

  -- Don't truncate here - tab_max_width config handles it
  return " " .. title .. " "
end

---@param config Config
function M.apply_to_config(config)
  config.use_fancy_tab_bar = true
  config.tab_bar_at_bottom = false
  config.hide_tab_bar_if_only_one_tab = true
  config.tab_max_width = 60
  config.unzoom_on_switch_pane = true

  wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    local title = M.title(tab, max_width)
    local colors = config.resolved_palette
    local active_bg = colors.tab_bar.active_tab.bg_color
    local inactive_bg = colors.tab_bar.inactive_tab.bg_color

    local tab_idx = 1
    for i, t in ipairs(tabs) do
      if t.tab_id == tab.tab_id then
        tab_idx = i
        break
      end
    end
    local is_last = tab_idx == #tabs
    local next_tab = tabs[tab_idx + 1]
    local next_is_active = next_tab and next_tab.is_active
    local arrow = (tab.is_active or is_last or next_is_active) and M.arrow_solid or M.arrow_thin
    local arrow_bg = inactive_bg
    local arrow_fg = colors.tab_bar.inactive_tab_edge

    if is_last then
      arrow_fg = tab.is_active and active_bg or inactive_bg
      arrow_bg = colors.tab_bar.background
    elseif tab.is_active then
      arrow_bg = inactive_bg
      arrow_fg = active_bg
    elseif next_is_active then
      arrow_bg = active_bg
      arrow_fg = inactive_bg
    end

    local ret = tab.is_active
        and {
          { Attribute = { Intensity = "Bold" } },
          { Attribute = { Italic = true } },
        }
      or {}
    ret[#ret + 1] = { Text = title }
    ret[#ret + 1] = { Foreground = { Color = arrow_fg } }
    ret[#ret + 1] = { Background = { Color = arrow_bg } }
    ret[#ret + 1] = { Text = arrow }
    return ret
  end)
end

return M
