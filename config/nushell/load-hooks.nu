# load-hooks.nu: Loads nushell hooks

use hooks.nu

## Zoxide

source $hooks.zoxide.path

## Carapace

$env.CARAPACE_BRIDGES = 'zsh,bash'
source $hooks.carapace.path

let zoxide_completer = {|spans|
    $spans | skip 1 | zoxide query -l ...$in | lines | where {|x| $x != $env.PWD}
}

let fzf_completer = {|spans|
    let input = $spans | str join " "
    let output = (^fzf --filter $input)
    $output | lines | each { |line| {value: $line, description: ""} }
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

## Direnv

$env.config.hooks.pre_prompt = (
  $env.config.hooks.pre_prompt | append ({ || 
    if (which direnv | is-empty) {
      return
    }
    direnv export json | from json | default {} | load-env
  })
)

## Starship

use $hooks.starship.path

# load-hooks.nu ends here
