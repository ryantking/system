# System

System configuration for my personal devices and homelab. Contains:

- Ansible configuration for managing dev workstations and servers
- Terraform (OpenTofu) modules for things that support it
  - Shared or resuable modules go in `terraform/modules`
  - Live terraform configuration goes into `terraform/live`
    - Each subdirectory of that, called a layer, focus on one element of the system, e.g. networking
- Dotfiles for development tools

## Rules

**IMPORTANT:** ALWAYS follow these rules, they are not optional unless the user instructs contradict them. If its not clear, default to to following the rules.

- ALWAYS use `just tf {layer} {args}` to run Terraform commands on a specific layers, e.g. `just tf net plan`
