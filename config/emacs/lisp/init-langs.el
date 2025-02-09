;;; init-langs.el --- Language configuration -*- lexical-binding: t -*-

;;; Paragraphs and fill-mode (lib-fill.el)
(use-package lib-fill
  :hook
  (after-init . column-number-mode)
  :config
  (ryan-fill-mode 1))

;;; Comments (newcomment.el)
(use-package newcomment
  :bind
  (("C-:" . comment-kill)
   ("M-;" . comment-indent))
  :init
  (setq comment-empty-lines t))

;;; Comment extensions (lib-comment.el)
(use-package lib-comment
  :bind
  (("C-;" . ryan-comment-comment-dwim)
   ("C-x C-;" . ryan-comment-timestamp-keyword)))

;;; Fast goto navigation (avy.el)
(use-package avy
  :init
  (setq avy-all-windows nil
        avy-all-windows-alt t
        avy-single-candidate-jump t
        avy-timeout-seconds 0.3
        avy-style 'pre
        nil-xrlf '(?n ?e ?f ?g ?t ?z ?a ?r ?v ?b)))

;;; Electric behaviour (electric.el)
(use-package electric
  :hook
  (prog-mode . electric-indent-local-mode)
  :config
  (electric-pair-mode 1))

;;; Parenthesis (paren.el)
(use-package paren
  :hook
  (after-init . show-paren-mode))

;;; Tabs and indendation
(setq-default tab-always-indent 'complete
              tab-first-completion 'word-or-paren-or-punct)

;;; Handle long lines (so-long.el)
(use-package so-long
  :config
  (global-so-long-mode 1))

;;; Python (python-mode.el)
(use-package python-mode
  :ensure t
  :mode
  ("\\.py\\'" . python-mode)
  :hook
  (python-mode . eldoc-mode))

;;; Python virtual environments (pyvenv.el)
(use-package pyvenv
  :ensure t)

;;; Automatically activate venvs (auto-virtualenv.el)
(use-package auto-virtualenv
  :ensure t
  :hook
  ((python-mode . auto-virtualenv-set-virtualenv)
   (python-ts-mode . auto-virtualenv-set-virtualenv)
   (window-configuration-change . auto-virtualenv-set-virtualenv)
   (focus-in . auto-virtualenv-set-virtualenv)))

;;; Language Server Protocol (eglot.el)
(use-package eglot
  :bind
  (("C-c l q" . eglot-shutdown)
   ("C-c l Q" . eglot-shutdown-all)
   ("C-c l d" . eglot-find-declaration)
   ("C-c l i" . eglot-find-implementation)
   ("C-c l t" . eglot-find-typeDefinition)
   ("C-c l r" . eglot-rename)
   ("C-c l f" . eglot-format-buffer)
   ("C-c l o" . eglot-code-action-organize-imports)
   ("C-c l a" . eglot-code-actions))
  :hook
  ((python-mode . eglot-ensure)
   (python-ts-mode . eglot-ensure)
   (yaml-mode . eglot-ensure)
   (yaml-ts-mode . eglot-ensure))
  ;; :hook
  ;; (eglot-managed-mode
  ;;  . (lambda ()
  ;;      (remove-hook 'flymake-diagnostic-functions 'eglot-flymake-backend)))
  :init
  (setq eglot-autoshutdown t
        eglot-confirm-server-initiated-edits nil)
  (setq-default eglot-workspace-configuration
                '((:pylsp . (:configurationSources ["flake8"]
                             :plugins (
                                       :rope_autoimport (
                                                         :enabled :json-false
                                                         :completions_enabled :json-false)
                                       :rope_completion (:enabled t)
                                       :ruff (
                                              :enabled t
                                              :formatEnabled t
                                              :lineLength 88
                                              :format ["I"]
                                              :extendSelect ["I"])))))))

;;; Snippets (yasnippet.el)
(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1))

;;; Snippets for yasnippet (yasnippet-snippets.el)
(use-package yasnippet-snippets
  :ensure t)

;;; Modern syntax pasing (treesit.el)
(use-package treesit
  :commands (treesit-install-language-grammar ryan-treesit-install-all-languages)
  :init
  (setq treesit-language-source-alist
        '((bash . ("https://github.com/tree-sitter/tree-sitter-bash"))
          (c . ("https://github.com/tree-sitter/tree-sitter-c"))
          (cpp . ("https://github.com/tree-sitter/tree-sitter-cpp"))
          (css . ("https://github.com/tree-sitter/tree-sitter-css"))
          (go . ("https://github.com/tree-sitter/tree-sitter-go"))
          (html . ("https://github.com/tree-sitter/tree-sitter-html"))
          (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript"))
          (json . ("https://github.com/tree-sitter/tree-sitter-json"))
          (lua . ("https://github.com/Azganoth/tree-sitter-lua"))
          (make . ("https://github.com/alemuller/tree-sitter-make"))
          (ocaml . ("https://github.com/tree-sitter/tree-sitter-ocaml" "ocaml/src" "ocaml"))
          (python . ("https://github.com/tree-sitter/tree-sitter-python"))
          (php . ("https://github.com/tree-sitter/tree-sitter-php"))
          (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" "typescript/src" "typescript"))
          (ruby . ("https://github.com/tree-sitter/tree-sitter-ruby"))
          (rust . ("https://github.com/tree-sitter/tree-sitter-rust"))
          (sql . ("https://github.com/m-novikov/tree-sitter-sql"))
          (toml . ("https://github.com/tree-sitter/tree-sitter-toml"))
          (yaml . ("https://github.com/ikatyang/tree-sitter-yaml"))
          (zig . ("https://github.com/GrayJack/tree-sitter-zig"))))
  :config
  (defun my/treesit-install-all-languages ()
    "Install all languages specified by `treesit-language-source-alist'."
    (interactive)
    (let ((languages (mapcar 'car treesit-language-source-alist)))
      (dolist (lang languages)
        (treesit-install-language-grammar lang)
        (message "`%s' parser was installed." lang)
        (sit-for 0.75)))))

;;; Syntax checking (flymake.el)
(use-package flymake
  :bind
  (("C-c ! t" . flymake-mode)
   :map flymake-mode-map
   ("C-c ! s" . flymake-start)
   ("C-c ! d" . flymake-show-buffer-diagnostics)
   ("C-c ! n" . flymake-goto-next-error)
   ("C-c ! p" . flymake-goto-prev-error))
  :init
  (setq flymake-suppress-zero-counters t
        flymake-mode-line-format
        '("" flymake-mode-line-exception flymake-mode-line-counters)
        flymake-mode-line-counter-format
        '(" " flymake-mode-line-error-counter
          flymake-mode-line-warning-counter
          flymake-mode-line-note-counter "")))

;;; Diagnostic popups (flymake-dragnostic-at-point.el)
(use-package flymake-diagnostic-at-point
  :ensure t
  :hook flymake-mode
  :init
  (setq flymake-diagnostic-at-point-display-diagnostic-function
        'flymake-diagnostic-at-point-display-popup))

;;; Additional flymake linters (flymake-collection)
(use-package flymake-collection
  :config
  (require 'flymake-collection-define)
  (flymake-collection-define-rx
   flymake-collection-ansible-lint
   "An ansible syntax checker using ansible-lint."
   :title "ansible-lint"
   :pre-let ((ansible-lint-exec (executable-find "ansible-lint")))
   :pre-check (unless ansible-lint-exec
                (error "cannot find ansible-lint executable"))
   :write-type 'file
   :command (list ansible-lint-exec "--nocolor" "-p" "--offline" ansible-collection-temp-file))
  :hook
  ((shell-mode
    . (lambda ()
        (add-hook 'flymake-diagnostic-functions
                  #'flymake-collection-shellcheck nil t)
        (flymake-mode 1)))
   (yaml-mode
    . (lambda ()
        (let ((current-file (buffer-file-name)))
          (unless (locate-dominating-file default-directory "ansible.cfg")
            ;; (unless (or (string-match "/playbooks/" current-file)
            ;;     (string-match "/tasks/" current-file)
            ;;     (string-match "/handlers/" current-file))
            ;; (add-hook 'flymake-diagnostic-functions
            ;;       #'flymake-collection-ansible-lint nil t)
            (add-hook 'flymake-diagnostic-functions
                      #'flymake-collection-yamllint nil t)))
        (flymake-mode 1)))))

;;; Prose linting (flymake-vale.el)
(use-package flymake-vale
  :vc (:fetcher "github" :repo "tpeacock19/flymake-vale")
  :hook
  ((text-mode markdown-mode org-mode message-mode) . flymake-vale-load))

;;; Formatting files automatically (apheleia.el)
(use-package apheleia
  :ensure t
  :bind
  ("C-c C-f" . apheleia-format-buffer)
  :config
  (add-to-list 'apheleia-mode-alist '(python-mode . ruff))
  (add-to-list 'apheleia-mode-alist '(python-ts-mode . ruff))
  (apheleia-global-mode 1))

;;; Documentation browser (eldoc.el)
(use-package eldoc
  :config
  (global-eldoc-mode 1))

;;; S-expression navigation (puni.el)
;; (use-package puni
;;   :ensure t
;;   :hook
;;   (term-mode . puni-disable-puni-mode)
;;   :config
;;   (puni-global-mode))

;;;; Additional languages

;;; Ansible (ansible.el)
(use-package ansible
  :ensure t
  :defer t
  :hook
  ((yaml-mode
    . (lambda ()
        (when
            (or
             (locate-dominating-file default-directory "ansible.cfg")
             (locate-dominating-file default-directory "galaxy.yml")
             (locate-dominating-file default-directory "requirements.yml"))
          (ansible 1))))
   (yaml-ts-mode
    . (lambda ()
        (when
            (or
             (locate-dominating-file default-directory "ansible.cfg")
             (locate-dominating-file default-directory "galaxy.yml")
             (locate-dominating-file default-directory "requirements.yml"))
          (ansible 1))))))

;;; Ansible documentation (ansible-doc.el)
(use-package ansible-doc
  :ensure t
  :hook ansible-mode)

;;; Jinja2 (jinja2-mode.el)
(use-package jinja2-mode
  :ensure t
  :mode "\\.j2$"
  :config
  (setq jinja2-enable-indent-on-save nil))

;;; Beancount support (beancount.el)
(use-package beancount
  :vc (:fetcher "github" :repo "beancount/beancount-mode"))

;;; C languages (rtags.el)
(use-package rtags :ensure t)

;;; Cmake configuration (cmake-mode.el)
(use-package cmake-mode :ensure t)

;;; Symbol handling (demangle-mode.el)
(use-package demangle-mode :ensure t)

;;; Data (csv-mode.el)
(use-package csv-mode
  :ensure t
  :bind
  (:map csv-mode-map
        ("C-c a" . csv-align-fields)
        ("C-c u" . csv-unalign-fields)
        ("C-c s" . csv-sort-fields)
        ("C-c S" . csv-sort-numeric-fields)
        ("C-c k" . csv-kill-fields)
        ("C-c t" . csv-transpose)))

;;; Go (go-mode.el)
(use-package go-mode
  :ensure t
  ;; :hook
  ;; (go-mode . eglot-ensure)
  :bind
  (:map go-mode-map
        ("C-c b r" . (lambda () (interactive) (compile "go run .")))
        ("C-c b b" . (lambda () (interactive) (compile "go build")))
        ("C-c b c" . (lambda () (interactive) (compile "go clean")))))

;;; Go enhancements (lib-go.el)
(use-package lib-go
  :bind
  (:map go-mode-map
        ("C-c t t" . ryan-go-test-rerun)
        ("C-c t a" . ryan-go-test-all)
        ("C-c t s" . ryan-go-test-single)
        ("C-c t n" . ryan-go-test-nested)
        ("C-c t f" . ryan-go-test-file)))

;;; Markdown (markdown-mode.el)
(use-package markdown-mode
  :ensure t
  :init
  (setq markdown-fontify-code-blocks-natively t))

;;; Edit markdown code blocks (edit-indirect.el)
(use-package edit-indirect
  :ensure t)

;;; Flymake markdownlint plugin (flymake-markdownlint.el)
(use-package flymake-markdownlint
  :vc (:fetcher "github" :repo "erickgnavar/flymake-markdownlint")
  :hook
  (markdown-mode . flymake-markdownlint-setup))

;;; Enhanced markdown previews (grip-mode.el)
(use-package grip-mode
  :hook
  (grip-mode . (lambda () (setq grip-github-password (password-store-get "Keys/emacs-grip.github.com"))))
  :bind
  (:map markdown-mode-command-map
        ("g" . grip-mode)))

;;; YAML (yaml-mode.el)
(use-package yaml-mode
  :ensure t)

;;; Flymake Ruff plugin (flymake-ruff.el)
;; (use-package flymake-ruff
;;   :ensure t
;;   :hook (python-ts-mode . flymake-ruff-load))

;;; Caddyfile (caddyfile-mode.el)
(use-package caddyfile-mode :ensure t)

;;; Plain text (text-mode.el)
(use-package text-mode
  :config
  (add-to-list 'auto-mode-alist '("\\(README\\|CHANGELOG\\|COPYING\\|LICENSE\\)\\'" . text-mode)))

(provide 'init-langs)

;;; init-langs.el ends here
