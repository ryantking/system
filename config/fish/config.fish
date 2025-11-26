# config.fish: User configuration for the fish shell

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

    if type -q tailscale
        tailscale completion fish | source
    end

    if test "$TERM_PROGRAM" = WezTerm
        wezterm shell-completion --shell fish | source
    end

    if type -q gh
        gh completion -s fish | source
    end

    if type -q omnictl
        omnictl completion fish | source
    end

    if type -q velero
        velero completion fish | source
    end

    if type -q linctl
        linctl completion fish | source
    end

    if type -q lefthook
        lefthook completion fish | source
    end
end

# config.fish ends here
