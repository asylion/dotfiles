(require 'package)

(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(use-package zenburn-theme
  :ensure t
  :config
  (load-theme 'zenburn t))

(tool-bar-mode 0)
(scroll-bar-mode 0)
(line-number-mode)
(column-number-mode)
(blink-cursor-mode 0)
(show-paren-mode 1)

(setq confirm-kill-emacs 'y-or-n-p
      backup-directory-alist `((".*" . ,temporary-file-directory))
      auto-save-file-name-transforms `((".*" ,temporary-file-directory t))
      help-window-select t
      inhibit-splash-screen t
      inhibit-startup-message t
      inhibit-startup-echo-area-message t
      initial-scratch-message nil
      initial-major-mode 'text-mode
      frame-resize-pixelwise t
      ring-bell-function 'ignore
      scroll-step 1
      scroll-conservatively 10000
      show-paren-delay 0
      tab-always-indent nil
      use-package-always-ensure t)

(setq-default indent-tabs-mode nil
              tab-width 2)

(fset 'yes-or-no-p 'y-or-n-p)

(use-package diminish)

(use-package bind-key)

(use-package evil
  :demand t
  :bind (("M-k" . evil-window-up)
         ("M-j" . evil-window-down)
         ("M-h" . evil-window-left)
         ("M-l" . evil-window-right)
         (:map evil-normal-state-map
               ("M-." . nil)
               ("j" . evil-next-visual-line)
               ("k" . evil-previous-visual-line)))
  :config
  (evil-set-initial-state 'eshell-mode 'emacs)
  (evil-set-initial-state 'quickrun--mode 'emacs)
  (evil-mode 1))

(use-package evil-commentary
  :diminish evil-commentary-mode
  :config
  (evil-commentary-mode))

(use-package evil-surround
  :config
  (global-evil-surround-mode 1))

(use-package evil-anzu
  :demand t)

(use-package helm
  :demand t
  :diminish helm-mode
  :init
  (setq helm-M-x-fuzzy-match t
        helm-buffers-fuzzy-matching t
        helm-recentf-fuzzy-match t
        helm-imenu-fuzzy-match t
        helm-apropos-fuzzy-match t
        helm-split-window-in-side-p t)
  :bind (("M-x" . helm-M-x)
         ("M-o" . helm-occur)
         ("M-r" . helm-resume)
         ("M-y" . helm-show-kill-ring)
         ("M-i" . helm-semantic-or-imenu)
         ("C-x b" . helm-mini)
         ("C-h a" . helm-apropos)
         ("C-x C-f" . helm-find-files))
  :config
  (helm-mode 1))

(use-package helm-ag
  :defer t)

(use-package helm-projectile
  :demand t
  :bind ("C-x p" . helm-projectile)
  :config
  (helm-projectile-on))

(use-package projectile
  :bind ("C-c p" . projectile-command-map)
  :init
  (setq projectile-sort-order 'recently-active)
  :config
  (projectile-mode))

(use-package magit
  :bind ("C-x g" . magit-status))

(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

(use-package python
  :defer t)

(use-package lsp-mode
  :commands lsp)

(use-package rust-mode
  :hook (rust-mode . lsp))

(use-package cargo
  :hook (rust-mode . cargo-minor-mode))

(use-package cc-mode
  :hook ((c-mode . lsp)
         (c++-mode . lsp))
  :config
  (c-add-style "custom"
               '((c-basic-offset . 2)
                 (indent-tabs-mode . nil)
                 (c-offsets-alist . ((label . 0)
                                     (case-label . +)
                                     (innamespace . 0)
                                     (inline-open . 0)
                                     (arglist-intro . ++)
                                     (statement-cont . ++)
                                     (member-init-intro . ++)
                                     (substatement-open . 0)
                                     (arglist-close . c-lineup-arglist)))))
  (setq c-default-style "custom"))

(use-package cquery)

(use-package haskell-mode
  :hook (haskell-mode . haskell-indentation-mode))

(use-package intero
  :hook (haskell-mode . intero-mode))

(use-package flycheck
  :config
  (global-flycheck-mode))

(use-package flycheck-rust
  :hook (flycheck-mode . flycheck-rust-setup))

(use-package company
  :demand t
  :hook (after-init . global-company-mode)
  :bind (:map company-active-map
         ([tab] . company-complete))
  :config
  (setq company-idle-delay 0
        company-dabbrev-downcase nil
        company-minimum-prefix-length 2
        company-selection-wrap-around t
        company-tooltip-align-annotations t
        company-global-modes '(not org-mode
                                   text-mode
                                   eshell-mode)))

(use-package company-lsp
  :init
  (add-to-list 'company-backends 'company-lsp))

(use-package company-jedi
  :init
  (add-to-list 'company-backends 'company-jedi)
  :bind (:map python-mode-map
              ("M-." . jedi:goto-definition)))

(use-package yasnippet
  :config
  (yas-global-mode 1))

(use-package rainbow-delimiters
  :hook ((emacs-lisp-mode . rainbow-delimiters-mode)
         (clojure-mode . rainbow-delimiters-mode)))

(use-package exec-path-from-shell
  :init
  (setq exec-path-from-shell-arguments '("-l"))
  :config
  (exec-path-from-shell-initialize))

(use-package quickrun
  :bind ("<f5>" . quickrun)
  :config
  (quickrun-add-command "c++11/g++"
    '((:command . "g++")
      (:exec    . ("%c -std=c++11 %o -o %e %s"
                   "%e %a"))
      (:remove  . ("%e")))
    :default "c++")
  (quickrun-add-command "python3"
    '((:command . "python3"))
    :default "python"))

(use-package dumb-jump
  :bind (:map evil-normal-state-map
              ("C-]" . dumb-jump-go)))

(use-package gdb-mi
  :defer t
  :init
  (setq gdb-many-windows t))

(use-package undo-tree
  :diminish undo-tree-mode
  :config
  (global-undo-tree-mode 1))

(use-package elec-pair
  :config
  (electric-pair-mode 1))

(use-package autorevert
  :diminish auto-revert-mode
  :init
  (setq auto-revert-verbose nil)
  :config
  (global-auto-revert-mode 1))

(use-package hl-line
  :hook (prog-mode . hl-line-mode))

(use-package git-gutter-fringe
  :demand t
  :diminish git-gutter-mode
  :hook (prog-mode . git-gutter-mode))
