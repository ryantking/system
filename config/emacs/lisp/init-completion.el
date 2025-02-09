;;; init-completion.el --- Completion interfaces -*- lexical-binding: t -*-

;;; Enhanced matching (orderless.el)
(use-package orderless
  :ensure t
  :bind
  (:map minibuffer-local-completion-map
        ("SPC" . nil)
        ("?" . nil))
  :init
  (setq orderless-component-separator 'orderless-escapable-split-on-space
        orderless-matching-styles
        '(orderless-prefixes
          orderless-strict-leading-initialism
          orderless-flex
          orderless-regexp)
        orderless-style-dispatchers
        '(ryan-orderless-literal-dispatcher
          ryan-orderless-initialism-dispatcher
          ryan-orderless-flex-dispatcher)))

;;; Orderless extensions (lib-orderless.el)
(use-package lib-orderless)

;;; Enhanced minibuffer information (marginalia)
(use-package marginalia
  :ensure t
  :bind
  (:map minibuffer-local-map
        ("M-A" . marginalia-cycle))
  :init
  (setq marginalia-max-relative-age 0)
  :config
  (marginalia-mode 1))

;;; Minibuffer completion (minibuffer.el)
(use-package minibuffer
  :hook (minibuffer-setup . cursor-intangible-mode)
  :init
  (setq-default case-fold-search t)

  (defun crm-indicator (args)
    "Add prompt indicator to `completing-read-multiple' filter ARGS."
    ;; The `error' face just makes the text red.
    (cons (concat (propertize "[CRM] " 'face 'error) (car args)) (cdr args)))

  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  (setq completion-styles '(basic substring initials flex orderless)
        completion-category-defaults nil
        completion-category-overrides
        '((file (styles . (basic partial-completion orderless)))
          (bookmark (styles . (basic substring)))
          (library (styles . (basic substring)))
          (embark-keybinding (styles . (basic substring)))
          (imenu (styles . (basic substring orderless)))
          (consult-location (styles . (basic substring orderless)))
          (kill-ring (styles . (emacs22 orderless)))
          (eglot (styles . (emacs22 substring orderless))))
        completion-ignore-case t
        read-buffer-completion-ignore-case t
        read-file-name-completion-ignore-case t
        enable-recursive-minibuffers t
        resize-mini-windows t
        minibuffer-eldef-shorten-default t
        read-answer-short t
        echo-keystrokes 0.25
        kill-ring-max 60
        minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  :config
  (file-name-shadow-mode 1)
  (minibuffer-depth-indicate-mode 1)
  (minibuffer-electric-default-mode 1))

;;; Save minibuffer history (savehist.el)
(use-package savehist
  :hook
  (after-init . savehist-mode)
  :init
  (setq savehist-file (locate-user-emacs-file "savehist")
        history-length 10000
        history-delete-duplicates t
        savehist-save-minibuffer-history t))

;;; Enhanced selection interface (vertico.el)
(use-package vertico
  :ensure t
  :hook
  (rfn-eshadow-update-overlay . vertico-directory-tidy)
  :bind
  (:map vertico-map
        (("C-q" . vertico-quick-insert)))
  :init
  (setq vertico-scroll-margin 0
        vertico-count 10
        vertico-count-format nil
        vertico-resize nil
        vertico-cycle t

        vertico-quick1 "arstgm"
        vertico-quick2 "neio"

        vertico-grid-separator
        #("  |  " 2 3 (display (space :width (1))))

        vertico-group-format
        (concat #(" " 0 1 (face vertico-group-title))
                #(" " 0 1 (face vertico-group-separator))
                #(" %s " 0 4 (face vertico-group-title))
                #(" " 0 1 (face vertico-group-separator
                                display (space :align-to (- right (-1 . right-margin) (- +1)))))))
  (vertico-mode 1))

;;; Enhanced minibuferr commands (consult.el)
(use-package consult
  :ensure t
  :hook
  ((completion-list-mode . consult-preview-at-point-mode)
   (consult-after-jump . pulsar-recenter-top)
   (consult-after-jump . pulsar-reveal-entry))
  :bind
  (("C-s" . #'consult-line)
   ("C-r" . #'consult-line-multi)
   ("C-x b" . #'consult-buffer)
   ("C-." . #'consult-find)
   :map project-prefix-map
   (("C-b" . #'consult-project-buffer))
   :map minibuffer-local-map
   (("C-s" . consult-history)
    ("C-r" . consult-history))
   :map consult-narrow-map
   ("?" . consult-narrow-help))
  :config
  (require 'consult-imenu)
  (setq consult-async-input-debounce 0.5
        consult-async-input-throttle 0.8
        consult-narrow-key ">"

        consult-imenu-config
        '((emacs-lisp-mode :toplevel "Functions"
           :types ((?f "Functions" font-lock-function-name-face)
                   (?m "Macros"    font-lock-keyword-face)
                   (?p "Packages"  font-lock-constant-face)
                   (?t "Types"     font-lock-type-face)
                   (?v "Variables" font-lock-variable-name-face))))
        ;; Search C-h f for more "bookmark jump" handlers.
        consult-bookmark-narrow
        `((?d "Docview" ,#'doc-view-bookmark-jump)
          (?e "Eshell" ,#'eshell-bookmark-jump)
          (?f "File" ,#'bookmark-default-handler)
          (?h "Help" ,#'help-bookmark-jump)
          (?i "Info" ,#'Info-bookmark-jump)
          (?m "Man" ,#'Man-bookmark-jump)
          (?v "VC Dir" ,#'vc-dir-bookmark-jump))
        register-preview-delay 0.8
        register-preview-function #'consult-register-format
        consult-find-args "find . -not ( -wholename */.* -prune )"
        consult-preview-key 'any
        consult-after-jump-hook nil))

;;; Directory switching menu (consult-dir.el)
(use-package consult-dir
  :ensure t
  :bind
  (("C-x C-d" . consult-dir)
   :map minibuffer-local-filename-completion-map
   ("C-x C-d" . consult-dir))
  :init
  (setq consult-dir-sources '(consult-dir--source-bookmark
                              consult-dir--source-default
                              consult-dir--source-project
                              consult-dir--source-recentf)))

;;; Extended minibuffer actions (embark.el)
(use-package embark
  :ensure t
  :bind
  (("C-," . embark-act)
   ("C-." . embark-dwim)
   ("C-h b" . embark-bindings))
  :init
  (setq prefix-help-command #'embark-prefix-help-command
        embark-quit-after-action t
        ;; embark-cycle-key (kbd "C-.")
        embark-confirm-act-all nil
        embark-indicators
        '(embark-mixed-indicator
          embark-highlight-indicator)
        embark-verbose-indicator-excluded-actions
        '("\\`customize-" "\\(local\\|global\\)-set-key"
          set-variable embark-cycle embark-keymap-help embark-isearch)
        embark-verbose-indicator-buffer-sections
        `(target "\n" shadowed-targets " " cycle "\n" bindings)
        embark-mixed-indicator-both nil
        embark-mixed-indicator-delay 1.2
        embark-verbose-indicator-display-action nil))

;;; Embark x consult
(use-package embark-consult
  :ensure t)

;;; Embark extensions (lib-embark.el)
(use-package lib-embark
  :config
  (ryan-embark-keymaps 1))

;;; Completion for recent files (recentf.el)
(use-package recentf
  :hook after-init
  :init
  (setq recentf-save-file (locate-user-emacs-file "recentf")
        recentf-exclude '(".gz" ".xz" ".zip" "/elpa/" "/ssh:" "/sudo:")))

;;; Recentf extensions (lib-recentf.el)
(use-package lib-recentf
  :bind
  ("C-x C-r" . ryan-recentf-recent-files-or-dirs)
  :init
  (add-to-list 'recentf-keep 'ryan-recentf-keep-predicate))

;;; Corfu (in-buffer completion popup)
(use-package corfu
  :ensure t
  :custom
  (corfu-cycle t)
  (corfu-auto t)
  (corfu-auto-delay 0.3)
  (corfu-quit-at-boundary t)
  (corfu-quit-no-match t)
  :hook
  ((eshell-mode . (lambda () (setq-local corfu-auto nil)))
   (minibuffer-setup . (lambda ()
                         (unless (bound-and-true-p vertico--input)
                           (setq-local corfu-auto nil)
                           (corfu-mode 1)))))
  :init
  (setq completion-cycle-threshold 3
        read-extended-command-predicate #'command-completion-default-include-p
        tab-always-indent 'complete)
  (global-corfu-mode 1))

;;; Extra completion-at-point backends (cape.el)
(use-package cape
  :ensure t
  :init
  (setq cape-dabbrev-min-length 3)
  :config
  (advice-add 'pcomplete-completions-at-point :around #'cape-wrap-silent)
  (advice-add 'pcomplete-completions-at-point :around #'cape-wrap-purify)
  (advice-add 'eglot-completion-at-point :around #'cape-wrap-buster)

  (require 'cape-keyword)
  (dolist (backend '(cape-symbol cape-keyword cape-file cape-dabbrev))
    (add-to-list 'completion-at-point-functions backend)))

;;; Completion menu icons (kind-icon.el)
;; (use-package kind-icon
;;   :ensure t
;;   :init
;;   (setq kind-icon-default-face 'corfu-default)
;;   :config
;;   (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

;;; Better command line args (pcmpl-ags.el)
(use-package pcmpl-args
  :ensure t)

;; Dabbrev (dynamic word completion)
(use-package dabbrev
  :bind
  (("M-/" . dabbrev-expand)
   ("C-x M-/" . dabbrev-completion))
  :config
  (setq dabbrev-abbrev-char-regexp "\\W\\|\\s_"
        dabbrev-abbrev-skip-leading-regexp "[$*/=~’]"
        dabbrev-backward-only nil
        dabbrev-case-distinction 'case-replace
        dabbrev-upcase-means-case-search t))

;;; Abbreviations (abbrev.el)
;; (use-package abbrev
;;   :hook text-mode
;;   :bind
;;   (("C-x a e" . expand-abbrev)
;;    ("C-x a u" . unexpand-abbrev))
;;   :config
;;   (setq abbrev-file-name (locate-user-emacs-file "abbrevs")))

(provide 'init-completion)

;;; init-completion.el ends here
