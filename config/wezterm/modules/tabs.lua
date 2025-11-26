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
M.icons = {
  ["bash"] = wezterm.nerdfonts.cod_terminal_bash,
  ["brew"] = wezterm.nerdfonts.md_beer,
  ["btm"] = wezterm.nerdfonts.mdi_chart_donut_variant,
  ["cargo"] = wezterm.nerdfonts.dev_rust,
  ["curl"] = wezterm.nerdfonts.mdi_flattr,
  ["docker"] = wezterm.nerdfonts.md_docker,
  ["docker-compose"] = wezterm.nerdfonts.md_docker,
  ["fish"] = wezterm.nerdfonts.md_fish,
  ["gh"] = wezterm.nerdfonts.dev_github_badge,
  ["git"] = wezterm.nerdfonts.dev_git,
  ["go"] = wezterm.nerdfonts.seti_go,
  ["hx"] = wezterm.nerdfonts.md_dna,
  ["htop"] = wezterm.nerdfonts.md_chart_areaspline,
  ["btop"] = wezterm.nerdfonts.md_chart_areaspline,
  ["kubectl"] = wezterm.nerdfonts.md_docker,
  ["kuberlr"] = wezterm.nerdfonts.md_docker,
  ["k9s"] = wezterm.nerdfonts.dev_kubernetes,
  ["lazydocker"] = wezterm.nerdfonts.md_docker,
  ["lazygit"] = wezterm.nerdfonts.md_git,
  ["lua"] = wezterm.nerdfonts.seti_lua,
  ["make"] = wezterm.nerdfonts.seti_makefile,
  ["just"] = wezterm.nerdfonts.seti_makefile,
  ["node"] = wezterm.nerdfonts.mdi_hexagon,
  ["nvim"] = wezterm.nerdfonts.custom_vim,
  ["pacman"] = "󰮯 ",
  ["paru"] = "󰮯 ",
  ["psql"] = wezterm.nerdfonts.dev_postgresql,
  ["pwsh.exe"] = wezterm.nerdfonts.md_console,
  ["ruby"] = wezterm.nerdfonts.cod_ruby,
  ["sudo"] = wezterm.nerdfonts.fa_hashtag,
  ["spotify_player"] = wezterm.nerdfonts.md_spotify,
  ["vim"] = wezterm.nerdfonts.dev_vim,
  ["wget"] = wezterm.nerdfonts.mdi_arrow_down_box,
  ["zsh"] = wezterm.nerdfonts.dev_terminal,
  ["yazi"] = wezterm.nerdfonts.md_folder,
}

---Extract and format tab title with icon and context
---@param tab MuxTabObj
---@param max_width number
function M.title(tab, max_width)
  local title = (tab.tab_title and #tab.tab_title > 0) and tab.tab_title or tab.active_pane.title
  local bin, other = title:match("^(%S+)%s*%-?%s*%s*(.*)$")

  -- Only substitute icon if we have one defined for this program
  if M.icons[bin] then
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

    title = M.icons[bin] .. " " .. other
  end

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
