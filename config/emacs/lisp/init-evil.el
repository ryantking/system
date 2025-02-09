;;; init-evil.el --- Evil mode-name configuration -*- lexical-binding: t -*-

;;; Vi keybindings (evil.el)
(use-package evil
  :ensure t
  :init
  (setq evil-want-keybinding nil
        evil-undo-system 'undo-redo
        evil-want-C-u-scroll t)
  :config
  (evil-mode 1))

;;; Evil extensions (evil-collection.el)
(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

;;; Evil surround port (evil-surround.el)
(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))

;;; Sniped (evil-snip.el)
(use-package evil-snipe
  :ensure t
  :init
  (setq evil-snipe-scope 'visible)
  :config
  (evil-define-key 'visual evil-snipe-local-mode-map "z" 'evil-snipe-s)
  (evil-define-key 'visual evil-snipe-local-mode-map "Z" 'evil-snipe-S)

  (evil-snipe-mode 1)
  (evil-snipe-override-mode 1))

(provide 'init-evil)

;;; init-evil.el ends here
