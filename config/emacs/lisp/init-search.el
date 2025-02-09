;;; init-search.el --- Search configurations -*- lexical-binding: t -*-

;;; Isearch, occur, grep, and extras (isearch.el)
(use-package isearch
  :bind
  (:map isearch-mode-map
        ("C-g" . isearch-cancel)
        ("M-/" . isearch-complete))
  :init
  (setq search-whitespace-regexp ".*?"
        isearch-lazy-count t
        lazy-count-prefix-format " (%s/%s)"
        isearch-yank-on-move 'shift
        isearch-allow-scroll t
        isearch-repeat-on-direction-change t))

;;; Replace mode (replace.el)
(use-package replace
  :hook ((occur-mode . hl-line-mode)
         (occur-mode . ryan-common-truncate-lines-silently))
  :bind
  (:map occur-mode-map
        ("t" . toggle-truncate-lines)))

;;; Emacs grep (grep.el)
(use-package grep)

;;; Extensions to search (lib-search.el)
;; (use-package lib-search
;;   :bind
;;   (("M-s %" . ryan-search-isearch-replace-symbol)
;;    ("M-s M-%" . ryan-search-replace-markup)
;;    ("M-s M-<" . ryan-search-isearch-beginning-of-buffer)
;;    ("M-s g" . ryan-search-grep)
;;    ("M-s u" . ryan-search-occur-urls)
;;    ("M-s t" . ryan-search-grep-todo-keywords)
;;    ("M-s M-t" . ryan-search-grep-todo-keywords)
;;    :map isearch-mode-map
;;    ("<up>" . ryan-search-isearch-repeat-backward)
;;    ("<down>" . ryan-search-isearch-repeat-forward)
;;    ("<backpace>" . ryan-search-isearch-abort-dwim)
;;    ("<C-return>" . ryan-search-isearch-other-end)))

;;; Regular expression builder (re-builder.el)
(use-package re-builder)

;;; Writeable grep (wgrep.el)
(use-package wgrep
  :ensure t
  :bind
  (:map grep-mode-map
        ("e" . wgrep-change-to-wgrep-mode)
        ("C-x C-q" . wgrep-change-to-wgrep-mode)
        ("C-c C-C" . wgrep-finish-edit))
  :init
  (setq wgrep-auto-save-buffer t
        wgrep-change-readonly-file t))

;;; Cross references (xref.el)
(use-package xref
  :init
  (setq xref-show-definitions-function #'xref-show-definitions-completing-read
        xref-show-xrefs-function #'xref-show-definitions-buffer
        xref-search-program 'ripgrep))

;;; Builtin bookmarking (bookmark.el)
(use-package bookmark
  :hook (bookmark-bmenu-mode . hl-line-mode))

;;; Bookmark extensions (lib-bookmark.el)
(use-package lib-bookmark
  :config
  (ryan-bookmark-extra-keywords 1))

;;; Project management (project.el)
(use-package project
  :bind
  ("C-x p q" . project-query-replace-regexp)
  :init
  (setq project-switch-commands
        '((?f "File" project-find-file)
          (?s "Subdir" ryan-project-find-subdir)
          (?g "Grep" project-find-regexp)
          (?d "Dired" project-dired)
          (?b "Buffer" project-switch-to-buffer)
          (?q "Query replace" project-query-replace-regexp)
          (?t "Tag switch" ryan-project-retrieve-tag)
          (?v "VC dir" project-vc-dir)
          (?l "Log VC" ryan-project-commit-log)
          (?e "Eshell" project-eshell))))

;;; Project extensions (project-x.el)
(use-package project-x
  :vc (:fetcher "github" :repo "karthink/project-x")
  (setq project-x-window-list-file (locate-user-emacs-file "project-x-window-list"))
  :config
  (project-x-mode 1))

(provide 'init-search)

;;; init-search.el ends here
