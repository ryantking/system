## Libraries

source ~/.cache/carapace/init.nu
source ~/.cache/nushell/bash-env.nu
source ~/.cache/nushell/did_you_mean.nu
# source ~/.cache/nushell/zoxide.nu

## Plugins

# plugin add "$(readlink ~/.nix-profile/bin/nu_plugin_skim)"
# plugin add "$(readlink ~/.nix-profile/bin/nu_plugin_query)"

## Configuration

$env.config.show_banner = false
$env.config.buffer_editor = "hx"
$env.config.table.mode = "light"

$env.config.history = {
  file_format: sqlite
  max_size: 1_000_000
  sync_on_enter: true
  isolation: true
}

## Completion

let zoxide_completer = {|spans|
    $spans | skip 1 | zoxide query -l ...$in | lines | where {|x| $x != $env.PWD}
}

let external_completer = {|spans|
    let expanded_alias = scope aliases
    | where name == $spans.0
    | get -i 0.expansion

    let spans = if $expanded_alias != null {
        $spans
        | skip 1
        | prepend ($expanded_alias | split row ' ' | take 1)
    } else {
        $spans
    }

    match $spans.0 {
        __zoxide_z | __zoxide_zi => $zoxide_completer
        _ => $carapace_completer
    } | do $in $spans
}

$env.config.completions.external = {
  enable: true
  completer: $external_completer
}

## Aliases

alias apt = sudo apt
alias g = git
alias k = kubectl
alias ka = kill
alias la = ls -la
alias ll = ls -l
alias shutdown = sudo shutdown
alias su = sudo su

# Ansible
alias apb = ansible-playbook
alias ainv = ansible-inventory
alias agal = ansible-galaxy
alias aval = ansible-vault

# Emacs
alias e = emacsclient -n
alias et = emacsclient -t

# Tailscale
alias tailscale = sudo tailscale
alias tlscl = sudo tailscale
alias tlu = sudo tailscale up
alias tld = sudo tailscale down

## Programs

# Direnv
$env.config.hooks.pre_prompt = (
    $env.config.hooks.pre_prompt | append (source ~/.cache/direnv/config.nu)
)

# Starship
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# TODO: skim fuzzy finder
