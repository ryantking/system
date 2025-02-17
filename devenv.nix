{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  packages = [
    pkgs.git
    pkgs.editorconfig-checker
    pkgs.ruff
    pkgs.pylyzer
    pkgs.isort
    pkgs.dprint
    pkgs.nixfmt-rfc-style
    pkgs.lsp-ai
    pkgs.ansible-language-server
    pkgs.fish-lsp
    pkgs.lua-language-server
    pkgs.marksman
    pkgs.markdown-oxide
    pkgs.stylua
  ];

  languages = {
    ansible.enable = true;

    nix = {
      enable = true;
      lsp.package = pkgs.nixd;
    };

    python = {
      enable = true;
      uv = {
        enable = true;
        sync.enable = true;
      };
    };
  };

  git-hooks.hooks = {
    nixfmt-rfc-style.enable = true;
    ruff.enable = true;
    ruff-format.enable = true;
    check-builtin-literals.enable = true;
    check-python.enable = true;
    fix-encoding-pragma.enable = true;
    check-yaml.enable = true;
    yamllint.enable = true;
    check-merge-conflicts.enable = true;
    editorconfig-checker.enable = true;
    trim-trailing-whitespace.enable = true;
    end-of-file-fixer.enable = true;
  };
}
