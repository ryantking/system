;;; init-org.el --- Org workflow -*- lexical-binding: t -*-

;;; Information manager (org-mode)
(use-package org
  :demand t
  :hook
  ((org-agenda-after-show . pulsar-recenter-middle)
   (org-agenda-after-show . pulsar-reveal-entry)
   (org-follow-link-hook . pulsar-recenter-middle)
   (org-follow-link-hook . pulsar-reveal-entry))
  :bind
  (("C-c a" . org-agenda)
   ("C-c c" . org-capture)
   :map org-mode-map
   ("C-x n n" . org-toggle-narrow-to-subtree))
  :init
  (defun my/expand-org-file-name (filename)
    (expand-file-name filename org-directory))

  (defun my/org-inbox-file () (my/expand-org-file-name "inbox.org"))
  (defun my/org-todo-file () (my/expand-org-file-name "todo.org"))
  (defun my/org-notes-file () (my/expand-org-file-name "notes.org"))
  (defun my/org-diary-file () (my/expand-org-file-name "diary.org"))
  (defun my/org-calendar-directory () (my/expand-org-file-name "calendar/"))
  (defun my/org-templates-directory () (my/expand-org-file-name "templates/"))
  (defun my/org-attachment-directory () (my/expand-org-file-name "attachments/"))

  (setq org-directory (expand-file-name "~/Documents/org")
        org-imenu-depth 3
        org-M-RET-may-split-line '((default . nil))
        ;; org-hide-emphasis-markers t
        org-pretty-entities t
        ;; org-hide-leading-stars t
        org-startup-folded 'content
        ;; org-catch-invisible-edits 'show
        org-loop-over-headlines-in-active-region 'start-level
        org-modules '(org-crypt org-eshell)
        org-use-sub-superscripts '{}
        org-insert-heading-respect-content t

        ;;; todo and refile
        org-refile-targets
        `((nil :maxlevel . 3)
          (,(my/org-todo-file) . (:maxlevel . 2))
          (,(my/org-notes-file) . (:maxlevel . 3)))
        org-refile-use-outline-path 'file
        org-outline-path-complete-in-steps nil
        org-refile-allow-creating-parent-nodes 'confirm
        ;; org-refile-use-cache t
        org-use-fast-tag-selection 'expert
        org-fontify-quote-and-verse-blocks t
        org-fontify-whole-block-delimiter-line t
        org-enforce-todo-dependencies t
        org-enforce-todo-checkbox-dependencies t
        org-track-ordered-property-with-tag t
        org-priority-default 68
        org-priority-lowest 68

        ;;; log
        org-log-into-drawer t
        org-log-note-clock-out t

        ;;; capture
        org-capture-templates
        `(("i" "Inbox" entry (file ,(my/org-inbox-file)) "* %?\n%i\n%a")
          ("p" "Project" entry (file+headline ,(my/org-todo-file) "Projects")
           (file ,(expand-file-name "project.org" (my/org-templates-directory)))))

        ;;; agenda
        org-agenda-files
        (list
         (my/org-inbox-file) (my/org-todo-file) (my/org-notes-file)
         (my/org-calendar-directory))
        org-default-notes-file (my/org-notes-file)
        org-agenda-window-setup 'current-window

        org-agenda-todo-ignore-timestamp t
        org-agenda-todo-ignore-scheduled 'all
        org-agenda-todo-ignore-deadlines 'far
        org-agenda-tags-todo-honor-ignore-options t
        org-agenda-skip-scheduled-if-done t
        org-agenda-skip-deadline-prewarning-if-scheduled 'pre-scheduled

        ;;; source blocks
        org-confirm-babel-evaluate nil
        org-src-window-setup 'current-window

        ;;; exports
        org-export-headline-levels 8
        org-export-backends '(html latex texinfo md))
  :config
  (advice-add 'org-refile :after
              (lambda (&rest _)
                (my/org-save-all))))

;;; Org extensions (lib-org.el)
(use-package lib-org
  :demand t
  :bind
  (("C-c T" . my/consult-org-all)
   ("C-c N" . my/consult-org-notes)
   ("C-c O" . my/consult-ripgrep-org-directory)))

;;; Stylized org files (org-modern.el)
(use-package org-modern
  :ensure t
  :hook org-mode
  :hook (org-agenda-finalize . org-modern-agenda))

;;; Appointment reminders (appt.el)
(use-package appt
  :init
  (setq appt-display-diary nil)
  :config
  (run-at-time 10 nil #'appt-activate 1))

(provide 'init-org)

;;; init-org.el ends here
