# env.nu: Nushell environment configuration

$env.EDITOR = "hx"
$env.VISUAL = "hx"
$env.PAGER = "moar"
$env.BROWSER = "brave"

$env.LANG = "en_US.UTF-8"
$env.LC_ALL = "en_US.UTF-8"

$env.XDG_CONFIG_HOME = ($env.HOME | path join ".config")
$env.XDG_DATA_HOME = ($env.HOME | path join ".local/share")
$env.XDG_CACHE_HOME = ($env.HOME | path join ".cache")
$env.XDG_STATE_HOME = ($env.HOME | path join ".local/state")

$env.MANPAGER = "env BATMAN_IS_BEING_MANPAGER=yes bash /nix/store/q5nqxkdx4b0hywqacrkjbp1nxg01gx6m-batman-2024.07.10/bin/.batman-wrapped"
$env.MANROFFOPT = "-"
$env.GIT_PAGER = "moar"
$env.DELTA_PAGER = "moar"
$env.GOPATH = ($env.XDG_DATA_HOME | path join "go")
$env.CARGO_HOME = ($env.XDG_DATA_HOME | path join "cargo")
$env.RUSTUP_HOME = ($env.XDG_DATA_HOME | path join "rustup")
$env.KREW_ROOT = ($env.XDG_DATA_HOME | path join "krew")

$env.FZF_DEFAULT_OPTS = "
    --layout=reverse
    --info=inline-right
    --height=60%
    --preview-window='right'
    --border=sharp
    --prompt=''
    --color=fg:-1,bg:-1,hl:5,fg+:2,bg+:-1,hl+:5
    --color=info:-1,pointer:2,spinner:2
    --bind='f2:toggle-preview'
    --bind 'ctrl-d:preview-page-down'
    --bind 'ctrl-u:preview-page-up'
    --bind 'ctrl-f:preview-down'
    --bind 'ctrl-b:preview-up'
"

$env.PATH = ($env.PATH | split row (char esep) | append [
    ($env.HOME | path join ".local/bin")
    ($env.HOME | path join ".nix-profile/bin")
    ($env.HOME | path join "System/bin")
    ($env.GOPATH | path join "bin")
    ($env.CARGO_HOME | path join "bin")
    ($env.KREW_ROOT | path join "bin")
] | path expand | uniq | str join (char esep)) 

use hooks.nu

hooks carapace init
hooks flux init
hooks starship init
hooks zoxide init

# env.nu ends here
