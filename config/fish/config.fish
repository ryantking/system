# config.fish: User configuration for the fish shell

alias ls eza
alias cat bat
alias tree "eza --tree --level=3 --ignore-glob='__pycache__/*|node_modules/*|ansible_collections/*'"

abbr apt sudo apt
abbr g git
abbr gu gitui
abbr l ls -a
abbr ll ls -al
abbr k kubectl
abbr yz yazi

abbr a ansible
abbr agal ansible-galaxy
abbr ainv ansible-inventory
abbr apb ansible-playbook

abbr e emacsclient -n
abbr et emacsclient -t

abbr tlscl sudo tailscale
abbr tlu sudo tailscale up
abbr tld sudo tailscale down
abbr tls sudo tailscale switch

if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish' ]
    source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
end

if not set -qU _fish_profile_configured
    set -xU EDITOR hx
    set -xU VISUAL hx
    set -xU BROWSER brave

    set -xU XDG_CONFIG_HOME "$HOME/.config"
    set -xU XDG_DATA_HOME "$HOME/.local/share"
    set -xU XDG_CACHE_HOME "$HOME/.cache"
    set -xU XDG_STATE_HOME "$HOME/.local/state"

    set -xU MANROFFOPT -
    set -xU GIT_PAGER moar
    set -xU DELTA_PAGER moar

    set -xU GOPATH "$XDG_DATA_HOME/go"
    set -xU RUSTUP_HOME "$XDG_DATA_HOME/rustup"
    set -xU CARGO_HOME "$XDG_DATA_HOME/cargo"
    set -xU KREW_ROOT "$XDG_DATA_HOME/krew"
    set -U _fish_profile_configured
end

set -xg MANPAGER "env BATMAN_IS_BEING_MANPAGER=yes $(dirname (readlink (which batman)))/.batman-wrapped"

fish_add_path "$HOME/.local/bin"
fish_add_path "$HOME/System/bin"
fish_add_path "$HOME/.config/emacs/bin"
fish_add_path "$GOPATH/bin"
fish_add_path "$CARGO_HOME/bin"
fish_add_path "$KREW_ROOT/bin"

if status is-interactive
    if not functions -q fisher
        curl -sL https://git.io/fisher | source
        fisher update
    end

    if type -q direnv
        direnv hook fish | source
    end

    if type -q tv
        tv init fish | source
    end

    if type -q zoxide
        zoxide init fish | source
    end

    set _tlscl_completion_file "$HOME/.config/fish/completions/tailscale.fish"
    if not test -e $_tlscl_completion_file
        tailscale completion fish >$_tlscl_completion_file
        source $_tlscl_completion_file
    end

    if not set -qU _fish_theme_configured
        base16-horizon-terminal-dark

        set -U fish_greeting

        set -U hydro_color_prompt magenta
        set -U hydro_color_error red
        set -U hydro_color_pwd blue
        set -U hydro_color_git 6C6F93
        set -U hydro_color_duration yellow
        set -U hydro_multiline true

        set -U _fish_theme_configured
    end

    set -g fish_color_autosuggestion 6C6F93
    set -g fish_color_comment 6C6F93
end

# config.fish ends here
