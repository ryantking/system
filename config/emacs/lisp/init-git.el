;;; init-git.el --- Git interface -*- lexical-binding: t -*-

;;; Diff viewing (diff-mode.el)
(use-package diff-mode
  :bind
  (:map diff-mode-map
        ("L" . vc-print-root-log)
        ("v" . vc-next-action))
  :init
  (setq diff-refine t
        diff-font-lock-prettify t))

;;; Version control framework (vc.el)
(use-package vc
  :hook
  (log-view-mode . hl-line-mode)
  :bind
  (("C-x v B" . vc-annotate)
   ("C-x v t" . vc-create-tag)
   ("C-x v e" . vc-ediff)
   ("C-x v k" . vc-delete-file)
   ("C-x v G" . vc-log-search)
   ("C-x v d" . vc-diff)
   :map vc-dir-mode-map
   ("t" . vc-create-tag)
   ("O" . vc-log-outgoing)
   ("o" . vc-dir-find-file-other-window)
   ("d" . vc-diff)
   ("k" . vc-dir-delete-file)
   ("G" . vc-revert)
   :map vc-git-stash-shared-map
   ("a" . vc-git-stash-apply-at-point)
   ("c" . vc-git-stash)
   ("k" . vc-git-stash-delete-at-point)
   ("p" . vc-git-stash-pop-at-point)
   ("s" . vc-git-stash-snapshot)
   :map vc-annotate-mode-map
   ("M-q" . vc-annotate-toggle-annotation-visibility)
   ("C-c C-c" . vc-annotate-goto-line)
   ("<return>" . vc-annotate-find-revision-at-line)
   :map vc-git-log-edit-mode-map
   ("M-s" . nil)
   ("M-r" . nil)
   :map vc-git-log-view-mode-map
   ("<tab>" . log-view-toggle-entry-display)
   ("<return>" . log-view-find-revision)
   ("s" . vc-log-search)
   ("o" . vc-log-outgoing)
   ("f" . vc-log-incoming)
   ("F" . vc-update)
   ("P" . vc-pull))
  :init
  (setq vc-find-revision-no-save t
        vc-annotate-display-mode 'scale
        add-log-mailing-address (getenv "GITHUB_EMAIL")
        add-log-keep-changes-together t
        vc-git-diff-switches '("--path-with-stat" "--histogram")
        vc-git-print-log-follow t)
  :config
  (require 'vc-annotate)
  (require 'vc-dir)
  (require 'vc-git)
  (require 'add-log)
  (require 'log-view)
  (require 'log-edit))

;;; VC extension functions (agitate.el)
(use-package agitate
  :vc (:fetcher "github" :repo "protesilaos/agitate")
  :custom
  (agitate-log-edit-informative-show-root-log t)
  :hook
  (diff-mode . agitate-diff-enable-outline-minor-mode)
  :bind
  (("C-x v =" . agitate-diff-buffer-or-file)
   ("C-x v g" . agitate-vc-git-grep)
   ("C-x v f" . agitate-vc-git-find-revision)
   ("C-x v s" . agitate-vc-git-show)
   ("C-x v w" . agitate-vc-git-kill-commit-message)
   ("C-x v p p" . agitate-vc-git-format-patch-single)
   ("C-x v p n" . agitate-vc-git-format-patch-n-from-head)
   :map diff-mode-map
   ("C-c C-b" . agitate-diff-refine-cycle)
   ("C-c C-n" . agitate-diff-narrow-dwim)
   :map log-view-mode-map
   ("w" . agitate-log-view-kill-revision)
   ("W" . agitate-log-view-kill-revision-expanded)
   :map vc-git-log-view-mode-map
   ("c" . agitate-vc-git-format-patch-single)
   :map log-edit-mode-map
   ("C-c C-i C-n" . agitate-log-edit-insert-file-name)
   ("C-c C-i C-e" . agitate-log-edit-emoji-commit)
   ("C-c C-i C-c" . agitate-log-edit-conventional-commit))
  :config
  (advice-add #'vc-git-push :override #'agitate-vc-git-push-prompt-for-remote)

  (agitate-log-edit-informative-mode 1))

;;; Powerful git frontend (magit.el)
(use-package magit
  :ensure t
  :bind
  ("C-c g" . magit-status)
  :init
  (setq magit-define-global-key-bindings nil
        git-commit-style-convention-checks '(non-empty-second-line overlong-summary-l)
        magit-diff-refine-hunk t
        magit-repository-directories '(("~/Projects" . 1) ("~/System/" . 0)))
  :config
  (require 'git-commit)
  (require 'magit-diff)
  (require 'magit-repos))

;;; Simple merges (smerge-mode.el)
(use-package smerge-mode)

;;; More complex diffs (ediff.el)
(use-package ediff
  :init
  (setq ediff-keep-variants nil
        ediff-show-clashes-only t
        ediff-split-window-function 'split-window-horizontally
        ediff-window-setup-function 'ediff-setup-windows-plain))

(provide 'init-git)

;;; init-git.el ends here
