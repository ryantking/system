# theme.fish: Customizations for fish visuals

if not set -qU _fish_theme_configured
    base16-horizon-terminal-dark

    set -U fish_greeting

    set -U hydro_color_prompt magenta
    set -U hydro_color_error red
    set -U hydro_color_pwd blue
    set -U hydro_color_git 6C6F93
    set -U hydro_color_duration yellow
    set -U hydro_color_who green
    set -U hydro_multiline blue

    set -U _fish_theme_configured
end

set -g fish_color_autosuggestion 6C6F93
set -g fish_color_comment 6C6F93

# theme.fish ends here
