;;; init-packages.el -- init file only with use-package  -*- lexical-binding: t; -*-
;;; Commentaryp:
;;;  this package will run after early-init.el
;;; Code:
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(eval-and-compile
  (require 'use-package)
  (setq use-package-always-ensure t
	use-package-expand-minimally t))



;; load .env shell
(use-package exec-path-from-shell
  :config
  (exec-path-from-shell-initialize))

;; font/theme
(use-package fontaine
  :if (display-graphic-p)
  :config
  (setq fontaine-presets
	'((hack
	   :default-family "Hack"
	   :line-spacing 2
	   :bold-weight extrabold)
	  (iosevka
	   :default-family "Iosevka Comfy"
	   :line-spacing 2)
	  (cascadia
	   :default-family "Cascadia Mono"
	   :line-spacing 3
	   :default-weight semilight)
	  (iosvmata
	   :default-family "Iosvmata"
	   :line-spacing 3)
	  (nrk
	   :default-family "NRK Mono"
	   :line-spacing 1)
	  (pragmasevka
	   :default-family "Pragmasevka"
	   :line-spacing 3
	   :default-weight regular
	   :bold-weight extrabold)))
  (fontaine-set-preset 'iosvmata))
(use-package gruber-darker-theme
  :config
  (disable-theme 'greenized)
  (load-theme 'gruber-darker t))

;; icons
(use-package all-the-icons
  :custom (all-the-icons-scale-factor 0.9))
(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))
(use-package all-the-icons-completion
  :after (marginalia all-the-icons)
  :hook (marginalia-mode . all-the-icons-completion-marginalia-setup)
  :init (all-the-icons-completion-mode))

;; extra modes
(use-package cmake-mode)
(use-package i3wm-config-mode)
(use-package lua-mode)
(use-package markdown-mode)
(use-package pdf-tools :defer t)
(use-package web-mode)
(use-package yaml-mode)
(use-package diminish
  :config (diminish 'completion-preview-mode))

(use-package persist
  :after server)
(use-package persist-state
  :after (persist, server)
  :config (persist-state-mode t))

;; This package automatically calculates and adjusts the default text size for
;; the size and pixel pitch of the display.
(use-package textsize
  :init (textsize-mode t)
  :hook (after-init . textsize-fix-frame)
  :custom (textsize-default-points 15))

;; tooltip and backends
(use-package corfu
  :custom (corfu-separator ?\s)          ;; Orderless field separator
  (corfu-preview-current nil)    ;; Disable current candidate preview
  (corfu-scroll-margin 15)        ;; Use scroll margin
  :init
  (global-corfu-mode)
  (corfu-echo-mode t))
(use-package corfu-terminal
  :if (not (display-graphic-p))
  :config
  (corfu-terminal-mode t))

(use-package cape
  :init
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-elisp-block))
(use-package company
  :disabled
  :bind (:map company-active-map
	      ("<tab>" . company-complete-selection))
  :hook
  (after-init . global-company-mode)
  :custom
  ;; (company-frontends '(company-pseudo-tooltip-frontend
  ;;		       company-echo-metadata-frontend))
  (company-idle-delay nil)
  (company-minimum-prefix-length 1)
  :config
  (define-key company-mode-map (kbd "C-M-i") 'company-complete)
  (define-key company-active-map (kbd "C-M-i") 'company-complete))

;; show vertical lines
(use-package page-break-lines
  :diminish
  :config
  (global-page-break-lines-mode))

;; edit by sudo
(use-package sudo-edit)

;; save on focus loose
(use-package super-save
  :diminish
  :config
  (super-save-mode t))

;; buffer moviments
(use-package transpose-frame)
(use-package buffer-move
  :custom
  (buffer-move-behavior 'move)
  :bind
  (("<C-S-up>" . buf-move-up)
   ("<C-S-down>" . buf-move-down)
   ("<C-S-left>" . buf-move-left)
   ("<C-S-right>" . buf-move-right)))

;; search on file engine
(use-package ctrlf
  :config
  (ctrlf-mode t)
  :custom
  (ctrlf-auto-recenter t)
  (ctrlf-alternate-search-style 'literal))

;; clojure
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

;; ;; python
(use-package pytest)
(use-package virtualenvwrapper
  :config (venv-initialize-eshell))
(use-package electric-operator
  :hook
  (python-mode . electric-operator-mode))

;; ;; organize cache files
(use-package no-littering
  :custom
  (auto-save-file-name-transforms
   `((".*" ,(no-littering-expand-var-file-name "auto-save/") t))))

;; show helper command
(use-package which-key
  :diminish
  :config
  (which-key-mode t))

;; undo tree visualization
(use-package vundo)
(use-package undo-fu-session
  :config
  (undo-fu-session-global-mode t)
    (when (executable-find "zstd")
    ;; There are other algorithms available, but zstd is the fastest, and speed
    ;; is our priority within Emacs
    (setq-default undo-fu-session-compression 'zst)))

;; setup fonts
(use-package unicode-fonts
  :config
  (unicode-fonts-setup))
(use-package mixed-pitch
  :custom
  (mixed-pitch-set-height t))

;; darker buffer where is not about edit text
;; (use-package solaire-mode
;;   :ensure t
;;   :hook
;;   (change-major-mode . turn-on-solaire-mode)
;;   (after-revert . turn-on-solaire-mode)
;;   (ediff-prepare-buffer . solaire-mode)
;;   :custom
;;   (solaire-mode-auto-swap-bg t)
;;   :config
;;   (solaire-global-mode +1))

(use-package expand-region
  :bind
  ("M-@" . er/expand-region))

;; move parens
(use-package smartparens
  :bind
  ("C-)" . sp-forward-slurp-sexp)
  ("C-(" . sp-forward-barf-sexp))

;; show flags
(use-package hl-todo
  :hook (prog-mode . hl-todo-mode)
  :hook (org-mode  . hl-todo-mode)
  :hook (yaml-mode . hl-todo-mode)
  :custom
  (hl-todo-keyword-faces
   '(("TODO" warning bold)
     ("FIXME" error bold)
     ("REVIEW" font-lock-keyword-face bold)
     ("HACK" font-lock-constant-face bold)
     ("DEPRECATED" font-lock-doc-face bold)
     ("NOTE" success bold)
     ("BUG" error bold)
     ("XXX" font-lock-constant-face bold))))

;; more cursor, mass editing
(use-package multiple-cursors
  :bind
  ("C->" . 'mc/mark-next-like-this)
  ("C-<" . 'mc/mark-previous-like-this)
  ("C-c C-<" . 'mc/edit-lines)
  ("C-c C->" . 'mc/mark-all-like-this)
  ("M-<mouse-1>" . mc/add-cursor-on-click))

;; (use-package winner
;;   :preface
;;   (defvar winner-dont-bind-my-keys t) ; I'll bind keys myself
;;   :hook
;;   (dashboard-setup-startup . winner-mode)
;;   :config
;;   (winner-mode 1)
;;   (appendq! winner-boring-buffers
;;	    '("*Compile-Log*" "*inferior-lisp*" "*Fuzzy Completions*"
;;	      "*Apropos*" "*Help*" "*cvs*" "*Buffer List*" "*Ibuffer*"
;;	      "*esh command on file*")))

(use-package rainbow-delimiters
  :bind
  ("<f8>" . rainbow-delimiters-mode)
  ;; :config
  ;; (add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
  :custom
  (rainbow-delimiters-max-face-count 4))

;; UUID
(use-package uuidgen)

;; ;; git!
(use-package git-link)
(use-package git-timemachine)
(use-package magit)

;; move blocks
(use-package drag-stuff
  :bind
  (("<M-up>" . drag-stuff-up)
   ("<M-down>" . drag-stuff-down)
   ("<M-left>" . drag-stuff-left)
   ("<M-right>". drag-stuff-right)))

;; goto reference engine withtou LSP
(use-package dumb-jump
  :init
  :custom
  (dumb-jump-default-project (concat user-emacs-directory "cache/jump"))
  (dumb-jump-prefer-searcher 'rg)
  (dumb-jump-aggressive nil)
  (dumb-jump-selector 'ivy)
  :config
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate)
  (add-hook 'dumb-jump-after-jump-hook #'better-jumper-set-jump))

(use-package popwin
  :custom
  (popwin:popup-window-width 0.4)
  (popwin:popup-window-position 'right)
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

;; edit all references
(use-package iedit
  :config
  (require 'iedit))

;; textual replacement of gui questions
(use-package ace-popup-menu
  :config
  (ace-popup-menu-mode t))

;; pulsar cursor
(use-package pulsar
  :custom
  (pulsar-pulse t)
  :config
  (defun pulse-line (&rest _)
    (pulsar-pulse-line))
  (dolist (command '(scroll-up-command
		     scroll-down-command
		     recenter-top-bottom
		     windmove-right
		     windmove-left
		     windmove-up
		     windmove-down
		     other-window
		     ace-window))
    (advice-add command :after #'pulse-line)))

;; avoid trash in kill ring
(use-package clean-kill-ring
  :config (clean-kill-ring-mode))

;; show usefull information at left on minibuffer
(use-package marginalia
  :custom
  (marginalia-align 'left)
  :init
  (marginalia-mode))

;; better minibuffer
(use-package consult
  :config (setq completion-in-region-function
		(lambda (&rest args)
		  (apply (if vertico-mode
			     #'consult-completion-in-region
			   #'completion--in-region)
			 args)))
  (setq xref-show-xrefs-function #'consult-xref
	xref-show-definitions-function #'consult-xref)
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :bind (("M-y"     . consult-yank-pop)
	 ("C-x b"   . consult-buffer)
	 ("C-c f"   . consult-find)
	 ("C-c i"   . consult-imenu)
	 ("C-c r"   . consult-ripgrep)
	 ("C-c l"   . consult-line-multi)
	 ("M-g g"   . consult-goto-line)
	 ("M-g M-g" . consult-goto-line)
	 :map consult-isearch-history-map
	 ("C-p" #'consult-isearch-forward)
	 ("C-n" #'consult-isearch-backward)))

;; improve icomplete
(use-package orderless
  :custom
  (completion-styles '(orderless flex))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;; minibuffer search candidate
;; (use-package vertico
;;   :disabled
;;   :config
;;   (vertico-mode t))

;; html genereta tags html>body
(use-package emmet-mode
  :after web-mode
  :hook
  (web-mode . emmet-mode))

;; show color hex with background color
(use-package rainbow-mode
  :diminish
  :hook
  (prog-mode . rainbow-mode))

;; (use-package fancy-compilation
;;   :custom
;;   (fancy-compilation-override-colors nil)
;;   :config
;;   (fancy-compilation-mode))

;; move open buffers
(use-package ace-window
  :bind
  ("M-o" . ace-window))

;; Blink mode line
(use-package mode-line-bell
  :config
  (mode-line-bell-mode t))

;; Error ui
;; (use-package flymake)
;; (use-package sideline
;;   :hook (flycheck-mode . sideline-mode)
;;   :custom
;;   (sideline-backends-right '(sideline-flycheck)))
;; (use-package sideline-flymake
;;   :hook (flymake-mode . sideline-mode)
;;   :init
;;   (setq sideline-flymake-display-mode 'point)
;;   (setq sideline-backends-right '(sideline-flymake)))

;; Jump to char
(use-package avy
  :custom
  (avy-background t)
  (avy-single-candidate-jump t)
  :config
  (global-set-key (kbd "M-z") 'avy-goto-word-1))

;; LSP
(use-package eglot
  :preface (defun mp-eglot-eldoc ()
	     (setq eldoc-documentation-strategy
		   'eldoc-documentation-compose-eagerly))
  :hook ((eglot-managed-mode . mp-eglot-eldoc))
  :custom
  (eglot-sync-connect t)
  (eglot-connect-timeout 3)
  (org-directory "~/org/")
  :config
  (setq eglot-ignored-server-capabilities '(:inlayHintProvider))
  (setq eglot-report-progress nil))
;; (when (executable-find "emacs-lsp-booster")
;;   (use-package eglot-booster
;;     :ensure
;;     :quelpa ((eglot-booster :fetcher github :repo "jdtsmith/eglot-booster/" :file "eglot-booster") :upgrade t))
;;     :config (eglot-booster-mode))

;; Overlay symbol!!
(use-package symbol-overlay
  :diminish
  :custom
  (symbol-overlay-idle-time 0.8)
  (symbol-overlay-temp-highlight-single nil)
  :hook
  (prog-mode . symbol-overlay-mode))

;; List of coletions
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

;; (use-package hl-line+
;;   :config
;;   (toggle-hl-line-when-idle t))

;; org mode
(use-package org-modern
  :hook
  (org-mode . org-modern-mode)
  :config
  (with-eval-after-load 'org (global-org-modern-mode)))
(use-package verb
  :config (define-key org-mode-map (kbd "C-c C-r") verb-command-map))

(use-package treesit-auto
  :custom
  (treesit-auto-install t)
  :config
  (global-treesit-auto-mode))

;; libterm terminal
(use-package vterm)
(use-package shell-pop
  :custom
  (shell-pop-shell-type (quote ("ansi-term" "*ansi-term*" (lambda nil (ansi-term shell-pop-term-shell)))))
  (shell-pop-universal-key "<f12>")
  (shell-pop-window-size 30)
  (shell-pop-full-span t)
  (shell-pop-window-position "bottom")
  (shell-pop-restore-window-configuration t))

(use-package doom-modeline
  :disabled
  :custom
  (doom-modeline-major-mode-color-icon nil)
  (doom-modeline-buffer-file-name-style 'truncate-upto-root)
  (doom-modeline-buffer-modification-icon t)
  (doom-modeline-time-icon t)
  (doom-modeline-icon t)
  (doom-modeline-highlight-modified-buffer-name t)
  (doom-modeline-position-column-line-format '("(%l:%c)"))
  (doom-modeline-enable-word-count t)
  (doom-modeline-height 28)
  (doom-modeline-buffer-encoding nil)
  :init
  (doom-modeline-mode 1))

(use-package server
  :config
  (unless (server-running-p)
    (server-start)))

(use-package breadcrumb
  :disabled
  :init
  (breadcrumb-mode 0))

(use-package yasnippet
  :init
  (yas-global-mode 1))

(use-package scroll-on-jump
  :custom
  (scroll-on-jump-curve 'linear)
  :config
  (scroll-on-jump-advice-add forward-paragraph)
  (scroll-on-jump-advice-add backward-paragraph))

(provide 'init-packages)
;;; init.el ends here
