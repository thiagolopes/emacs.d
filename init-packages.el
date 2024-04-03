;;; init-packages.el -- init file only with use-package  -*- lexical-binding: t; -*-
;;; Commentaryp:
;;;  this package will run after early-init.el
;;; Code:
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
(setq vc-follow-symlinks 'ask) ; restore default
(setq straight-use-package-by-default t)
(setq straight-cache-autoloads t)
(setq straight-vc-git-default-clone-depth 1)
(setq straight-check-for-modifications '(find-when-checking))
(setq package-enable-at-startup nil)
(setq vc-follow-symlinks t)

;; setup use-package
(require 'straight-x)
(straight-use-package 'use-package)
(require 'use-package)
(setq use-package-verbose t)
(setq use-package-compute-statistics nil)

;; packages
(use-package all-the-icons)
(use-package all-the-icons-dired :hook (dired-mode . all-the-icons-dired-mode))
(use-package better-defaults)
(use-package cmake-mode)
(use-package doom-themes)
(use-package gcmh :config (gcmh-mode 1))
(use-package git-link)
(use-package git-timemachine)
(use-package goto-last-change :bind ("C-<dead-acute>" . goto-last-change))
(use-package i3wm-config-mode)
(use-package lua-mode)
(use-package markdown-mode)
(use-package minions :init (minions-mode))
(use-package page-break-lines :config (global-page-break-lines-mode))
(use-package pdf-tools :defer 1)
(use-package prescient :config (prescient-persist-mode))
(use-package realgud)
(use-package solarized-theme :custom (solarized-use-less-bold t))
(use-package sudo-edit)
(use-package super-save :config (super-save-mode t))
(use-package transpose-frame)
(use-package web-mode)
(use-package yaml-mode)

(use-package ctrlf
  :config (ctrlf-mode t)
  :custom
  (ctrlf-auto-recenter t)
  (ctrlf-alternate-search-style 'literal))

(use-package virtualenvwrapper
  :config (venv-initialize-eshell)
  (add-hook 'venv-postactivate-hook
            (lambda () (shell-command "pip install 'python-lsp-server[all]' nose flake8 jedi isort pylint")
              (kill-buffer "*Shell Command Output*"))))

(use-package no-littering
  :custom
  (auto-save-file-name-transforms
   `((".*" ,(no-littering-expand-var-file-name "auto-save/") t))))

(use-package which-key
  :custom
  (which-key-allow-evil-operators t)
  (which-key-show-remaining-keys t)
  (which-key-sort-order 'which-key-prefix-then-key-order)
  :config
  (which-key-mode t)
  (which-key-setup-minibuffer)
  (set-face-attribute
   'which-key-local-map-description-face nil :weight 'bold))

(use-package undo-tree
  :init
  (global-undo-tree-mode)
  :custom
  (undo-tree-visualizer-diff t)
  (undo-tree-auto-save-history t)
  (undo-tree-history-directory-alist `(("." . ,(concat user-emacs-directory "cache/fu/undo-tree-hist/"))))
  (undo-tree-enable-undo-in-region t)
  ;; Increase undo limits to avoid emacs prematurely truncating the undo
  ;; history and corrupting the tree. This is larger than the undo-fu
  ;; defaults because undo-tree trees consume exponentially more space,
  ;; and then some when `undo-tree-enable-undo-in-region' is involved. See
  ;; syl20bnr/spacemacs#12110
  (undo-limit 800000)            ; 800kb (default is 160kb)
  (undo-strong-limit 12000000)   ; 12mb  (default is 240kb)
  (ndo-outer-limit 128000000)) ; 128mb (default is 24mb))

(use-package unicode-fonts
  :after persistent-soft
  :config
  (unicode-fonts-setup))

(use-package mixed-pitch
  :custom
  (mixed-pitch-set-height t))

;; A more complex, more lazy-loaded config
(use-package solaire-mode
  :hook
  ;; Ensure solaire-mode is running in all solaire-mode buffers
  (change-major-mode . turn-on-solaire-mode)
  ;; ...if you use auto-revert-mode, this prevents solaire-mode from turning
  ;; itself off every time Emacs reverts the file
  (after-revert . turn-on-solaire-mode)
  ;; To enable solaire-mode unconditionally for certain modes:
  (ediff-prepare-buffer . solaire-mode)
  :custom
  (solaire-mode-auto-swap-bg t)
  :config
  (solaire-global-mode +1))

(use-package info-colors
  :config
  (add-hook 'Info-selection-hook 'info-colors-fontify-node))

(use-package orderless
  :custom
  (orderless-component-separator "[ &]")
  (completion-styles '(orderless flex))
  (completion-category-overrides '((eglot (styles . (orderless flex))))))

(use-package expand-region
  :bind ("M-@" . er/expand-region))

(use-package smartparens
  :bind
  ("C-)" . sp-forward-slurp-sexp)
  ("C-(" . sp-forward-barf-sexp))

(use-package cider
  :custom
  (nrepl-hide-special-buffers t)
  (nrepl-log-messages nil)
  (cider-font-lock-dynamically '(macro core function var deprecated))
  (cider-overlays-use-font-lock t)
  (cider-prompt-for-symbol nil)
  (cider-inject-dependencies-at-jack-in nil)
  (cider-repl-history-display-duplicates nil)
  (cider-repl-history-display-style 'one-line)
  (cider-repl-history-file (concat user-emacs-directory "cache/cider-repl-history"))
  (cider-repl-history-highlight-current-entry t)
  (cider-repl-history-quit-action 'delete-and-restore)
  (cider-repl-history-highlight-inserted-item t)
  (cider-repl-history-size 1000)
  (cider-repl-result-prefix ";; => ")
  (cider-repl-print-length 100)
  (cider-repl-use-clojure-font-lock t)
  (cider-repl-use-pretty-printing t)
  (cider-repl-wrap-history nil)
  (cider-stacktrace-default-filters '(tooling dup))
  (cider-repl-display-help-banner nil)
  (ider-repl-pop-to-buffer-on-connect 'display-only))

(use-package hl-todo
  :hook (prog-mode . hl-todo-mode)
  :hook (org-mode  . hl-todo-mode)
  :hook (yaml-mode . hl-todo-mode)
  :custom
  (hl-todo-highlight-punctuation ":")
  (hl-todo-keyword-faces
   '(("TODO" warning bold)
     ("FIXME" error bold)
     ("REVIEW" font-lock-keyword-face bold)
     ("HACK" font-lock-constant-face bold)
     ("DEPRECATED" font-lock-doc-face bold)
     ("NOTE" success bold)
     ("BUG" error bold)
     ("XXX" font-lock-constant-face bold))))

(use-package multiple-cursors
  :config
  (global-set-key (kbd "C->") 'mc/mark-next-like-this)
  (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
  (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this))

(use-package exec-path-from-shell
  :config
  (exec-path-from-shell-initialize))

(use-package projectile
  :custom
  (projectile-project-search-path '(("~/dev/" . 1) ("~/.emacs.d/" . 1)))
  (projectile-globally-ignored-files '(".DS_Store" "TAGS")
                                     projectile-globally-ignored-file-suffixes '(".elc" ".pyc" ".o")
                                     projectile-kill-buffers-filter 'kill-only-files)
  :init
  (global-set-key [remap evil-jump-to-tag] #'projectile-find-tag)
  (global-set-key [remap find-tag]         #'projectile-find-tag))

(use-package winner
  :preface (defvar winner-dont-bind-my-keys t) ; I'll bind keys myself
  :hook (dashboard-setup-startup-hook . winner-mode)
  :config
  (winner-mode 1)
  (appendq! winner-boring-buffers
            '("*Compile-Log*" "*inferior-lisp*" "*Fuzzy Completions*"
              "*Apropos*" "*Help*" "*cvs*" "*Buffer List*" "*Ibuffer*"
              "*esh command on file*")))

(use-package paren
  :hook (dashboard-setup-startup-hook . show-paren-mode)
  :custom
  (show-paren-delay 0.1)
  (show-paren-highlight-openparen t)
  (show-paren-when-point-inside-paren t)
  (show-paren-when-point-in-periphery t))

(use-package rainbow-delimiters
  :bind
  ("<f8>" . rainbow-delimiters-mode)
  ;; :config
  ;; (add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
  :custom
  (rainbow-delimiters-max-face-count 4))

(use-package undo-fu-session
  :custom
  (undo-fu-session-directory (concat user-emacs-directory "cache/fu/undo-fu-session/"))
  (undo-fu-session-incompatible-files '("\\.gpg$" "/COMMIT_EDITMSG\\'" "/git-rebase-todo\\'"))
  :config
  (undo-fu-session-global-mode t)
  (when (executable-find "zstd")
    ;; There are other algorithms available, but zstd is the fastest, and speed
    ;; is our priority within Emacs
    (setq-default undo-fu-session-compression 'zst)))

(use-package ibuffer-projectile
  ;; Group ibuffer's list by project root
  :hook (ibuffer . ibuffer-projectile-set-filter-groups))

(use-package magit
  :custom
  (magit-auto-revert-mode nil)  ; we do this ourselves further down
  (transient-default-level 5)
  (magit-diff-refine-hunk t) ; show granular diffs in selected hunk
  ;; Don't autosave repo buffers. This is too magical, and saving can
  ;; trigger a bunch of unwanted side-effects, like save hooks and
  ;; formatters. Trust the user to know what they're doing.
  (magit-save-repository-buffers nil)
  ;; Don't display parent/related refs in commit buffers; they are rarely
  ;; helpful and only add to runtime costs.
  (magit-revision-insert-related-refs nil)
  (transient-levels-file  (concat user-emacs-directory "transient/levels"))
  (transient-values-file  (concat user-emacs-directory "transient/values"))
  (transient-history-file (concat user-emacs-directory "transient/history"))
  :config
  (add-hook 'magit-process-mode-hook #'goto-address-mode))

(use-package drag-stuff
  :bind
  (("<M-up>" . drag-stuff-up)
   ("<M-down>" . drag-stuff-down)
   ("<M-left>" . drag-stuff-left)
   ("<M-right>". drag-stuff-right)))

(use-package dumb-jump
  :init
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate)
  :custom
  (dumb-jump-default-project (concat user-emacs-directory "cache/jump"))
  (dumb-jump-prefer-searcher 'ag)
  (dumb-jump-aggressive nil)
  (dumb-jump-selector 'ivy)
  :config
  (add-hook 'dumb-jump-after-jump-hook #'better-jumper-set-jump))

(use-package marginalia
  :custom
  (marginalia-align 'left)
  :init
  (marginalia-mode))

(use-package popwin
  :config
  (popwin-mode t))

(use-package nvm
  :config
  (when (file-exists-p "~/.nvmrc")
    (nvm-use-for)))

(use-package helpful
  :bind
  (("C-h f" . helpful-callable)
   ("C-h v" . helpful-variable)
   ("C-h k" . helpful-key)
   ("C-h x" . helpful-command)
   ("C-c C-d" . help-at-point)
   ("C-h F" . helpful-function))
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable))

(use-package iedit
  :config
  (require 'iedit))

(use-package ace-popup-menu
  :config
  (ace-popup-menu-mode t))

(use-package pulsar
  :custom
  (pulsar-pulse t)
  :config
  (defun pulse-line (&rest _)
    (pulsar-pulse-line))
  (dolist (command '(scroll-up-command
                     scroll-down-command
                     recenter-top-bottom
                     other-window
                     ace-window))
    (advice-add command :after #'pulse-line)))

(use-package volatile-highlights
  :config
  (volatile-highlights-mode t))

(use-package buffer-move
  :custom
  (buffer-move-behavior 'move)
  :bind
  (("<C-S-up>" . buf-move-up)
   ("<C-S-down>" . buf-move-down)
   ("<C-S-left>" . buf-move-left)
   ("<C-S-right>" . buf-move-right)))

(use-package dashboard
  :custom
  (dashboard-set-navigator t)
  (dashboard-projects-backend 'projectile)
  (dashboard-show-shortcuts t)
  (dashboard-items '((recents  . 15)
                     (projects . 10)))
  (dashboard-center-content t)
  :config
  (if (display-graphic-p)
      (setq dashboard-startup-banner 'official)
      (setq dashboard-startup-banner 'nil))
  (dashboard-setup-startup-hook))

(use-package savehist
  :custom
  (history-length 25)
  :config
  (savehist-mode))

(use-package clean-kill-ring
  :config (clean-kill-ring-mode))

(use-package vertico
  :custom
  (vertico-resize nil)
  (vertico-count 20)
  (vertico-cycle nil)
  :config
  (setq completion-in-region-function
      (lambda (&rest args)
        (apply (if vertico-mode
                   #'consult-completion-in-region
                 #'completion--in-region)
               args)))
  (ido-mode -1)
  (vertico-mode))

(use-package vertico-prescient
  :after vertico
  :config (vertico-prescient-mode t))

(use-package emmet-mode
  :after web-mode
  :hook
  (web-mode . emmet-mode))

(use-package mwim
  :config
  (global-set-key (kbd "C-a") 'mwim-beginning)
  (global-set-key (kbd "C-e") 'mwim-end))

(use-package rainbow-mode
  :hook
  (prog-mode . rainbow-mode))

(use-package bufler
  :straight (bufler :fetcher github :repo "alphapapa/bufler.el"
                    :files (:defaults (:exclude "helm-bufler.el")))
  :bind (("C-x C-b" . bufler)))

(use-package fancy-compilation
  :custom
  (fancy-compilation-override-colors nil)
  :config
  (fancy-compilation-mode))

(use-package ace-window
  :bind
  ("M-o" . ace-window))

(use-package dired-sidebar
  :bind (("<f9>" . dired-sidebar-toggle-sidebar))
  :init
  (add-hook 'dired-sidebar-mode-hook
            (lambda ()
              (unless (file-remote-p default-directory)
                (auto-revert-mode))))
  :config
  (push 'toggle-window-split dired-sidebar-toggle-hidden-commands)
  (push 'rotate-windows dired-sidebar-toggle-hidden-commands)
  :custom
  (dired-sidebar-use-custom-modeline nil)
  (dired-sidebar-subtree-line-prefix "__")
  (dired-sidebar-should-follow-file t)
  (dired-sidebar-refresh-on-project-switch t)
  ;; (dired-sidebar-theme 'icons)
  (dired-sidebar-theme 'vscode)
  (dired-sidebar-use-custom-font t))

(use-package mode-line-bell
  :config
  (mode-line-bell-mode t))

(use-package sideline
  :hook (flycheck-mode . sideline-mode)
  :custom
  (sideline-backends-right '(sideline-flycheck)))

(use-package sideline-flymake
  :hook (flymake-mode . sideline-mode)
  :init
  (setq sideline-flymake-display-mode 'point) ; 'point to show errors only on point
                                              ; 'line to show errors on the current line
  (setq sideline-backends-right '(sideline-flymake)))

(use-package bm
  :demand t
  :custom
  (bm-cycle-all-buffers t)
  :bind (("<insert>" . bm-next)
         ("S-<insert>" . bm-previous)
         ("C-<insert>" . bm-toggle)))

(use-package avy
  :custom
  (avy-background t)
  (avy-single-candidate-jump t)
  :config
  (global-set-key (kbd "M-z") 'avy-goto-word-1))

(use-package eglot
  :custom
  (eglot-sync-connect nil)
  (eglot-events-buffer-size 0)
  (eglot-connect-timeout nil)
  (org-directory "~/org/")
  :config
  (setopt eglot-report-progress nil)
  (fset #'jsonrpc--log-event #'ignore))

(use-package flycheck-eglot
  :after (flycheck eglot)
  :config
  (global-flycheck-eglot-mode 1))

(when (executable-find "emacs-lsp-booster")
  (use-package eglot-booster
    :straight (eglot-booster :fetcher github :repo "https://github.com/jdtsmith/eglot-booster"
                             :files ("eglot-booster.el"))
    :config (eglot-booster-mode)))

(use-package symbol-overlay
  :custom
  (symbol-overlay-idle-time 1.0)
  (symbol-overlay-temp-highlight-single nil)
  :hook
  (prog-mode . symbol-overlay-mode))

(use-package highlight-numbers
  :hook
  (prog-mode . highlight-numbers-mode))

(use-package embark
  :bind
  ("C-." . embark-act)
  :custom
  (prefix-help-command #'embark-prefix-help-command)
  :config
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package all-the-icons-completion
  :after (marginalia all-the-icons)
  :hook (marginalia-mode . all-the-icons-completion-marginalia-setup)
  :init
  (all-the-icons-completion-mode))

(use-package highlight-indent-guides
  :config
  (defun my-highlighter (level responsive display)
    (if (> 1 level)
        nil
      (highlight-indent-guides--highlighter-default level responsive display)))
  (setq highlight-indent-guides-highlighter-function 'my-highlighter)
  (setq highlight-indent-guides-responsive 'top)
  :hook
  (python-mode . highlight-indent-guides-mode))

(use-package xterm-color
  :custom
  (comint-output-filter-functions
   (remove 'ansi-color-process-output comint-output-filter-functions))
  :config
  (add-hook 'shell-mode-hook (lambda ()
                               (font-lock-mode -1)
                               (make-local-variable 'font-lock-function)
                               (setq font-lock-function (lambda (_) nil))
                               (add-hook 'comint-preoutput-filter-functions 'xterm-color-filter nil t))))

(use-package consult
  :hook
  (completion-list-mode . consult-preview-at-point-mode)
  :config
  ;; BEGIN TRAMP settings
  (defun consult-buffer-state-no-tramp ()
    "Buffer state function that doesn't preview Tramp buffers."
    (let ((orig-state (consult--buffer-state))
          (filter (lambda (action cand)
                    (if (and cand
                             (or (eq action 'return)
                                 (let ((buffer (get-buffer cand)))
                                   (and buffer
                                        (not (file-remote-p (buffer-local-value 'default-directory buffer)))))))
                        cand
                      nil))))
      (lambda (action cand)
        (funcall orig-state action (funcall filter action cand)))))
  (setq consult--source-buffer
        (plist-put consult--source-buffer :state #'consult-buffer-state-no-tramp))
  ;; END TRAMP settings
  :bind
  (("C-x 4 b" . consult-buffer-other-window)
   ("C-x 5 b" . consult-buffer-other-frame)
   ("C-x b"   . consult-buffer)
   ("C-M-?"   . consult-find)
   ("M-g i"   . consult-imenu)
   ("M-?"     . consult-ripgrep)
   ("M-g g"   . consult-goto-line)
   ("M-g M-g" . consult-goto-line)
   ("M-y"     . consult-yank-pop)))

(use-package hl-line+
  :config
  (toggle-hl-line-when-idle t))

(use-package org-modern
  :config
  (with-eval-after-load 'org (global-org-modern-mode)))

(use-package treesit-auto
  :custom
  (treesit-auto-install t)
  :config
  (global-treesit-auto-mode))

(use-package electric-operator
  :config
  (add-hook 'python-mode-hook #'electric-operator-mode))

(use-package siege-mode
  :straight (siege-mode :repo "https://github.com/tslilc/siege-mode" :fetcher github)
  :hook
  (prog-mode . siege-mode)
  :config
  (siege-mode t))

(use-package zeal-at-point
  :bind
  (("\C-cd" . zeal-at-point))
  :straight (zeal-at-point :repo "jinzhu/zeal-at-point" :fetcher github
                           :files ("zeal-at-point.el")))

(use-package fontaine
  :config
  (setq fontaine-presets
        '((hack
           :default-family "Hack"
           :line-spacing 1
           :default-weight normal
           :default-height 130
           :bold-weight extrabold
           :fixed-pitch-family "Sans"
           :fixed-pitch-height 1.0)
          (iosevka
           :default-family "Iosevka Comfy"
           :line-spacing 1
           :default-weight normal
           :default-height 130
           :bold-weight extrabold
           :fixed-pitch-family "Iosevka Comfy Duo"
           :fixed-pitch-height 1.0)
          (cascadia
           :default-family "Cascadia Mono"
           :line-spacing 1
           :default-weight semilight
           :default-height 120
           :bold-weight extrabold
           :fixed-pitch-family "Cascadia Mono PL"
           :fixed-pitch-height 1.0)))
  (fontaine-set-preset 'cascadia))

(provide 'init-packages)
;;; init.el ends here
