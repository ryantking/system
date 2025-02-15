# hooks.nu: Nushell hook definitions

use lib.nu init-path

export module carapace {
  export const path = $"($nu.home-path)/.cache/carapace/init.nu"
  export def init [] {
    carapace _carapace nushell | save -f (init-path $path)
  }
}

export module flux {
  export const path = $"($nu.home-path)/.local/share/bash-completions/completions/flux"
  export def init [] {
    flux completion bash | save -f (init-path $path)
  }
}

export module starship {
  export const path = $"($nu.home-path)/.cache/starship/init.nu"
  export def init [] {
    starship init nu | save -f (init-path $path)
  }
}

export module zoxide {
  export const path = $"($nu.home-path)/.cache/zoxide/init.nu"
  export def init [] {
    zoxide init nushell | save -f (init-path $path)
  }
}

# hooks.nu ends here
