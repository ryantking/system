;;; init-history.el --- History management -*- lexical-binding: t -*-

;;; Record cursor position
(use-package saveplace
  :config
  (save-place-mode 1))

;;;; Backup files

(setq backup-directory-alist
      `(("." . ,(concat user-emacs-directory "backup/")))
      backup-by-copying t
      version-control t
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2)

(add-to-list 'backup-directory-alist
             (cons tramp-file-name-regexp (concat user-emacs-directory "backup/")))

(let ((auto-save-directory (concat user-emacs-directory "auto-save/")))
  auto-save-file-name-transforms `((".*" ,auto-save-directory t))

  (unless (file-exists-p auto-save-directory)
    (make-directory auto-save-directory)))

(provide 'init-history)

;;; init-history.el ends here
