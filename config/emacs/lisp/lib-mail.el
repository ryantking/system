;;; lib-mail.el --- Mail extensions -*- lexical-binding: t -*-

(require 'lib-common)

(defgroup ryan-mail ()
  "Extensions for mail."
  :group 'mail)

(defcustom ryan-mail-maildir-path-regexp "~/.mail/*/Inbox/new/"
  "Path used to find new mail."
  :type 'string
  :group 'ryan-mail)

(defcustom ryan-mail-mode-line-indicator-commands '(notmuch-refresh-this-buffer)
  "List of command sthat will be advised to update the mode line."
  :type 'list
  :group 'ryan-mail)

(defvar ebdb-db-list)
(autoload 'ebdb-load "ebdb")

(when (require 'ebdb nil t)
  (defun ryan-mail-ebdb-message-startup ()
    "Load EBDB if not done already."
    (unless ebdb-db-list
      (ebdb-load))))

(defface ryan-mail-count
  '((t
     :weight bold
     :inherit ryan-face-magenta))
  "Face for the modeline indicator")

(defvar ryan-mail-new-mail-string nil
  "New maildir count number.")

(defun ryan-mail--new-mail ()
  "Search for new mail in the maildir paths."
  (with-temp-buffer
    (shell-command
     (format "fd . %s -t f | wc -l" ryan-mail-maildir-path-regexp) t)
    (buffer-substring-no-properties (point-min) (1- (point-max)))))

(defun ryan-mail--mode-string (count)
  "Add properties to COUNT string."
  (when (not (string= count "0")
             (propertize (format "@%s " count)
                         'face 'ryan-mail-count
                         'help-echo "Number of new items in the maildir"))))

(defvar ryan-mail--mode-line-indicator nil
  "Internal variable used to store the state of new mail.")

(defun ryan-mail--mode-line-indicator ()
  "Prepare the new mail count indicator."
  (let* ((count (ryan-mail--new-mail))
         (indicator (ryan-mail--mode-string count))
         (old-indicator ryan-mail--mode-line-indicator))
    (when old-indicator
      (setq global-mode-string (delete old-indicator global-mode-string)))
    (cond
     ((>= (string-to-number count) 1)
      (setq global-mode-string (push indicator global-mode-string)
            ryan-mail--mode-line-indicator indicator))
     (t
      (setq ryan-mail--mode-line-indicator nil)))))

(defvar ryan-mail--mode-line-sync-hook nil
  "Hook to refresh the mode line indicator.")

(defun ryan-mail--add-hook (&rest _)
  "Run `ryan-mail--mode-line-sync-hook'."
  (run-hooks 'ryan-mail--mode-line-sync-hook))

;;;###autoload
(define-minor-mode ryan-mail-indicator
  "Enable mode line indicator with mail count."
  :init-value nil
  :global t
  (if ryan-mail-indicator
      (progn
        (run-at-time t 60 #'ryan-mail--mode-line-indicator)
        (when ryan-mail-mode-line-indicator-commands
          (dolist (fn ryan-mail-mode-line-indicator-commands)
            (advice-add fn :after #'ryan-mail--add-hook)))
        (add-hook 'ryan-mail--mode-line-sync-hook #'ryan-mail--mode-line-indicator)
        (force-mode-line-update t))
    (cancel-function-timers #'ryan-mail--mode-line-indicator)
    (setq global-mode-string (delete ryan-mail--mode-line-indicator global-mode-string))
    (remove-hook 'ryan-mail--mode-line-sync-hook #'ryan-mail--mode-line-indicator)
    (when ryan-mail-mode-line-indicator-commands
      (dolist (fn ryan-mail-mode-line-indicator-commands)
        (advice-remove fn #'ryan-mail--add-hook)))
    (force-mode-line-update t)))

(provide 'lib-mail)

;;; lib-mail.el ends here
