;;; init-dired.el --- Dired mode setup -*- lexical-binding: t -*-

;;; The directory editor (dired.el)
(use-package dired
  :hook
  ((dired-mode . dired-hide-details-mode)
   (dired-mode . hl-line-mode))
  :init
  (setq dired-recursive-copies 'always
        dired-recursive-deletes 'always
        delete-by-moving-to-trash nil
        dired-listing-switches "-AGFhlv --group-directories-first --time-style=long-iso"
        dired-dwim-target t
        dired-auto-revert-buffer #'dired-directory-changed-p))

;;; Builtin dired helpers (dired-aux.el)
(use-package dired-aux
  :bind
  (:map dired-mode-map
        ("C-+" . dired-create-empty-file)
        ("M-s f" . nil)
        ("C-x v v" . dired-vc-next-action))
  :init
  (setq dired-isearch-filenames 'dwim
        dired-create-destination-dirs t
        dired-vc-rename-file t
        dired-do-revert-buffer (lambda (dir) (not (file-remote-p dir)))))

;;; Dired extensions (dired-x.el)
(use-package dired-x)

;;; Custom dired extensions (lib-dired.el)
(use-package lib-dired
  :hook
  (dired-mode . ryan-dired-setup-imenu)
  :bind
  (:map dired-mode-map
        ("i" . ryan-dired-insert-subdir)
        ("/" . ryan-dired-limit-regexp)
        ("C-c C-l" . ryan-dired-limit-regexp)
        ("M-n" . ryan-dired-subdirectory-next)
        ("C-c C-n" . ryan-dired-subdirectory-next)
        ("M-p" . ryan-dired-subdirectory-previous)
        ("C-c C-p" . ryan-dired-subdirectory-previous)
        ("M-s G" . ryan-dired-grep-marked-files)))

;;; Browse dired subtrees (dired-subtree.el)
(use-package dired-subtree
  :ensure t
  :config
  (setq dired-subtree-use-backgrounds nil)
  (let ((map dired-mode-map))
    (define-key map (kbd "<tab>") #'dired-subtree-toggle)
    (define-key map (kbd "<backtab>") #'dired-subtree-remove)))

;;; Rename files in dired (wdired.el)
(use-package wdired
  :init
  (setq wdired-allow-to-redirect-links t))

;;; View images in dired (image-dired.el)
(use-package image-dired
  :bind
  (:map image-dired-thumbnail-mode-map
        ("<return>" . image-dired-thumbnail-display-external)))

;;; Dired-like interface for the traysh (trashed.el)
(use-package trashed
  :ensure t
  :init
  (setq trashed-action-confirmer 'y-or-n-p
        trashed-date-format "%Y-%m-%d %H:%M:%S"))

;;; Dired-like interface for buffers (ibuffer.el)
(use-package ibuffer
  :hook
  (ibuffer-mode . hl-line-mode)
  :bind
  (("C-x C-b" . ibuffer)
   :map ibuffer-mode-map
   ("* f" . ibuffer-mark-by-file-name-regexp)
   ("* g" . ibuffer-mark-by-name-regexp)
   ("s n" . ibuffer-do-sort-by-alphabetic)
   ("/ g" . ibuffer-filter-by-content))
  :init
  (setq ibuffer-expert t
        ibuffer-use-other-window nil
        ibuffer-default-sorting-mode 'filename/process))

;;; Dired-like list for registers (rlist.el)
(use-package rlist
  :vc (:fetcher "gitlab" :repo "mmemmew/rlist")
  :bind
  (("C-x r <backspace>" . rlist-list-registers)
   ("C-x r DEL" . rlist-list-registers))
  :init
  (setq rlist-expert t
        rlist-verbose t))

;;; Dired-like lists (ilist.el)
(use-package ilist
  :ensure t)

;;; Dired like bookmarks view (blist.el)
(use-package blist
  :ensure t
  :bind
  ("C-x r l" . blist-list-bookmarks)
  :init
  (setq blist-expert t)
  :config
  (blist-define-criterion "info" "Info"
                          (eq (bookmark-get-handler bookmark)
                              #'Info-bookmark-jump))

  (setq blist-filter-groups
        (list
         (cons "Eshell" #'blist-eshell-p)
         (cons "Info" #'blist-info-p)
         (cons "Default" #'blist-default-p))))

(provide 'init-dired)

;;; init-dired.el ends here
