;;; early-init.el --- Early Init File -*- lexical-binding: t -*-

;; Package management configuration
(setq package-enable-at-startup t)
(defvar package-quickstart)
(setq package-quickstart t)

;; Don't resize the frame
(setq frame-inhibit-implied-resize t
      frame-resize-pixelwise t)

;; Disable GUI elements
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(setq inhibit-splash-screen t
      use-dialog-box t
      use-file-dialog nil)

(setq inhibit-startup-echo-area-message user-login-name
      inhibit-startup-screen t
      inhibit-startup-buffer-menu t)

;; Backup variables that are changed for startup optimization
(defvar ryan--file-name-handler-alist file-name-handler-alist)
(defvar ryan--vc-handled-backends vc-handled-backends)

;; Temporary values for faster startup
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.5
      file-name-handler-alist nil
      vc-handled-backends nil)

;; Hook to restore values
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 8 1024 1024)
                  gc-cons-percentage 0.1
                  file-name-handler-alist ryan--file-name-handler-alist
                  vc-handled-backends ryan--vc-handled-backends)))

;;; early-init.el ends here
