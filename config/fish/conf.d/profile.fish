# profile.fish: Environment variables

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
    set -xU DIRENV_LOG_FORMAT ""
    set -U _fish_profile_configured
end

fish_add_path "$HOME/.local/bin"
fish_add_path "$HOME/System/bin"
fish_add_path "$HOME/.config/emacs/bin"
fish_add_path "$GOPATH/bin"
fish_add_path "$CARGO_HOME/bin"
fish_add_path "$KREW_ROOT/bin"

if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish' ]
    source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
end

if status is-interactive
    set -xg MANPAGER "env BATMAN_IS_BEING_MANPAGER=yes $(dirname (readlink (which batman)))/.batman-wrapped"
end

# profile.fish ends here
