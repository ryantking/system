;;; lib-fill.el --- Fill mode extension -*- lexical-binding: t -*-

(defgroup ryan-fill ()
  "Tweak for filling paragrahps."
  :group 'fill)

(defcustom ryan-fill-default-column 72
  "Default width for `fill-column'."
  :type 'integer
  :group 'ryan-fill)

(defcustom ryan-fill-prog-mode-column 120
  "`prog-mode' width for `fill-column'."
  :type 'integer
  :group 'ryan-fill)

(defun ryan-fill--fill-prog ()
  "Set local value of `fill-column' for programming nodes."
  (setq-local fill-column ryan-fill-prog-mode-column))

;;;###autoload
(define-minor-mode ryan-fill-mode
  "Set up fill-mode and relevant variables."
  :init-value nil
  :global t
  (if ryan-fill-mode
      (progn
        (setq-default fill-column ryan-fill-default-column)
        (add-hook 'prog-mode-hook #'ryan-fill--fill-prog)
        (add-hook 'text-mode-hook #'turn-on-auto-fill))
    (setq-default fill-column 80)
    (remove-hook 'prog-mode-hook #'ryan-fill--fill-prog)
    (remove-hook 'text-mode-hook #'turn-on-auto-fill)))

(provide 'lib-fill)

;;; lib-fill.el ends here
