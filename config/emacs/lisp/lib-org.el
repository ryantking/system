;;; lib-org.el --- Org mode extensions -*- lexical-binding: t -*-

(defun my/consult-org-agenda ()
  (interactive)
  (consult-org-agenda)
  (org-tree-to-indirect-buffer))

(setq my/consult-org-files
      (list (my/org-inbox-file) (my/org-todo-file) (my/org-notes-file)))

(defun my/consult-org-all ()
  (interactive)
  (consult-org-heading
   "+LEVEL<=3"
   my/consult-org-files))

(defun my/consult-org-notes ()
  (interactive)
  (consult-org-heading
   "+LEVEL<=3"
   (list (my/org-notes-file))))

(defun my/consult-ripgrep-org-directory ()
  (interactive)
  (require 'consult)
  (let ((consult-ripgrep-args
         (concat consult-ripgrep-args " --no-ignore-vcs")))
    (consult-ripgrep org-directory "")))

(defun my/org-save-all ()
  "Saves all open buffers without user confirmation."
  (interactive)
  (message "Saving org-agenda files...")
  (save-some-buffers t (lambda ()
                         (when (member (ff-basename (buffer-file-name)) org-agenda-files) t)))
  (message "Saving org-agenda files...done"))

(defun my/org-archive-done-tasks ()
  (interactive)
  (org-map-entries 'org-archive-subtree "/DONE" 'file))

;;;; org-agenda

(declare-function calendar-day-name "calendar")
(declare-function calendar-day-of-week "calendar")
(declare-function calendar-month-name "calendar")
(declare-function org-days-to-iso-week "org")
(declare-function calendar-absolute-from-gregorian "calendar")

(defvar org-agenda-format-date)

;;;###autoload
(defun my/org-agenda-format-date-aligned (date)
  (require 'cal-iso)
  (let* ((dayname (calendar-day-name date t))
         (day (cadr date))
         (day-of-week (calendar-day-of-week date))
         (month (car date))
         (monthname (calendar-month-name month t))
         (year (nth 2 date))
         (iso-week (org-days-to-iso-week (calendar-absolute-from-gregorian date)))
         (weekstring (if (= day-of-week 1)
                         (format " (W%02d)" iso-week)
                       "")))
    (format "%s %2d %s %4d%s" dayname day monthname year weekstring)))

(defvar org-priority-highest)

(defun my/org-present--prepare-slide ()
  (org-overview)
  (org-show-entry)
  (org-show-children))

(defun my/org-present-hook ()
  (setq-local face-remapping-alist '((default (:height 1.5) variable-pitch)
                                     (header-line (:height 4.5) variable-pitch)
                                     (org-document-title (:height 1.75) org-document-title)
                                     (org-code (:height 1.55) org-code)
                                     (org-verbatim (:height 1.55) org-verbatim)
                                     (org-block (:height 1.25) org-block)
                                     (org-block-begin-line (:height 0.7) org-block)))
  (setq header-line-format " ")
  (org-appear-mode -1)
  (org-display-inline-images)
  (my/org-present--prepare-slide))

(defun my/org-present-quit-hook ()
  (setq-local face-remapping-alist '((default variable-pitch default)))
  (setq header-line-format nil)
  (org-present-small)
  (org-remove-inline-images)
  (org-appear-mode 1))

(defun my/org-present-prev ()
  (interactive)
  (org-present-prev)
  (my/org-present--prepare-slide))

(defun my/org-present-next ()
  (interactive)
  (org-present-next)
  (my/org-present--prepare-slide)
  (when (fboundp 'live-crafter-add-timestamp)
    (live-crafter-add-timestamp (substring-no-properties (org-get-heading t t t t)))))

(provide 'lib-org)

;;; lib-org.el ends here
