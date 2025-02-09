;;; ryan-simple.el --- Simple emacs commands -*- lexical-binding: t -*-

(eval-when-compile
  (require 'cl-lib))

(defgroup ryan-simple ()
  "Generic utilities for Emacs"
  :group 'editing)

;;;###autoload
(defun ryan-simple-describe-symbol ()
  "Run `describe-symbol' for the `symbol-at-point'."
  (interactive)
  (describe-symbol (symbol-at-point)))

;;;###autoload
(defun ryan-simple-new-line-below (&optional arg)
  (interactive "P")
  (end-of-line)
  (if arg (newline-and-indent) (newline)))

;;;###autoload
(defun ryan-simple-new-line-above (&optional arg)
  (interactive "P")
  (let ((indent (or arg nil)))
    (if (or (bobp) (line-number-at-pos (point-min)))
        (progn
          (beginning-of-line)
          (newline)
          (forward-line -1))
      (forward-line -1)
      (ryan-simple-new-line-below))))


;;;###autoload
(defun ryan-simple-copy-line-or-region (&optional arg)
  "Kill-save the current line or active region.
With optional ARG (\\[universal-argument]) duplicate the target
instead.  When region is active, also apply context-aware
indentation while duplicating."
  (interactive "P")
  (unless mark-ring                  ; needed when entering a new buffer
    (push-mark (point) t nil))
  (let* ((rbeg (region-beginning))
         (rend (region-end))
         (pbol (point-at-bol))
         (peol (point-at-eol))
         (indent (if (eq (or rbeg rend) pbol) nil arg)))
    (cond
     ((use-region-p)
      (if arg
          (let ((text (buffer-substring rbeg rend)))
            (when (eq (point) rbeg)
              (exchange-point-and-mark))
            (ryan-simple-new-line-below indent)
            (insert text))
        (copy-region-as-kill rbeg rend)
        (message "Current region copied")))
     (t
      (if arg
          (let ((text (buffer-substring pbol peol)))
            (goto-char (point-at-eol))
            (newline)
            (insert text))
        (copy-region-as-kill pbol peol)
        (message "Current line copied"))))))

;;;###autoload
(defun ryan-simple-yank-replace-line-or-region ()
  "Replace line or region with latest kill.
This command can then be followed by the standard
`yank-pop' (default is bound to \\[yank-pop])."
  (interactive)
  (if (use-region-p)
      (delete-region (region-beginning) (region-end))
    (delete-region (point-at-bol) (point-at-eol)))
  (yank))

;;;###autoload
(defun ryan-simple-multi-line-next ()
  "Move point 15 lines down."
  (interactive)
  (forward-line 15))

;;;###autoload
(defun ryan-simple-multi-line-prev ()
  "Move point 15 lines up."
  (interactive)
  (forward-line -15))

;;;###autoload
(defun ryan-simple-kill-line-backward ()
  "Kill from point to the beginning of the line."
  (interactive)
  (kill-line 0))


(defmacro ryan-simple-mark (name object &optional docstring)
  "Produce function for marking small syntactic constructs.
NAME is how the function should be called.  OBJECT is its scope.
Optional DOCSTRING describes the resulting function.

This is a slightly modified version of the built-in `mark-word'."
  `(defun ,name (&optional arg allow-extend)
     ,docstring
     (interactive "P\np")
     (let ((x (format "%s-%s" "forward" ,object)))
       (cond ((and allow-extend
                   (or (and (eq last-command this-command) (mark t))
                       (region-active-p)))
              (setq arg (if arg (prefix-numeric-value arg)
                          (if (< (mark) (point)) -1 1)))
              (set-mark
               (save-excursion
                 (goto-char (mark))
                 (funcall (intern x) arg)
                 (point))))
             (t
              (let ((bounds (bounds-of-thing-at-point (intern ,object))))
                (unless (consp bounds)
                  (user-error "No %s at point" ,object))
                (if (>= (prefix-numeric-value arg) 0)
                    (goto-char (car bounds))
                  (goto-char (cdr bounds)))
                (push-mark
                 (save-excursion
                   (funcall (intern x) (prefix-numeric-value arg))
                   (point)))
                (activate-mark)))))))

(ryan-simple-mark
 ryan-simple-mark-word
 "word"
 "Mark the whole word at point.
This function is a slightly modified version of the built-in
`mark-word', that I intend to use only in special circumstances,
such as when recording a keyboard macro where precision is
required.  For a general purpose utility, use `ryan-simple-mark-symbol'
instead.")

(ryan-simple-mark
 ryan-simple-mark-symbol
 "symbol"
 "Mark the whole symbol at point.
With optional ARG, mark the current symbol and any remaining
ARGth symbols away from point.  A negative argument moves
backward. Repeated invocations of this command mark the next
symbol in the direction originally specified.

In the absence of a symbol and if a word is present at point,
this command will operate on it as described above.")

;;;###autoload
(defun ryan-simple-mark-sexp-backward (&optional arg)
  "Mark previous or ARGth balanced expression[s].
Just a convenient backward-looking `mark-sexp'."
  (interactive "P")
  (if arg
      (mark-sexp (- arg) t)
    (mark-sexp (- 1) t)))

;;;###autoload
(defun ryan-simple-unfill-region-or-paragraph (&optional beg end)
  "Unfill paragraph or, when active, the region.
Join all lines in region delimited by BEG and END, if active,
while respecting any empty lines (so multiple paragraphs are not
joined, just unfilled).  If no region is active, operate on the
paragraph.  The idea is to produce the opposite effect of both
`fill-paragraph' and `fill-region'."
  (interactive "r")
  (let ((fill-column most-positive-fixnum))
    (if (use-region-p)
        (fill-region beg end)
      (fill-paragraph))))


;;;###autoload
(defun ryan-simple-rename-file-and-buffer (name)
  "Apply NAME to current file and rename its buffer.
Do not try to make a new directory or anything fancy."
  (interactive
   (list (read-string "Rename current file: " (buffer-file-name))))
  (let ((file (buffer-file-name)))
    (if (vc-registered file)
        (vc-rename-file file name)
      (rename-file file name))
    (set-visited-file-name name t t)))

;;;###autoload
(defun ryan-simple-kill-buffer-current (&optional arg)
  "Kill current buffer or abort recursion when in minibuffer.
With optional prefix ARG (\\[universal-argument]) delete the
buffer's window as well."
  (interactive "P")
  (if (minibufferp)
      (abort-recursive-edit)
    (kill-buffer (current-buffer)))
  (when (and arg
             (not (one-window-p)))
    (delete-window)))

(provide 'lib-simple)

;;; lib-simple.el ends here
