{pkgs, ...}: {
  packages = [
    pkgs.ansible-language-server
    pkgs.fish-lsp
    pkgs.harper
    pkgs.lsp-ai
    pkgs.lua-language-server
    pkgs.marksman
    pkgs.markdown-oxide
    pkgs.nixd
    pkgs.nodePackages.vscode-json-languageserver
    pkgs.typos-lsp
    pkgs.stylua
    (pkgs.python3.withPackages (ppkgs: [ppkgs.python-lsp-server]))
  ];

  languages = {
    ansible.enable = true;
    nix.enable = true;

    python = {
      enable = true;
      version = "3.12";
      uv = {
        enable = true;
        sync.enable = true;
      };
    };
  };

  enterShell = ''
    source .devenv/state/venv/bin/activate
    ansible-galaxy install -r ansible/requirements.yml
  '';

  scripts.format.exec = ''
    ruff check --fix --unsafe-fixes .
    dprint fmt
  '';

  scripts.lint.exec = ''
    lint-yaml
    lint-ansible
    lint-python
    lint-markdown
    lint-typos
  '';

  scripts.lint-ansible.exec = ''
    echo "Linting Ansible..."
    ansible-lint ansible/*
  '';

  scripts.lint-python.exec = ''
    echo "Linting Python..."
    ruff check .
    echo "Checking Python types..."
    basedpyright .
  '';

  scripts.lint-markdown.exec = "markdownlint .";

  scripts.lint-typos.exec = ''
    echo "Linting Typos..."
    typos
  '';

  scripts.lint-yaml.exec = ''
    echo "Linting YAML..."
    yamllint .
  '';

  git-hooks.hooks = {
    alejandra.enable = true;
    check-added-large-files.enable = true;
    end-of-file-fixer.enable = true;
    trim-trailing-whitespace.enable = true;

    ansible-lint = {
      enable = true;
      pass_filenames = false;
      stages = ["pre-push"];
      after = ["yamllint"];
    };

    check-json = {
      enable = true;
      fail_fast = true;
      after = ["check-merge-conflicts"];
    };

    check-merge-conflicts = {
      enable = true;
      fail_fast = true;
    };

    check-python = {
      enable = true;
      fail_fast = true;
      after = ["check-merge-conflicts"];
    };

    check-yaml = {
      enable = true;
      fail_fast = true;
      after = ["check-merge-conflicts"];
    };

    detect-private-keys = {
      enable = true;
      fail_fast = true;
      stages = ["pre-commit" "pre-push"];
    };

    dprint = {
      enable = true;
      name = "dprint formatter";
      package = pkgs.dprint;
      entry = "${pkgs.dprint}/bin/dprint fmt";
      files = "\\.(md|yaml|yml|json|j2|lua)$";
      pass_filenames = true;
      after = ["check-json" "check-yaml"];
    };

    editorconfig-checker = {
      enable = true;
      after = ["alejandra" "dprint" "end-of-file-fixer" "trim-trailing-whitespace"];
    };

    markdownlint = {
      enable = true;
      pass_filenames = false;
      stages = ["post-commit"];
    };

    pyright = {
      enable = true;
      package = pkgs.basedpyright;
      entry = "${pkgs.basedpyright}/bin/basedpyright";
      pass_filenames = false;
      after = ["ruff"];
      stages = ["post-commit"];
    };

    ruff = {
      enable = true;
      pass_filenames = false;
      stages = ["post-commit"];
    };

    typos = {
      enable = true;
      files = "\\.md$";
      stages = ["post-commit"];
    };

    yamllint = {
      enable = true;
      files = ".";
      stages = ["post-commit"];
    };
  };
}
