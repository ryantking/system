# config.fish: User configuration for the fish shell

set -g fish_greeting

function fish_title
    if set -q argv[1]
        echo $argv[1] (prompt_pwd)
    else
        echo (basename $SHELL) (prompt_pwd)
    end
end

if status is-interactive
    if type -q starship
        starship init fish | source
    end

    if test -x /opt/homebrew/bin/brew
        eval (/opt/homebrew/bin/brew shellenv)
    end

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
end

# config.fish ends here

# omnara
set --export OMNARA_INSTALL "$HOME/.omnara"
set --export PATH $OMNARA_INSTALL/bin $PATH
