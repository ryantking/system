;;; lib-eshell.el --- Eshell prompt -*- lexical-binding: t -*-

(require 'magit)

(defun ryan-eshell--prompt-path ()
  (let* ((current-path (eshell/pwd))
         (git-output (shell-command-to-string "git rev-parse --show-toplevel"))
         (has-path (not (string-match "^fatal" git-output))))
    (if (not has-path)
        (abbreviate-file-name current-path)
      (string-remove-prefix (file-name-directory git-output) current-path))))

;; (defun ryan-eshell-prompt ()
;;   "A custom prompt for eshell that more closely replicates a modern prompt such as starship."
;;   (concat
;;    "\n"
;;    (propertize (ryan-eshell--prompt-path) 'face `(:foreground ,(doom-color 'yellow) :weight bold))
;;    (if (= (user-uid) 0)
;;        (propertize " #" 'face `(:foreground ,(doom-color 'red)))
;;      (propertize " λ" 'face `(:foreground ,(doom-color 'green))))
;;    (propertize " " 'face `(:foreground ,(doom-color 'fg)))))

(provide 'lib-eshell)

;;; lib-eshell.el ends here
