;;; init-theme.el --- Theme and other visual Xtras -*- lexical-binding: t -*-

;;; Color scheme (gruvbox-theme.el)
(use-package gruvbox-theme
  :ensure t
  :config
  (load-theme 'gruvbox-dark-medium t))

;;; Color scheme (doom-themes.el)
;; (use-package doom-themes
;;   :ensure t
;;   :config
;;   (load-theme 'doom-tokyo-night t))

;;; highlight lines (pulsar)
(use-package pulsar
  :ensure t
  :custom-face
  (ryan-pulsar-face ((t (:background ,(face-foreground 'warning)))))
  (ryan-pulsar-highlight-face ((t (:background ,(face-foreground 'error)))))
  :bind
  (("C-x l" . pulsar-pulse-line)
   ("C-x L" . pulsar-highlight-dwim))
  :init
  (setq pulsar-functions '(forward-page backward-page evil-scroll-page-down evil-scroll-page-up)
        pulsar-pulse-on-window-change t
        pulsar-pulse t
        pulsar-delay 0.055
        pulsar-iterations 10
        pulsar-face 'ryan-pulsar-face
        pulsar-highlight-face 'ryan-pulsar-highlight-face)
  :config
  (pulsar-global-mode 1))

;;; Highlight selection (lin.el)
(use-package lin
  :ensure t
  :init
  (setq lin-face 'ffap
        lin-mode-hooks
        '(
          ;; bongo-mode-hook
          dired-mode-hook
          elfeed-search-mode-hook
          git-rebase-mode-hook
          ibuffer-mode-hook
          ;; ilist-mode-hook
          ;; ledger-report-mode-hook
          log-view-mode-hook
          magit-log-mode-hook
          ;; mu4e-headers-mode
          ;; notmuch-search-mode-hook
          ;; notmuch-tree-mode-hook
          ;; occur-mode-hook
          org-agenda-mode-hook
          ;; tabulated-list-mode-hook
          ))
  :config
  (lin-global-mode 1))

;;; Preview colors (rainbow-mode.el)
(use-package rainbow-mode
  :ensure t)

;;; Fringe mode (fringe.el)
(use-package fringe
  :config
  (fringe-mode nil))

;;; Line numbers (display-line-numbers.el)
(use-package display-line-numbers
  :hook ((prog-mode text-mode conf-mode) . display-line-numbers-mode))

;;; Highlight current line (hl-line.el)
(use-package hl-line)

;;; Manage whitespace (whitespace.el)
(use-package whitespace
  :bind
  ("C-c z" . delete-trailing-whitespace))

;;; Cursor appearance (cursory.el)
(use-package cursory
  :ensure t
  :hook
  (kill-emacs . cursory-store-latest-preset)
  :init
  (setq cursory-presets
        '((bar
           :cursor-type (bar . 2)
           :cursor-in-non-selected-windows hollow
           :blink-cursor-blinks 10
           :blink-cursor-interval 0.5
           :blink-cursor-delay 0.2)
          (box
           :cursor-type box
           :cursor-in-non-selected-windows hollow
           :blink-cursor-blinks 10
           :blink-cursor-interval 0.5
           :blink-cursor-delay 0.2)
          (underscore
           :cursor-type (hbar . 3)
           :cursor-in-non-selected-windows hollow
           :blink-cursor-blinks 50
           :blink-cursor-interval 0.2
           :blink-cursor-delay 0.2)))
  :config
  (cursory-set-preset (or (cursory-restore-latest-preset) 'box)))

(provide 'init-theme)

;;; init-theme.el ends here
