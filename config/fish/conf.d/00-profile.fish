# profile.fish: Environment variables

set -gx EDITOR hx
set -gx VISUAL hx
#set -gx BROWSER brave-browser

set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_STATE_HOME "$HOME/.local/state"

set -gx MANROFFOPT -
set -gx GIT_PAGER moor
set -gx DELTA_PAGER moor

set -gx GOPATH "$XDG_DATA_HOME/go"
set -gx RUSTUP_HOME "$XDG_DATA_HOME/rustup"
set -gx CARGO_HOME "$XDG_DATA_HOME/cargo"
set -gx KREW_ROOT "$XDG_DATA_HOME/krew"
set -gx DIRENV_LOG_FORMAT ""
set -gx DIRENV_WARN_TIMEOUT 600s

if test (uname) = Darwin
    set -gx OBJC_DISABLE_INITIALIZE_FORK_SAFETY YES
end

if status is-interactive; and type -q batman
    set -gx MANPAGER "env BATMAN_IS_BEING_MANPAGER=yes $(dirname (readlink (which batman)))/.batman-wrapped"
end

fish_add_path "$HOME/.local/bin"
fish_add_path "$HOME/System/bin"
fish_add_path "$HOME/.config/emacs/bin"
fish_add_path "$GOPATH/bin"
fish_add_path "$KREW_ROOT/bin"
fish_add_path "$CARGO_HOME/bin"

# profile.fish ends here
