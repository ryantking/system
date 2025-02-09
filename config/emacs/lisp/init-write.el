;;; init-write.el ---  -*- lexical-binding: t -*-

;;; Outline mode (outline.ed)
(use-package outline
  :bind
  ("<F10>" . outline-minor-mode)
  :init
  (setq outline-minor-mode-cycle t))

(defun my/consult-find-note ()
  (interactive)
  (consult-find (expand-file-name "~/Documents/notes")))

(defun my/consult-find-book ()
  (interactive)
  (consult-find (expand-file-name "~/Documents/books")))

(defun my/consult-find-presentation ()
  (interactive)
  (consult-find (expand-file-name "~/Documents/presentations")))

  ;;; Simple note-taking (denote)
(use-package denote
  :ensure t
  :hook
  (dired-mode . denote-dired-mode)
  :bind
  (("C-c n n" . denote-create-note)
   ("C-c n N" . denote-type)
   ("C-c n d" . denote-date)
   ("C-c n s" . denote-subdirectory)
   ("C-c n i" . denote-link)
   ("C-c n I" . denote-link-add-links)
   ("C-c n l" . denote-link-find-file)
   ("C-c n b" . denote-link-backlints)
   ("C-c n r" . denote-dired-rename-file)
   ("C-c n o" . my/consult-find-note)
   ("C-c n b" . my/consult-find-book)
   ("C-c n p" . my/consult-find-presentation))
  :init
  (setq denote-directory (expand-file-name "~/Documents/notes/"))

  (with-eval-after-load 'org-capture
    (add-to-list 'org-capture-templates
                 '("n" "New note" plain
                   (file denote-last-path)
                   #'denote-org-capture
                   :no-save t
                   :immediate-finish nil
                   :kill-buffer t
                   :jump-to-captured t))))


;;; Focus mode extensions (olivetti.el)
(use-package olivetti
  :ensure t
  :init
  (setq olivetti-body-width 0.7
        olivetti-minimum-body-width 80))

;;; Focus mode (logos.el)
(use-package logos
  :ensure t
  :bind
  (("<f9>" . logos-focus-mode)
   :map logos-focus-mode-map
   ([remap narrow-to-region] . logos-narrow-dwim)
   ([remap forward-page] . logos-forward-page-dwim)
   ([remap backward-page] . logos-backward-page-dwim)
   ("M-]" . logos-forward-page-dwim)
   ("M-[" . logos-backward-page-dwim))
  :init
  (setq logos-outlines-are-pages t)

  (setq-default logos-variable-pitch t
                logos-olivetti t))

;;; Spell check (spell-fu.el)
(use-package spell-fu
  :vc (:fetcher "github" :repo "emacsmirror/spell-fu")
  :bind
  ("C-c ! S" . spell-fu-mode)
  :init
  (setq spell-fu-directory (locate-user-emacs-file "spell-fu")))

;;; Enhanced spelling correction (lib-spell.el)
(use-package lib-spell
  :hook
  ((spell-fu-mode . ryan-spell-setup-spell-fu))
  :bind
  ("M-$" . ryan-spell-correct))

(provide 'init-write)

;;; init-write.el ends here
