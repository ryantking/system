;;; init-modeline.el --- Slightly sexier modeline -*- lexical-binding: t -*-

(setq mode-line-position-column-line-format '(" %l,%c")
      mode-line-defining-kbd-macro
      (propertize " Macro" 'face 'mode-line-emphasis))

(setq-default mode-line-modes
              (seq-filter (lambda (s)
                            (not (and (stringp s)
                                      (string-match-p
                                       "+\\(%\\[\\|%\\]\\)$" s))))
                          mode-line-modes)

              mode-line-format
              '("%e"
                mode-line-front-space
                mode-line-mule-info
                mode-line-client
                mode-line-modified
                mode-line-remote
                mode-line-frame-identification
                mode-line-buffer-identification
                "  "
                mode-line-position
                mode-line-modes
                "  "
                (vc-mode vc-mode)
                "  "
                mode-line-misc-info
                mode-line-end-spaces))

(add-hook 'after-init-hook #'column-number-mode)

;;; Simple mode line configuration (moody.el)
(use-package moody
  :ensure t)

;;; Moody extensions (lib-moody.el)
(use-package lib-moody
  :config
  (ryan-moody-set-height 1))

;;; Hide modeline "lighters" (minions.el)
(use-package minions
  :ensure t
  :init
  (setq minions-mode-line-lighter ";"
        minions-prominent-modes '(defining-kbd-macro 'flymake-mode))
  :config
  (minions-mode 1))

;;; Mode line recursion indicator (recursion-indicator.el)
(use-package recursion-indicator
  :ensure t
  :config
  (recursion-indicator-mode t))

(provide 'init-modeline)

;;; init-modeline.el
