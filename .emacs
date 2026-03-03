(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("elpa" . "https://elpa.gnu.org/packages/") t)
(package-initialize)

;; --- Tree-sitter grammars (auto-install if missing) ---
(setq treesit-language-source-alist
      '((typescript "https://github.com/tree-sitter/tree-sitter-typescript"
                    "master" "typescript/src")
        (tsx "https://github.com/tree-sitter/tree-sitter-typescript"
             "master" "tsx/src")))

(dolist (lang '(typescript tsx))
  (unless (treesit-language-available-p lang)
    (treesit-install-language-grammar lang)))

;; --- TSX / TypeScript tree-sitter modes ---
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-ts-mode))

(use-package helm
  :ensure t
  :bind (("M-x" . helm-M-x)           ;; M-x replacement
       ("C-x C-f" . helm-find-files) ;; Find files
       ("C-x b" . helm-buffers-list) ;; Switch buffers
       ("C-h a" . helm-apropos)      ;; Help/apropos
       ("M-y" . helm-show-kill-ring) ;; Paste history
       ("C-x C-r" . helm-recentf))   ;; Recent files
  :config
  (helm-mode 1))

(use-package helm
  :ensure t
  :config
  (helm-mode 1)
  (setq helm-split-window-inside-current-window t)
  (setq helm-move-to-line-cycle-in-source t)
  (setq helm-echo-input-in-header-line t)
  (setq helm-autoresize-max-height 40)
  (setq helm-autoresize-min-height 20)
  (helm-autoresize-mode 1))


(setq helm-ff-file-name-history-use-recentf t)  ;; Smart file history
(setq helm-ff-skip-boring-files t)              ;; Hide .DS_Store etc
(setq helm-candidate-number-limit 50)           ;; Performance
(setq helm-completion-style 'emacs)             ;; Works well in terminal

;;; -*- lexical-binding: t -*-
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Disable splash screen
(setq inhibit-startup-message t)
(setq inhibit-startup-echo-area-message t)

;; Start with empty buffer
;;(setq initial-buffer-choice t)
;;(setq initial-scratch-message "")

;; use solarized theme
(use-package solarized-theme
  :ensure t
  :config
  (load-theme 'solarized-dark t))

(global-display-line-numbers-mode 1)

;; delete trailing whitespaces
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(add-hook 'before-save-hook
  (lambda ()
    (save-excursion
      (goto-char (point-max))
      (delete-blank-lines))))

;; ace jump mode
(use-package avy
  :ensure t
  :bind (("C-c j" . avy-goto-char)
         ("C-c l" . avy-goto-line)))

(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c k")
  :hook ((typescript-ts-mode . lsp-deferred)
         (tsx-ts-mode . lsp-deferred))
  :commands lsp lsp-deferred
  :ensure t
  )

(use-package lsp-ui
  :commands lsp-ui-mode
  :ensure t
  )

;; Completion frontend for LSP
(use-package company
  :ensure t
  :hook (lsp-mode . company-mode))

;; Auto-save files every 30 seconds or after 300 characters typed
(setq auto-save-timeout 30)
(setq auto-save-interval 300)
(auto-save-mode 1)

;; Auto-revert files when they change on disk
(global-auto-revert-mode 1)
(setq auto-revert-verbose nil)  ; Suppress messages

(use-package super-save
  :ensure t
  :config
  (super-save-mode +1)
  (setq super-save-auto-save-when-idle t)
  (setq auto-save-default nil))

(use-package projectile
  :ensure t
  :init
  (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("C-c p f" . helm-projectile-find-file)))

(use-package helm-projectile
  :ensure t
  :after helm projectile)

;; Git interface
(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))
