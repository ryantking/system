;;; lib-tab.el --- Tab bar configuration -*- lexical-binding: t -*-

(require 'tab-bar)

(defgroup ryan-tab ()
  "Extensions for tab-bar.el."
  :group 'tab-bar)

(defcustom ryan-tab-tab-select-num-threshold 3
  "Minimum number of tabs to prompt for numeric selection.
This is used by `ryan-tab-select-tab-dwim' to determine whether
it should prompt for completion, or to ask for just a tab number
to switch to.  If the number of open tabs is greater than this
variable's value, then the command will prompt for a number."
  :type 'integer
  :group 'ryan-tab)


(defun ryan-tab--tab-bar-tabs ()
  "Return a list of `tab-bar' tabs, minus the current one."
  (mapcar (lambda (tab)
            (alist-get 'name tab))
          (tab-bar--tabs-recent)))

;;;###autoload
(defun ryan-tab-select-tab-dwim (&optional arg)
  "Do-What-I-Mean function for getting to a `tab-bar' tab.
If no other tab exists, or with optional prefix argument
ARG (\\[universal-argument]), create one and switch to it.

If there is one other tab (so two in total) switch to it without
further questions.

If the tabs are more than `ryan-tab-tab-select-num-threshold',
show numeric hints (`tab-bar-tab-hints') and prompt for a number
to switch to.  Else prompt for full text completion."
  (interactive "P")
  (let ((tabs (ryan-tab--tab-bar-tabs)))
    (cond
     ((or arg (null tabs))
      (tab-new))
     ((length= tabs 1)
      (tab-next))
     ((length> tabs (1- ryan-tab-tab-select-num-threshold))
      (let ((tab-bar-tab-hints t)
            (bar tab-bar-mode))
        (unwind-protect
            (progn
              (unless bar
                (ryan-tab-bar-toggle 1))
              (tab-bar-select-tab
               (read-number "Go to tab NUM: ")))
          (unless bar
            (ryan-tab-bar-toggle -1)))))
     (t
      (tab-bar-switch-to-tab
       (completing-read "Select tab: " tabs nil t))))))

;;;###autoload
(define-minor-mode ryan-tab-bar-toggle
  "Toggle `tab-bar' presentation."
  :init-value nil
  :global t
  (if (or ryan-tab-bar-toggle
          (not (bound-and-true-p tab-bar-mode)))
      (progn
        (setq tab-bar-show t)
        (tab-bar-mode 1))
    (setq tab-bar-show nil)
    (tab-bar-mode -1)))

(declare-function winner-undo "winner")
(declare-function winner-redo "winner")

;;;###autoload
(defun ryan-tab-winner-undo ()
  "Go to previous window layout in the history.
When Tab-Bar-Mode and Tab-Bar-History-Mode are active, use
history that is specific to the current tab.  Else try to call
`winner-undo' if Winner-Mode is active.  Signal an error
otherwise."
  (interactive)
  (if (and (bound-and-true-p tab-bar-mode)
           (bound-and-true-p tab-bar-history-mode))
      (progn
        (tab-bar-history-back)
        (setq this-command 'tab-bar-history-back))
    (if (bound-and-true-p winner-mode)
        (progn
          (winner-undo)
          (setq this-command 'winner-undo))
      (user-error "No `tab-bar-history-mode' or `winner-mode' active"))))

;;;###autoload
(defun ryan-tab-winner-redo ()
  "Go to next window layout in the history.
When Tab-Bar-Mode and Tab-Bar-History-Mode are active, use
history that is specific to the current tab.  Else try to call
`winner-redo' if Winner-Mode is active.  Signal an error
otherwise."
  (interactive)
  (if (and (bound-and-true-p tab-bar-mode)
           (bound-and-true-p tab-bar-history-mode))
      (progn
        (tab-bar-history-forward)
        (setq this-command 'tab-bar-history-forward))
    (if (bound-and-true-p winner-mode)
        (progn
          (winner-redo)
          (setq this-command 'winner-redo))
      (user-error "No `tab-bar-history-mode' or `winner-mode' active"))))

;;;###autoload
(define-minor-mode ryan-tab-status-line
  "Make Tab bar a status line and configure the extras.
Hide the mode lines and change their colors."
  :global t
  :group 'ryan-tab
  (if ryan-tab-status-line
      (progn
        (setq tab-bar-show t)
        (tab-bar-mode 1)
        (tab-bar-history-mode 1)
        (display-time-mode 1)
        (when (featurep 'ryan-notmuch)
          (ryan-notmuch-mail-indicator 1)))
    (tab-bar-mode -1)
    (tab-bar-history-mode -1)
    (display-time-mode -1)
    (when (featurep 'ryan-notmuch)
      (ryan-notmuch-mail-indicator -1))))

(provide 'lib-tab)

;;; lib-tab.el ends here
