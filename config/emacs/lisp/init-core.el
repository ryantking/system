;;; init-core.el --- Basic settings and functions -*- lexical-binding: t -*-

;; Common utility functions (lib-common.el)
(use-package lib-common)

;; Put the server in the runtime directory
(setq server-socket-dir (format "/run/user/%d/emacs" (user-uid)))

;; Simple auxillary commands (lib-simple.el)
(use-package lib-simple
  :bind
  (:map help-map
   ("." . ryan-simple-describe-symbol)
   ("K" . describe-keymap)
   ("c" . describe-char)
   :map ctl-x-x-map
   ("e" . eval-buffer)
   ("f" . follow-mode)
   ("r" . rename-uniquely))
  :init
  (setq help-window-select t))

;;; Set paths from the system
(use-package exec-path-from-shell
  :ensure t
  :config
  (setq exec-path-from-shell-variables '("PATH" "PGPKEYID" "SSH_AUTH_SOCK" "PASSWORD_STORE_GPG_OPTS"))

  (when (daemonp) (exec-path-from-shell-initialize)))

;;; Mouse wheel behaviour
(use-package mouse
  :hook (after-init . mouse-wheel-mode)
  :custom
  (mouse-wheel-scroll-amount
   '(1
     ((shift) . 5)
     ((meta) . 0.5)
     ((control) . text-scale)))
  :bind ("C-M-<mouse-3>" . tear-off-window))

;;; Delete selection
(use-package delsel
  :hook (after-init . delete-selection-mode))

;;; Tooltips (tooltip.el)
(use-package tooltip
  :hook (after-init . tooltip-mode)
  :init
  (setq tooltip-delay 0.5
        tooltip-frame-parameters
        '((name . "tooltip")
          (internal-border-width . 6)
          (border-width . 0)
          (no-special-glyphs . t))))

;;; Auto revert mode (autorevert.el)
(use-package autorevert
  :config
  (global-auto-revert-mode 1))

;;; Preserve system clipboard
(setq save-interprogram-paste-before-kill t)

;;; Newline characters for file ending
(setopt mode-require-final-newline 'visit-save)

;;; Go to last change (goto-last-change.el)
(use-package goto-last-change
  :ensure t
  :bind
  ("C-z" . goto-last-change))

;;; Repeatable key chords (reapeat-mode.el)
(use-package repeat
  :custom
  (repeat-exit-timeout 5)
  (repeat-exit-key "<escape>")
  :hook
  (after-init . repeat-mode))

;;; Asynchronous dired actions (async.el)
(use-package async
  :ensure t
  :hook
  (dired-mode . dired-async-mode))

(provide 'init-core)

;;; init-core.el ends here
