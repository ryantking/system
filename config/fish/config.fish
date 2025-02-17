# config.fish: User configuration for the fish shell

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

    if type -q tailscale
        tailscale completion fish | source
    end
end

# config.fish ends here
