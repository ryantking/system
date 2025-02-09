;;; init.el --- Emacs entrypoint -*- lexical-binding: t -*-

(setq frame-title-format '("%b")
      ring-bell-function 'ignore
      use-short-answers t
      initial-buffer-choice t)

;; Disable extra files
(setq make-backup-files nil
      backup-inhibited nil
      create-lockfiles nil)

;; Native compilation settings
(setq native-comp-async-report-warnings-errors 'silent)
;; (setq native-commpile-prune-cache t)

;; Funnel customizations to temp file
(setq custom-file (make-temp-file "emacs-custom-"))

;; Enable functions
(mapc
 (lambda (command)
   (put command 'disabled nil))
 '(list-timers narrow-to-region narrow-to-page upcase-region downcase-region))

;; Disable functions
(mapc
 (lambda (command)
   (put command 'disabled t))
 '(eshell project-eshell overwrite-mode iconify-frame diary))

;;;; Packages

(require 'package)

(add-hook 'package-menu-mode-hook #'hl-line-mode)

(setq package-archives
      '(("elpa" . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa" . "https://melpa.org/packages/"))

      package-archive-priorities
      '(("elpa" . 2)
        ("nongnu" . 1)))

(dolist (path '("site-lisp" "lisp"))
  (add-to-list 'load-path (locate-user-emacs-file path)))

(unless (package-installed-p 'vc-use-package)
  (package-vc-install "https://github.com/slotThe/vc-use-package"))

(require 'vc-use-package)

;;;; Modules

(require 'init-core)
(require 'init-keymap)
(require 'init-theme)
(require 'init-history)
(require 'init-font)
(require 'init-modeline)
(require 'init-completion)
(require 'init-search)
;; Need to setup tab keymap
;; Need to setup window keymap
(require 'init-window)
;; Buffer keymap
;; Register keymap
(require 'init-dired)
;; Setup denote (denote 2) with keymap
;; Set up spell keymap
(require 'init-write)
;; Redo VC and agitate keymaps
;; Add magit keymaps?
(require 'init-git)
;; pass keymap
(require 'init-shell)
(require 'init-org)
;; eglot keymap
;; flymake keymap
;; compile binding(s)
(require 'init-langs)

;;; init.el ends here
