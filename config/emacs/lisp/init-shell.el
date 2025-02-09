;;; init-shell.el --- Shell configuration -*- lexical-binding: t -*-

;;; The emacs shell (eshell.el)
(use-package eshell
  :hook
  (eshell-pre-command . eshell-save-some-history)
  :bind
  (:map eshell-mode-map
        ("C-r" . consult-history))
  :init
  (setq password-cache t
        password-cache-expiry 600

        eshell-hist-ignoredups t
        eshell-history-size 10000
        eshell-buffer-maximum-lines 10000
        eshell-scroll-to-bottom-on-input t)

  (setenv "PAGER" "cat")
  :config
  (require 'esh-mode)
  (require 'esh-module)
  (require 'em-cmpl)
  (require 'em-dirs)
  (require 'em-tramp)
  (require 'em-hist)

  (push 'eshell-tramp eshell-modules-list))

;;; Eshell prompt (lib-eshell.el)
;; (ryan-emacs-builtin-package 'lib-eshell
;;                             (setq eshell-prompt-function #'ryan-eshell-prompt
;;                                   eshell-prompt-regexp "^λ "))

;;; Unix shell (shell.el)
(use-package shell
  :init
  (setq shell-command-prompt-show-cwd t))

;;; Enhanced color support (xterm-color.el)
(use-package xterm-color
  :ensure t
  :hook
  ((eshell-before-prompt . (lambda () (setq xterm-color-preserve-properties t)))
   (eshell-pre-command . (lambda () (setenv "TERM" "xterm-256color")))
   (eshell-post-command . (lambda () (setenv "TERM" "dumb"))))
  :init
  (setq compilation-environment '("TERM=xterm-256color"))
  :config
  (require 'esh-mode)

  (setq eshell-output-filter-functions
        (remove 'eshell-handle-ansi-color eshell-output-filter-functions))
  (add-to-list 'eshell-preoutput-filter-functions 'xterm-color-filter)

  (advice-add
   'compilation-filter
   :around
   (lambda (f proc string)
     (funcall f proc (xterm-color-filter string)))))

;;; Process monitor (proced.el)
(use-package proced
  :ensure t
  :init
  (setq proced-auto-update-flag t))

;;; Password store (password-store.el)
(use-package password-store
  :ensure t
  :bind
  ("C-c k" . password-store-copy)
  :init
  (setq password-store-time-before-clipboard-restore 30))

;;; Password store major mode (pass.el)
(use-package pass
  :ensure t)

(provide 'init-shell)

;;; init-shell.el ends here
