;;; init-font.el --- Font configuration -*- lexical-binding: t -*-

;;; Typeface definitions (fontaine.el)
(use-package fontaine
  :ensure t
  :hook
  (kill-emacs . fontaine-store-latest-preset)
  :bind
  (("C-c C" . fontaine-set-preset)
   ("C-c C" . fontaine-set-face-font))
  :init
  (setq-default text-scale-remap-header-line t)
  (setq x-underline-at-descent-line t
        fontaine-latest-state-file (locate-user-emacs-file "fontaine-latest-state.eld")
        fontaine-presets
        `((small
           :default-height 120)
          (regular
           :default-height 160)
          (large
           :default-height 240)
          (presentation
           :default-weight light
           :default-height 360)
          (t
           :default-family "Iosevka Custom"
           :default-weight regular
           :default-height 160
           :fixed-pitch-family nil
           :fixed-pitch-weight nil
           :fixed-pitch-height 1.0
           :variable-pitch-family "Liberation Serif"
           :variable-pitch-weight nil
           :variable-pitch-height 1.0
           :bold-family nil
           :bold-weight regular
           :italic-family nil
           :italic-slant italic
           :line-spacing nil)))
  ;; :config
  ;; (fontaine-set-preset (or (fontaine-restore-latest-preset) 'regular))
  )

;; Not sure why this doesn't work in the config block...
(fontaine-set-preset (or (fontaine-restore-latest-preset) 'regular))

;;; Ligature support (ligature.el)
(use-package ligature
  :ensure t
  :hook (after-init . global-ligature-mode)
  :config
  (ligature-set-ligatures 't '("www"))
  (ligature-set-ligatures 'eww-mode '("ff" "fi" "ffi"))
  (ligature-set-ligatures 'prog-mode '("|||>" "<|||" "<==>" "<!--" "####" "~~>" "***" "||=" "||>"
                                       ":::" "::=" "=:=" "===" "==>" "=!=" "=>>" "=<<" "=/=" "!=="
                                       "!!." ">=>" ">>=" ">>>" ">>-" ">->" "->>" "-->" "---" "-<<"
                                       "<~~" "<~>" "<*>" "<||" "<|>" "<$>" "<==" "<=>" "<=<" "<->"
                                       "<--" "<-<" "<<=" "<<-" "<<<" "<+>" "</>" "###" "#_(" "..<"
                                       "..." "+++" "/==" "///" "_|_" "www" "&&" "^=" "~~" "~@" "~="
                                       "~>" "~-" "**" "*>" "*/" "||" "|}" "|]" "|=" "|>" "|-" "{|"
                                       "[|" "]#" "::" ":=" ":>" ":<" "$>" "==" "=>" "!=" "!!" ">:"
                                       ">=" ">>" ">-" "-~" "-|" "->" "--" "-<" "<~" "<*" "<|" "<:"
                                       "<$" "<=" "<>" "<-" "<<" "<+" "</" "#{" "#[" "#:" "#=" "#!"
                                       "##" "#(" "#?" "#_" "%%" ".=" ".-" ".." ".?" "+>" "++" "?:"
                                       "?=" "?." "??" ";;" "/*" "/=" "/>" "//" "__" "~~" "(*" "*)"
                                       "\\\\" "://")))

(provide 'init-font)

;;; init-font.el ends here
