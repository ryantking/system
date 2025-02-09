;;; init-keymap.el --- Setup the modal keymap -*- lexical-binding: t -*-

;; Evil mode (evil.el)
(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil
        evil-undo-system 'undo-redo)
  :config
  (evil-mode 1))

;; Evil Collection (evil-collection.el)
(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

;; Evil Surround (evil-surround.el)
(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))

;;; Keybinding cheatcheet (which-key.el)
(use-package which-key
  :ensure t
  :init
  (setq which-key-separator "  "
        which-key-prefix-prefix "... "
        which-key-max-display-columns 3
        which-key-add-column-padding 1
        which-key-max-description-length 40)
  :config
  (which-key-mode 1))

(provide 'init-keymap)

;;; init-keymap.el ends here
