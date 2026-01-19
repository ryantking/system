# config.fish: User configuration for the fish shell

set -g fish_greeting

function fish_title
    if set -q argv[1]
        echo $argv[1] (prompt_pwd)
    else
        echo (basename $SHELL) (prompt_pwd)
    end
end

if test -x /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv)
end

if test -x /home/linuxbrew/.linuxbrew/bin/brew
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv fish)
end

if status is-interactive
    if type -q brew
        set brew_prefix (brew --prefix)

        if test -d $brew_prefix/share/fish/completions
            set -p fish_complete_path $brew_prefix/share/fish/completions
        end

        if test -d $brew_prefix/share/fish/vendor_completions.d
            set -p fish_complete_path $brew_prefix/share/fish/vendor_completions.d
        end
    end

    if type -q starship
        starship init fish | source
    end

    if not functions -q fisher
        curl -sL https://git.io/fisher | source
        fisher update
    end

    if type -q tv
        tv init fish | source
    end

    if type -q zoxide
        zoxide init fish | source
    end
end

# config.fish ends here
