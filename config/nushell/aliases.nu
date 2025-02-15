# aliases.nu: Aliases for the Nushell

alias apt = sudo apt
alias cat = bat
alias fda = fd -Ih
alias g = git
alias gu = gitui
alias k = kubectl
alias ka = kill
alias l = ls -a
alias ll = ls -al
alias shutdown = sudo shutdown
alias su = sudo su
alias tree = eza --tree --level=3 --ignore-glob='__pycache__/*|node_modules/*|ansible_collections/*'
alias yz = yazi

alias apb = ansible-playbook
alias ainv = ansible-inventory
alias agal = ansible-galaxy
alias aval = ansible-vault

alias e = emacsclient -n
alias et = emacsclient -t

alias tailscale = sudo tailscale
alias tlscl = sudo tailscale
alias tlu = sudo tailscale up
alias tld = sudo tailscale down

# aliases.nu ends here
