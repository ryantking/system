;;; lib-spell.el --- Enhanced spell mode -*- lexical-binding: t -*-

(require 'ispell)

(defvar ryan-spell--excluded-faces-alist
  '((markdown-mode
     . (markdown-code-face
        markdown-html-attr-name-face
        markdown-html-attr-value-face
        markdown-html-tag-name-face
        markdown-inline-code-face
        markdown-link-face
        markdown-markup-face
        markdown-plain-url-face
        markdown-reference-face
        markdown-url-face))
    (org-mode
     . (org-block
        org-block-begin-line
        org-block-end-line
        org-cite
        org-cite-key
        org-code
        org-date
        org-footnote
        org-formula
        org-inline-src-block
        org-latex-and-related
        org-link
        org-meta-line
        org-property-value
        org-ref-cite-face
        org-special-keyword
        org-tag
        org-todo
        org-todo-keyword-done
        org-todo-keyword-habt
        org-todo-keyword-kill
        org-todo-keyword-outd
        org-todo-keyword-todo
        org-todo-keyword-wait
        org-verbatim))
    (latex-mode
     . (font-latex-math-face
        font-latex-sedate-face
        font-lock-function-name-face
        font-lock-keyword-face
        font-lock-variable-name-face)))
  "Faces in certain major modes that spell-fu will not spellcheck.")

(defun ryan-spell--correct (replace poss word orig-pt start end)
  (cond ((eq replace 'ignore)
         (goto-char orig-pt)
         nil)
        ((eq replace 'save)
         (goto-char orig-pt)
         (ispell-send-string (concat "*" word "\n"))
         (ispell-send-string "#\n")
         (setq ispell-pdict-modified-p '(t)))
        ((or (eq replace 'buffer) (eq replace 'session))
         (ispell-send-string (concat "@" word "\n"))
         (add-to-list 'ispell-buffer-session-localwords word)
         (or ispell-buffer-local-name ; session localwords might conflict
             (setq ispell-buffer-local-name (buffer-name)))
         (if (null ispell-pdict-modified-p)
             (setq ispell-pdict-modified-p
                   (list ispell-pdict-modified-p)))
         (goto-char orig-pt)
         (if (eq replace 'buffer)
             (ispell-add-per-file-word-list word)))
        (replace
         (let ((new-word (if (atom replace)
                             replace
                           (car replace)))
               (orig-pt (+ (- (length word) (- end start))
                           orig-pt)))
           (unless (equal new-word (car poss))
             (delete-region start end)
             (goto-char start)
             (insert new-word))))
        ((goto-char orig-pt)
         nil)))

(defun ryan-spell--complete (candidates word)
  (completing-read (format "Corrections for %S: " word) candidates))

;;;###autoload
(defun ryan-spell-correct ()
  "Correct spelling of word at point."
  (interactive)
  ;; spell-fu fails to initialize correctly if it can't find aspell or a similar
  ;; program. We want to signal the error, not tell the user that every word is
  ;; spelled correctly.
  (ispell-set-spellchecker-params)
  (save-current-buffer
    (ispell-accept-buffer-local-defs))
  (cl-destructuring-bind (start . end)
      (or (bounds-of-thing-at-point 'word)
          (user-error "No word at point"))
    (let ((word (thing-at-point 'word t))
          (orig-pt (point))
          poss ispell-filter)
      (ispell-send-string "%\n")
      (ispell-send-string (concat "^" word "\n"))
      (while (progn (accept-process-output ispell-process)
                    (not (string= "" (car ispell-filter)))))
      ;; Remove leading empty element
      (setq ispell-filter (cdr ispell-filter))
      ;; ispell process should return something after word is sent. Tag word as
      ;; valid (i.e., skip) otherwise
      (unless ispell-filter
        (setq ispell-filter '(*)))
      (when (consp ispell-filter)
        (setq poss (ispell-parse-output (car ispell-filter))))
      (cond
       ((or (eq poss t) (stringp poss))
        ;; don't correct word
        (message "%s is correct" (funcall ispell-format-word-function word))
        t)
       ((null poss)
        ;; ispell error
        (error "Ispell: error in Ispell process"))
       (t
        ;; The word is incorrect, we have to propose a replacement.
        (setq res (ryan-spell--complete (nth 2 poss) word))
        ;; Some interfaces actually eat 'C-g' so it's impossible to stop rapid
        ;; mode. So when interface returns nil we treat it as a stop.
        (unless res (setq res (cons 'break word)))
        (cond
         ((stringp res)
          (ryan-spell--correct res poss word orig-pt start end))
         ((let ((cmd (car res))
                (wrd (cdr res)))
            (unless (or (eq cmd 'skip)
                        (eq cmd 'break)
                        (eq cmd 'stop))
              (ryan-spell--correct cmd poss wrd orig-pt start end)
              (unless (string-equal wrd word)
                (ryan-spell--correct wrd poss word orig-pt start end))))))
        (ispell-pdict-save t))))))

(defun ryan-spell-setup-spell-fu ()
  (require 'spell-fu)

  (spell-fu-dictionary-add (spell-fu-get-ispell-dictionary "en"))
  (spell-fu-dictionary-add (spell-fu-get-ispell-dictionary "en-computers"))
  (spell-fu-dictionary-add (spell-fu-get-ispell-dictionary "en-science"))

  ;; Add our personal dictionary so we can add words
  (spell-fu-dictionary-add
   (spell-fu-get-personal-dictionary
    "en-personal"
    (expand-file-name "~/System/etc/emacs/ispell.personal.pws")))

  ;; If we have excluded faces for the language defined, set the variable.
  (when-let (excluded (cdr (cl-find-if #'derived-mode-p ryan-spell--excluded-faces-alist :key #'car)))
    (setq-local spell-fu-faces-exclude excluded)))

(provide 'lib-spell)

;; lib-spell.el ends here
