# env.nu

# Core environment settings
$env.EDITOR = "hx"
$env.VISUAL = "hx"
$env.PAGER = "moar"
$env.BROWSER = "brave"

# XDG Base Directory specification (important for modern apps)
$env.XDG_CONFIG_HOME = ($env.HOME | path join ".config")
$env.XDG_DATA_HOME = ($env.HOME | path join ".local/share")
$env.XDG_CACHE_HOME = ($env.HOME | path join ".cache")
$env.XDG_STATE_HOME = ($env.HOME | path join ".local/state")

# Program-specific paths
$env.BAT_THEME = "ansi"
$env.BATDIFF_USE_DELTA = true
$env.MANPAGER = "env BATMAN_IS_BEING_MANPAGER=yes bash /nix/store/q5nqxkdx4b0hywqacrkjbp1nxg01gx6m-batman-2024.07.10/bin/.batman-wrapped"
$env.MANROFFOPT = "-"
$env.GIT_PAGER = "moar"
$env.DELTA_PAGER = "moar"
$env.GOPATH = ($env.XDG_DATA_HOME | path join "go")
$env.CARGO_HOME = ($env.XDG_DATA_HOME | path join "cargo")
$env.RUSTUP_HOME = ($env.XDG_DATA_HOME | path join "rustup")
$env.KREW_ROOT = ($env.XDG_DATA_HOME | path join "krew")

# Path configuration
$env.PATH = $env.PATH | append ([
    ($env.HOME | path join ".local/bin")
    ($env.HOME | path join "System/bin")
    ($env.GOPATH | path join "bin")
    ($env.CARGO_HOME | path join "bin")
    ($env.KREW_ROOT | path join "bin")
] | path expand) | uniq

## Programs

# Zoxide
zoxide init nushell | save -f ~/.cache/nushell/zoxide.nu

# Carapace
$env.CARAPACE_BRIDGES = 'bash,inshellisense'
mkdir ~/.cache/carapace
carapace _carapace nushell | save --force ~/.cache/carapace/init.nu

# Flux
mkdir ~/.local/share/bash-completion/completions
flux completion bash | save -f ~/.local/share/bash-completion/completions/flux
