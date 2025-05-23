# aliases.fish: User-defined abbreviations and aliases

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

abbr zl zellij
abbr za zellij-attach

alias cat bat
alias ccat /bin/cat
alias tree "eza --tree --level=3 --ignore-glob='__pycache__/*|node_modules/*|ansible_collections/*'"

alias st "sudo /root/.nix-profile/bin/systemctl-tui"
alias sst systemctl-tui

if test "$TERM_PROGRAM" = WezTerm
    abbr wssh "wezterm ssh"
    abbr wcon "wezterm connect"
    abbr wimgcat "wezterm imgcat"
end

# aliases.fish ends here
