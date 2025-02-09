;;; lib-bookmark.el --- Bookmark functions -*- lexical-binding: t -*-

(require 'lib-common)

(defgroup ryan-bookmark ()
  "Bookmarking extras."
  :group 'matching)

(defface ryan-bookmark-url '((t :inherit link :underline nil))
  "Face for URL bookmarks.")

(defface ryan-bookmark-pdf '((t :inherit error))
  "Face for PDF bookmarks.")

(defface ryan-bookmark-directory '((t :inherit success))
  "Face for directory bookmarks.")

(defconst ryan-bookmark-keywords
  `((,(concat "\\(.*\\)" " " ryan-common-url-regexp)
     (1 '(bold ryan-bookmark-url) t)
     (2 'ryan-bookmark-url t))
    ("\\(.*\\)\\( [~/].*\\.pdf\\)"
     (1 '(bold ryan-bookmark-pdf) t)
     (2 'ryan-bookmark-pdf t))
    ("\\(.*\\)\\( [~/].*/$\\)"
     (1 '(bold ryan-bookmark-directory) t)
     (2 'ryan-bookmark-directory t))
    ("\\(.*org.*last-stored.*\\)"
     (1 'shadow t)))
  "Extra font-lock patterns for the Bookmark menu.")

;;;###autoload
(define-minor-mode ryan-bookmark-extra-keywords
  "Apply extra font-lock rules to bookmark list buffers."
  :init-value nil
  :global t
  (if ryan-bookmark-extra-keywords
      (progn
        (font-lock-flush (point-min) (point-max))
        (font-lock-add-keywords nil ryan-bookmark-keywords nil)
        (add-hook 'bookmark-bmenu-mode-hook #'ryan-bookmark-extra-keywords))
    (font-lock-remove-keywords nil ryan-bookmark-keywords)
    (remove-hook 'bookmark-bmenu-mode-hook #'ryan-bookmark-extra-keywords)
    (font-lock-flush (point-min) (point-max))))

(provide 'lib-bookmark)

;;; lib-bookmark.el ends here
