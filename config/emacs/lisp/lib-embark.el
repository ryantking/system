;;; lib-embark.el --- Embark Extensions -*- lexical-binding: t -*-

(require 'cl-lib)
(require 'embark nil t)
(require 'lib-recentf)

(defgroup ryan-embark ()
  "Extensions for `embark'."
  :group 'editing)

;;
;;; Extra keymaps

(autoload 'consult-ripgrep "counsult")
(autoload 'consult-line "consult")
(autoload 'consult-imenu "consult")
(autoload 'consult-outline "consult")

(defvar ryan-embark-become-general-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "f") 'consult-find)
    (define-key map (kbd "g") 'consult-ripgrep)
    map)
  "General custom cross-package `embark-become' keymap.")

(defvar ryan-embark-become-line-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "l") 'consult-line)
    (define-key map (kbd "i") 'consult-imenu)
    (define-key map (kbd "s") 'consult-outline)
    map)
  "Line-specific custom cross-package `embark-become' keymap.")

(defvar embark-become-file+buffer-map)
(autoload 'ryan-recentf-recent-files "ryan-recentf")
(autoload 'project-switch-to-buffer "project")
(autoload 'project-find-file "project")

(defvar ryan-embark-become-file+buffer-map
  (let ((map (make-sparse-keymap)))
    (set-keymap-parent map embark-become-file+buffer-map)
    (define-key map (kbd "r") 'ryan-recentf-recent-files)
    (define-key map (kbd "B") 'project-switch-to-buffer)
    (define-key map (kbd "F") 'project-find-file)
    map)
  "File+buffer custom cross-package `embark-become' keymap.")

(defvar embark-become-keymaps)

;;;###autoload
(define-minor-mode ryan-embark-keymaps
  "Add or remove keymaps from Embark.
This is based on the value of `ryan-embark-add-keymaps'
and is meant to keep things clean in case I ever wish to disable
those so-called 'extras'."
  :init-value nil
  :global t
  (let ((maps (list 'ryan-embark-become-general-map
                    'ryan-embark-become-line-map
                    'ryan-embark-become-file+buffer-map)))
    (if ryan-embark-keymaps
        (dolist (map maps)
          (cl-pushnew map embark-become-keymaps))
      (setq embark-become-keymaps
            (dolist (map maps)
              (delete map embark-become-keymaps))))))

(provide 'lib-embark)

;;; lib-embark.el ends here
