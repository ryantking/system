;; ;;; init-window.el --- Window configuration -*- lexical-binding: t -*-

;;; Unique names for buffers
(use-package uniquify
  :init
  (setq uniquify-buffer-name-style 'forward))

;;; Window rules (window.el)
(use-package window
  :hook ((help-mode custom-mode) . visual-line-mode)
  :bind
  (("C-x !" . delete-other-windows-vertically)
   ("C-x -" . fit-window-to-buffer))
  :init
  (setq display-buffer-alist
        `(;; no window
          ("\\`\\*Async Shell Command\\*\\'"
           (display-buffer-no-window))
          ("magit:.*"
           (display-buffer-same-window))
          ;; top side window
          ("\\*\\(Flymake diagnostics\\|Package-Lint\\).*"
           (display-buffer-in-side-window)
           (window-height . 0.16)
           (side . top)
           (slot . 0))
          ("\\*Messages.*"
           (display-buffer-in-side-window)
           (window-height . 0.16)
           (side . top)
           (slot . 1))
          ("\\*\\(Backtrace\\|Warnings\\|Compile-Log\\|Flymake log\\)\\*"
           (display-buffer-in-side-window)
           (window-height . 0.16)
           (side . top)
           (slot . 2))
          ;; left side window
          ("\\*\\(.* # Help.*\\|Help\\)\\*"
           (display-buffer-reuse-mode-window display-buffer-in-side-window)
           (window-width 0.25)
           (side . left)
           (slot . 0))
          ;; bottom side window
          ("\\*Org Select\\*"
           (display-buffer-in-side-window)
           (dedicated . t)
           (side . bottom)
           (slot . 0)
           (window-parameters . ((mode-line-format . none))))
          ;; bottom buffer
          ("\\*Embark Actions\\*"
           (display-buffer-reuse-mode-window display-buffer-at-bottom)
           (window-height . fit-window-to-buffer)
           (window-parameters . ((no-other-window . t)
                                 (mode-line-format . none))))
          ;; below current window
          ;; ("\\*.*\\(e?shell\\|v?term\\).*"
          ;;  (display-buffer-reuse-mode-window display-buffer-below-selected)
          ;;  (window-height . 0.2))
          ("\\*\\(Calendar\\|Bookmark Annotation\\).*"
           (display-buffer-reuse-mode-window display-buffer-below-selected)
           (window-height . fit-window-to-buffer)))
        window-combination-resize t
        even-window-sizes 'height-only
        switch-to-buffer-in-dedicated-window 'pop))

;;; Directional window motions (windmove.el)
;; (use-package windmove
;;   :bind
;;   (("C-M-<up>" . windmove-up)
;;    ("C-M-<right>" . windmove-right)
;;    ("C-M-<down>" . windmove-down)
;;    ("C-M-<left>" . windmove-left)
;;    ("C-M-S-<up>" . windmove-swap-states-up)
;;    ("C-M-S-<right>" . windmove-swap-states-right)
;;    ("C-M-S-<down>" . windmove-swap-states-down)
;;    ("C-M-S-<left>" . windmove-swap-states-left)))

;;; Tabs for window layouts (tab-bar.el and ryan-tab.el)
(use-package tab-bar
  :config
  (tab-bar-history-mode 1))

;;; Tab bar (lib-tab.el)
(use-package lib-tab
  ;; :hook (after-init . ryan-tab-status-line)
  :bind
  (("C-x <down>" . ryan-tab-winner-redo)
   ("C-x <up>" . ryan-tab-winner-undo)
   ("<f8>" . ryan-tab-status-line)
   ("C-x t t" . ryan-tab-select-tab-dwim))
  :init
  (setq tab-bar-format
        '(tab-bar-format-tabs-groups
          tab-bar-format-align-right
          tab-bar-format-global)))

;;; Window movement (ace-window)
(use-package ace-window
  :ensure t
  :init
  (setq aw-keys '(?a ?r ?s ?t ?g ?h ?n ?e ?i ?o)
        aw-minibuffer-flag t)
  :config
  (ace-window-display-mode 1))

(provide 'init-window)

;;; init-window.el ends here
