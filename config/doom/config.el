;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Personal Information
(setq user-full-name "Ryan"
      user-mail-address "ryan@carelesslisper.xyz")

;; Basic settings
(setq undo-limit (* 80 1024 1024)
      evil-want-fine-undo t
      auto-save-default t
      truncate-string-ellipsis "…"
      password-cache-expiry nil
      scroll-margin 2)

(global-subword-mode 1)

;; Appearance
(setq doom-theme 'doom-horizon
      doom-font (font-spec :family "Iosevka Custom" :size 16 :weight 'regular)
      doom-big-font (font-spec :family "Iosevka Custom" :size 28)
      doom-variable-pitch-font (font-spec :family "Overpass" :size 16)
      doom-symbol-font (font-spec :family "JuliaMono")
      doom-emoji-font (font-spec :family "Noto Color Emoji")
      doom-serif-font (font-spec :family "IBM Plex Mono" :size 22 :weight 'light))

;; Move custom file
(setq-default custom-file (expand-file-name ".custom.el" doom-user-dir))
(when (file-exists-p custom-file)
  (load custom-file))

;; Window Title
(setq frame-title-format
      '(""
        (:eval
         (if (string-match-p (regexp-quote (or (bound-and-true-p org-roam-directory) "\u0000"))
                             (or buffer-file-name ""))
             (replace-regexp-in-string
              ".*/[0-9]*-?" "☰ "
              (subst-char-in-string ?_ ?\s buffer-file-name))
           "%b"))
        (:eval
         (when-let ((project-name (and (featurep 'projectile) (projectile-project-name))))
           (unless (string= "-" project-name)
             (format (if (buffer-modified-p)  " ◉ %s" "  ●  %s") project-name))))))

;; Window Movement Bindings
(map! :map evil-window-map
      "<left>"     #'evil-window-left
      "<down>"     #'evil-window-down
      "<up>"       #'evil-window-up
      "<right>"    #'evil-window-right
      "C-<left>"       #'+evil/window-move-left
      "C-<down>"       #'+evil/window-move-down
      "C-<up>"         #'+evil/window-move-up
      "C-<right>"      #'+evil/window-move-right)

;;  Avy
(after! avy
  (setq avy-keys '(?n ?e ?i ?s ?t ?r ?i ?a)))

;; Which-key
(setq which-key-idle-delay 0.5
      which-key-allow-multiple-replacements t)
(after! which-key
  (pushnew!
   which-key-replacement-alist
   '(("" . "\\`+?evil[-:]?\\(?:a-\\)?\\(.*\\)") . (nil . "◂\\1"))
   '(("\\`g s" . "\\`evilem--?motion-\\(.*\\)") . (nil . "◃\\1"))))

;; Perspective mode
(after! persp-mode
  (setq persp-emacsclient-init-frame-behaviour-override "main"))

;; Abbrev mode
(setq-default abbrev-mode t)
(setq abbrev-file-name (expand-file-name "abbrev.el" doom-user-dir))
(setq save-abbrevs nil)

;; Evil mode
(after! evil
  (setq evil-move-cursor-back nil
        evil-kill-on-visual-paste nil))

;; Smerg
(defun smerge-repeatedly ()
  "Perform smerge actions again and again"
  (interactive)
  (smerge-mode 1)
  (smerge-transient))

(after! transient
  (transient-define-prefix smerge-transient ()
    [["Move"
      ("n" "next" (lambda () (interactive) (ignore-errors (smerge-next)) (smerge-repeatedly)))
      ("p" "previous" (lambda () (interactive) (ignore-errors (smerge-prev)) (smerge-repeatedly)))]
     ["Keep"
      ("b" "base" (lambda () (interactive) (ignore-errors (smerge-keep-base)) (smerge-repeatedly)))
      ("u" "upper" (lambda () (interactive) (ignore-errors (smerge-keep-upper)) (smerge-repeatedly)))
      ("l" "lower" (lambda () (interactive) (ignore-errors (smerge-keep-lower)) (smerge-repeatedly)))
      ("a" "all" (lambda () (interactive) (ignore-errors (smerge-keep-all)) (smerge-repeatedly)))
      ("RET" "current" (lambda () (interactive) (ignore-errors (smerge-keep-current)) (smerge-repeatedly)))]
     ["Diff"
      ("<" "upper/base" (lambda () (interactive) (ignore-errors (smerge-diff-base-upper)) (smerge-repeatedly)))
      ("=" "upper/lower" (lambda () (interactive) (ignore-errors (smerge-diff-upper-lower)) (smerge-repeatedly)))
      (">" "base/lower" (lambda () (interactive) (ignore-errors (smerge-diff-base-lower)) (smerge-repeatedly)))
      ("R" "refine" (lambda () (interactive) (ignore-errors (smerge-refine)) (smerge-repeatedly)))
      ("E" "ediff" (lambda () (interactive) (ignore-errors (smerge-ediff)) (smerge-repeatedly)))]
     ["Other"
      ("c" "combine" (lambda () (interactive) (ignore-errors (smerge-combine-with-next)) (smerge-repeatedly)))
      ("r" "resolve" (lambda () (interactive) (ignore-errors (smerge-resolve)) (smerge-repeatedly)))
      ("k" "kill current" (lambda () (interactive) (ignore-errors (smerge-kill-current)) (smerge-repeatedly)))
      ("q" "quit" (lambda () (interactive) (smerge-auto-leave)))]]))

;; Corfu
(after! corfu
  (setq tab-always-indent t
        corfu-auto-delay 0.5))

;; Tramp
(after! tramp
  (setenv "SHELL" "/bin/bash")
  (setq tramp-shell-prompt-pattern "\\(?:^\\|\n\\|\x0d\\)[^]#$%>\n]*#?[]#$%>] *\\(\e\\[[0-9;]*[a-zA-Z] *\\)*"))

;; String inflection
(use-package! string-inflection
  :commands (string-inflection-all-cycle
             string-inflection-toggle
             string-inflection-camelcase
             string-inflection-lower-camelcase
             string-inflection-kebab-case
             string-inflection-underscore
             string-inflection-capital-underscore
             string-inflection-upcase)
  :init
  (map! :leader :prefix ("c~" . "naming convention")
        :desc "cycle" "~" #'string-inflection-all-cycle
        :desc "toggle" "t" #'string-inflection-toggle
        :desc "CamelCase" "c" #'string-inflection-camelcase
        :desc "downCase" "d" #'string-inflection-lower-camelcase
        :desc "kebab-case" "k" #'string-inflection-kebab-case
        :desc "under_score" "_" #'string-inflection-underscore
        :desc "Upper_Score" "u" #'string-inflection-capital-underscore
        :desc "UP_CASE" "U" #'string-inflection-upcase)
  (after! evil
    (evil-define-operator evil-operator-string-inflection (beg end _type)
      "Define a new evil operator that cycles symbol casing."
      :move-point nil
      (interactive "<R>")
      (string-inflection-all-cycle)
      (setq evil-repeat-info '([?g ?~])))
    (define-key evil-normal-state-map (kbd "g~") 'evil-operator-string-inflection)))

;; Info colors
(use-package! info-colors
  :commands (info-colors-fontify-node))

(add-hook 'Info-selection-hook 'info-colors-fontify-node)

;; Mixed pitch
(defvar mixed-pitch-modes '(org-mode LaTeX-mode markdown-mode gfm-mode Info-mode)
  "Modes that `mixed-pitch-mode' should be enabled in, but only after UI initialisation.")

(defun init-mixed-pitch-h ()
  "Hook `mixed-pitch-mode' into each mode in `mixed-pitch-modes'.
Also immediately enables `mixed-pitch-modes' if currently in one of the modes."
  (when (memq major-mode mixed-pitch-modes)
    (mixed-pitch-mode 1))
  (dolist (hook mixed-pitch-modes)
    (add-hook (intern (concat (symbol-name hook) "-hook")) #'mixed-pitch-mode)))

(add-hook 'doom-init-ui-hook #'init-mixed-pitch-h)

(autoload #'mixed-pitch-serif-mode "mixed-pitch"
  "Change the default face of the current buffer to a serifed variable pitch, while keeping some faces fixed pitch." t)

(setq! variable-pitch-serif-font (font-spec :family "Alegreya" :size 24))

(after! mixed-pitch
  (setq mixed-pitch-set-height t)
  (set-face-attribute 'variable-pitch-serif nil :font variable-pitch-serif-font)
  (defun mixed-pitch-serif-mode (&optional arg)
    "Change the default face of the current buffer to a serifed variable pitch, while keeping some faces fixed pitch."
    (interactive)
    (let ((mixed-pitch-face 'variable-pitch-serif))
      (mixed-pitch-mode (or arg 'toggle)))))

(defface variable-pitch-serif
  '((t (:family "serif")))
  "A variable-pitch face with serifs."
  :group 'basic-faces)

(defcustom variable-pitch-serif-font (font-spec :family "serif")
  "The font face used for `variable-pitch-serif'."
  :group 'basic-faces
  :type '(restricted-sexp :tag "font-spec" :match-alternatives (fontp))
  :set (lambda (symbol value)
         (set-face-attribute 'variable-pitch-serif nil :font value)
         (set-default-toplevel-value symbol value)))

;;  Marginalia
(after! marginalia
  (setq marginalia-censor-variables nil)

  (defadvice! +marginalia--anotate-local-file-colorful (cand)
    "Just a more colourful version of `marginalia--anotate-local-file'."
    :override #'marginalia--annotate-local-file
    (when-let (attrs (file-attributes (substitute-in-file-name
                                       (marginalia--full-candidate cand))
                                      'integer))
      (marginalia--fields
       ((marginalia--file-owner attrs)
        :width 12 :face 'marginalia-file-owner)
       ((marginalia--file-modes attrs))
       ((+marginalia-file-size-colorful (file-attribute-size attrs))
        :width 7)
       ((+marginalia--time-colorful (file-attribute-modification-time attrs))
        :width 12))))

  (defun +marginalia--time-colorful (time)
    (let* ((seconds (float-time (time-subtract (current-time) time)))
           (color (doom-blend
                   (face-attribute 'marginalia-date :foreground nil t)
                   (face-attribute 'marginalia-documentation :foreground nil t)
                   (/ 1.0 (log (+ 3 (/ (+ 1 seconds) 345600.0)))))))
      ;; 1 - log(3 + 1/(days + 1)) % grey
      (propertize (marginalia--time time) 'face (list :foreground color))))

  (defun +marginalia-file-size-colorful (size)
    (let* ((size-index (/ (log (+ 1 size)) 7.0))
           (color (if (< size-index 10000000) ; 10m
                      (doom-blend 'orange 'green size-index)
                    (doom-blend 'red 'orange (- size-index 1)))))
      (propertize (file-size-human-readable size) 'face (list :foreground color)))))

;; Writeroom
(setq +zen-text-scale 0.8)

(defvar +zen-serif-p t
  "Whether to use a serifed font with `mixed-pitch-mode'.")

(defvar +zen-org-starhide t
  "The value `org-modern-hide-stars' is set to.")

(after! writeroom-mode
  (defvar-local +zen--original-org-indent-mode-p nil)
  (defvar-local +zen--original-mixed-pitch-mode-p nil)
  (defun +zen-enable-mixed-pitch-mode-h ()
    "Enable `mixed-pitch-mode' when in `+zen-mixed-pitch-modes'."
    (when (apply #'derived-mode-p +zen-mixed-pitch-modes)
      (if writeroom-mode
          (progn
            (setq +zen--original-mixed-pitch-mode-p mixed-pitch-mode)
            (funcall (if +zen-serif-p #'mixed-pitch-serif-mode #'mixed-pitch-mode) 1))
        (funcall #'mixed-pitch-mode (if +zen--original-mixed-pitch-mode-p 1 -1)))))
  (defun +zen-prose-org-h ()
    "Reformat the current Org buffer appearance for prose."
    (when (eq major-mode 'org-mode)
      (setq display-line-numbers nil
            visual-fill-column-width 60
            org-adapt-indentation nil)
      (when (featurep 'org-modern)
        (setq-local org-modern-star '("🙘" "🙙" "🙚" "🙛")
                    ;; org-modern-star '("🙐" "🙑" "🙒" "🙓" "🙔" "🙕" "🙖" "🙗")
                    org-modern-hide-stars +zen-org-starhide)
        (org-modern-mode -1)
        (org-modern-mode 1))
      (setq
       +zen--original-org-indent-mode-p org-indent-mode)
      (org-indent-mode -1)))
  (defun +zen-nonprose-org-h ()
    "Reverse the effect of `+zen-prose-org'."
    (when (eq major-mode 'org-mode)
      (when (bound-and-true-p org-modern-mode)
        (org-modern-mode -1)
        (org-modern-mode 1))
      (when +zen--original-org-indent-mode-p (org-indent-mode 1))))
  (pushnew! writeroom--local-variables
            'display-line-numbers
            'visual-fill-column-width
            'org-adapt-indentation
            'org-modern-mode
            'org-modern-star
            'org-modern-hide-stars)
  (add-hook 'writeroom-mode-enable-hook #'+zen-prose-org-h)
  (add-hook 'writeroom-mode-disable-hook #'+zen-nonprose-org-h))

;; Visual fill column
(defun +visual-fill-column--window-max-text-width--fixed (&optional window)
  "Return the maximum possible text width of WINDOW.
The maximum possible text width is the width of the current text
area plus the margins, but excluding the fringes, scroll bar, and
right divider.  WINDOW defaults to the selected window.  The
return value is scaled to account for `text-scale-mode-amount'
and `text-scale-mode-step'."
  (or window (setq window (selected-window)))
  (let* ((margins (window-margins window))
         (buffer (window-buffer window))
         (scale (if (and visual-fill-column-adjust-for-text-scale
                         (boundp 'text-scale-mode-step)
                         (boundp 'text-scale-mode-amount))
                    (with-current-buffer buffer
                      (expt text-scale-mode-step
                            text-scale-mode-amount))
                  1.0))
         (remap-scale
          (if (>= emacs-major-version 29)
              (/ (window-width window 'remap) (float (window-width window)))
            1.0)))
    (truncate (/ (+ (window-width window (and (>= emacs-major-version 29) 'remap))
                    (* (or (car margins) 0) remap-scale)
                    (* (or (cdr margins) 0) remap-scale))
                 (float scale)))))

(advice-add 'visual-fill-column--window-max-text-width
            :override #'+visual-fill-column--window-max-text-width--fixed)

(defun +visual-fill-column--set-margins--fixed (window)
  "Set window margins for WINDOW."
  ;; Calculate left & right margins.
  (let* ((total-width (visual-fill-column--window-max-text-width window))
         (remap-scale
          (if (>= emacs-major-version 29)
              (/ (window-width window 'remap) (float (window-width window)))
            1.0))
         (width (or visual-fill-column-width
                    fill-column))
         (margins (if (< (- total-width width) 0) ; margins must be >= 0
                      0
                    (round (/ (- total-width width) remap-scale))))
         (left (if visual-fill-column-center-text
                   (/ margins 2)
                 0))
         (right (- margins left)))

    (if visual-fill-column-extra-text-width
        (let ((add-width (visual-fill-column--add-extra-width left right visual-fill-column-extra-text-width)))
          (setq left (car add-width)
                right (cdr add-width))))

    ;; put an explicitly R2L buffer on the right side of the window
    (when (and (eq bidi-paragraph-direction 'right-to-left)
               (= left 0))
      (setq left right)
      (setq right 0))

    (set-window-margins window left right)))

(advice-add 'visual-fill-column--set-margins
            :override #'+visual-fill-column--set-margins--fixed)

;; ANSI Colors
(after! text-mode
  (add-hook! 'text-mode-hook
    (unless (derived-mode-p 'org-mode)
      ;; Apply ANSI color codes
      (with-silent-modifications
        (ansi-color-apply-on-region (point-min) (point-max) t)))))

;; Margin when line numbers disabled
(defvar +text-mode-left-margin-width 1
  "The `left-margin-width' to be used in `text-mode' buffers.")

(defun +setup-text-mode-left-margin ()
  (when (and (derived-mode-p 'text-mode)
             (not (and (bound-and-true-p visual-fill-column-mode)
                       visual-fill-column-center-text))
             (eq (current-buffer) ; Check current buffer is active.
                 (window-buffer (frame-selected-window))))
    (setq left-margin-width (if display-line-numbers
                                0 +text-mode-left-margin-width))
    (set-window-buffer (get-buffer-window (current-buffer))
                       (current-buffer))))

(add-hook 'window-configuration-change-hook #'+setup-text-mode-left-margin)
(add-hook 'display-line-numbers-mode-hook #'+setup-text-mode-left-margin)
(add-hook 'text-mode-hook #'+setup-text-mode-left-margin)

;; Denote
(use-package! denote
  :hook
  ((text-mode . denote-fontify-links-mode-maybe)
   (dired-mode . denote-dired-mode))
  :init
  (setq denote-directory (expand-file-name "~/Documents/notes"))
  :config
  ;; (add-hook 'denote-mode-hook #'doom-mark-buffer-as-real-h)
  ;; start filtering immediately
  (map! :leader
        (:prefix-map ("n" . "notes")
                     "n" #'denote
                     "N" #'denote-type
                     "o" #'denote-sort-dired
                     "r" #'denote-rename-file
                     "f" #'consult-denote-find
                     "g" #'consult-denote-grep)
        :map text-mode-map
        (:prefix-map ("n". "notes")
                     "i" #'denote-link
                     "I" #'denote-add-links
                     "b" #'denote-backlinks
                     "R" #'denote-rename-file-using-front-matter))
  (consult-denote-mode 1))

;; Org appear
(use-package! org-appear
  :hook (org-mode . org-appear-mode)
  :config
  (setq org-appear-autoemphasis t
        org-appear-autosubmarkers t
        org-appear-autolinks nil)
  ;; for proper first-time setup, `org-appear--set-elements'
  ;; needs to be run after other hooks have acted.
  (run-at-time nil nil #'org-appear--set-elements))

;; Org HTTP requests
(use-package! ob-http
  :commands org-babel-execute:http)

;; Org mode
(defun +org--expand-file-name (filename)
  (expand-file-name filename org-directory))

(defun +org--inbox-file () (+org--expand-file-name "inbox.org"))
(defun +org--todo-file () (+org--expand-file-name "todo.org"))
(defun +org--notes-file () (+org--expand-file-name "notes.org"))
(defun +org--diary-file () (+org--expand-file-name "diary.org"))
(defun +org--calendar-directory () (+org--expand-file-name "calendar/"))
(defun +org--templates-directory () (+org--expand-file-name "templates/"))
(defun +org--attachment-directory () (+org--expand-file-name "attachments/"))

(setq org-directory (expand-file-name "~/Documents/org/")
      org-agenda-files
      (list (+org--inbox-file) (+org--todo-file) (+org--notes-file) (+org--calendar-directory))

      org-refile-targets
      `((nil . (:maxlevel . 3))
        (,(+org--todo-file) . (:maxlevel . 2))
        (,(+org--notes-file) . (:maxlevel . 3)))

      org-capture-templates
      `(("t" "Todo" entry (file ,(+org--inbox-file)) "* TODO %?")
        ("n" "Quick Note" entry (file ,(+org--notes-file)) "* %?")
        ("N" "Note" plain
         (file denote-last-path)
         #'denote-org-capture
         :no-save t
         :immediate-finish nil
         :kill-buffer t
         :jump-to-captured t)
        ("p" "Project" entry (file+headline ,(+org--todo-file) "Projects")
         (file ,(expand-file-name "project.org" (+org--templates-directory))))
        ("a" "Area" entry (file+headline ,(+org--todo-file) "Areas")
         (file ,(expand-file-name "project.org" (+org--templates-directory))))
        ("r" "Resource" entry (file+headline ,(+org--todo-file) "Resources")
         (file ,(expand-file-name "project.org" (+org--templates-directory))))))

;; Markdown
(add-hook! (gfm-mode markdown-mode) #'visual-line-mode #'turn-off-auto-fill)

;; Claude
;; (use-package! claude-shell
;;   :config
;;   (setq! claude-shell-api-token ""))

;;; $DOOMDIR/config.el ends here
