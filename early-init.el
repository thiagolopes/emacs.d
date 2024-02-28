;;; early-init.el -- only focus on emacs setup -*- lexical-binding: t; -*-
;;; Commentary:
;;;  to everthing early
;;; Code:

(setq package-enable-at-startup nil)

(setq straight-use-package-by-default t
      straight-cache-autoloads t
      straight-vc-git-default-clone-depth 1
      straight-check-for-modifications '(find-when-checking)
      package-enable-at-startup nil
      vc-follow-symlinks t)

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

(require 'straight-x)
(straight-use-package 'use-package)
(require 'use-package)
(use-package general)

(setq use-package-verbose t
      use-package-compute-statistics nil
      debug-on-error t
      init-file-debug t)
(setq user-full-name "Thiago Lopes"
      user-mail-address "thiagolopes@protonmail.com")

(defvar comp-deferred-compliation)
(setq comp-deferred-compilation t)

(setq gc-cons-threshold 100000000
      read-process-output-max (* 1024 1024))
(add-hook 'after-init-hook #'garbage-collect t)

(custom-set-faces
 '(default ((t (:height 110 :width expanded :family "Iosevka")))))
(setq-default line-spacing 0)

;; Add padding inside frames (windows)
(add-to-list 'default-frame-alist '(internal-border-width . 2))

(set-window-buffer nil (current-buffer))

(setq whitespace-line-column nil
      whitespace-style
      '(face indentation tabs tab-mark spaces space-mark newline newline-mark
             trailing lines-tail)
      whitespace-display-mappings
      '((tab-mark ?\t [?› ?\t])
        (newline-mark ?\n [?¬ ?\n])
        (space-mark ?\  [?·] [?.])))
(context-menu-mode t)
(column-number-mode t)
(setq dired-dwim-target t  ; suggest a target for moving/copying intelligently
      dired-hide-details-hide-symlink-targets nil
      ;; don't prompt to revert, just do it
      dired-auto-revert-buffer #'dired-buffer-stale-p
      ;; Always copy/delete recursively
      dired-recursive-copies  'always
      dired-recursive-deletes 'top
      ;; Ask whether destination dirs should get created when copying/removing files.
      dired-create-destination-dirs 'ask
      ;; Where to store image caches
      image-dired-dir (concat user-emacs-directory "image-dired/")
      image-dired-db-file (concat image-dired-dir "db.el")
      image-dired-gallery-dir (concat image-dired-dir "gallery/")
      image-dired-temp-image-file (concat image-dired-dir "temp-image")
      image-dired-temp-rotate-image-file (concat image-dired-dir "temp-rotate-image")
      ;; Screens are larger nowadays, we can afford slightly larger thumbnails
      image-dired-thumb-size 150)

(setq site-run-file nil)
(setq inhibit-compacting-font-caches t)
(when (boundp 'read-process-output-max)
  ;; 1MB in bytes, default 4096 bytes
  (setq read-process-output-max 1048576))

(global-prettify-symbols-mode t)
(setq enable-recursive-minibuffers t)
;; Show current key-sequence in minibuffer ala 'set showcmd' in vim. Any
;; feedback after typing is better UX than no feedback at all.
(setq echo-keystrokes 0.02)
;; Expand the minibuffer to fit multi-line text displayed in the echo-area. This
;; doesn't look too great with direnv, however...
(setq resize-mini-windows 'grow-only)
;; Try to keep the cursor out of the read-only portions of the minibuffer.
(setq minibuffer-prompt-properties '(read-only t intangible t cursor-intangible t face minibuffer-prompt))
(add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

(setq x-select-enable-clipboard-manager nil)
(setq warning-minimum-level :error)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(horizontal-scroll-bar-mode -1)
(menu-bar-mode -1)
(defalias 'yes-or-no-p 'y-or-n-p)
(show-paren-mode 1)
(setq show-paren-highlight-openparen nil)

(setq save-interprogram-paste-before-kill t
      apropos-do-all t
      mouse-yank-at-point t
      require-final-newline t
      backup-by-copying t
      frame-inhibit-implied-resize t
      ediff-window-setup-function 'ediff-setup-windows-plain)
(setq make-backup-files nil)

;; A simple frame title
(setq frame-title-format '("%b – Emacs")
      icon-title-format frame-title-format)

;; Don't resize the frames in steps; it looks weird, especially in tiling window
;; managers, where it can leave unseemly gaps.
(setq frame-resize-pixelwise t)

;; But do not resize windows pixelwise, this can cause crashes in some cases
;; when resizing too many windows at once or rapidly.
(setq window-resize-pixelwise t)

;; UX: GUIs are inconsistent across systems, desktop environments, and themes,
;;   and don't match the look of Emacs. They also impose inconsistent shortcut
;;   key paradigms. I'd rather Emacs be responsible for prompting.
(setq use-dialog-box nil)
(when (bound-and-true-p tooltip-mode)
  (tooltip-mode -1))

;; UX: Favor vertical splits over horizontal ones. Monitors are trending toward
;;   wide, rather than tall.
(setq split-width-threshold 160
      split-height-threshold nil)

;; FIX: The native border "consumes" a pixel of the fringe on righter-most
;;   splits, `window-divider' does not. Available since Emacs 25.1.
(setq window-divider-default-places t
      window-divider-default-bottom-width 1
      window-divider-default-right-width 1)
(add-hook 'prog-mode #'window-divider-mode)

;; Don't prompt for confirmation when we create a new file or buffer (assume the
;; user knows what they're doing).
(setq confirm-nonexistent-file-or-buffer nil)
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

;; no beeping or blinking please
;; (setq ring-bell-function #'ignore
;; visible-bell nil)
;; beeping PLEASE! but not too much
(setq ring-bell-function
      (lambda ()
        (unless (memq this-command
                      '(isearch-abort
                        abort-recursive-edit
                        exit-minibuffer
                        keyboard-quit
                        previous-line
                        next-line
                        scroll-down
                        scroll-up
                        cua-scroll-down
                        cua-scroll-up))
          (ding))))

;; middle-click paste at point, not at click
(setq mouse-yank-at-point t)
(setq hscroll-margin 2
      hscroll-step 1
      ;; Emacs spends too much effort recentering the screen if you scroll the
      ;; cursor more than N lines past window edges (where N is the settings of
      ;; `scroll-conservatively'). This is especially slow in larger files
      ;; during large-scale scrolling commands. If kept over 100, the window is
      ;; never automatically recentered. The default (0) triggers this too
      ;; aggressively, so I've set it to 10 to recenter if scrolling too far
      ;; off-screen.
      scroll-conservatively 10
      scroll-margin 0
      scroll-preserve-screen-position t
      ;; Reduce cursor lag by a tiny bit by not auto-adjusting `window-vscroll'
      ;; for tall lines.
      auto-window-vscroll nil
      ;; mouse
      mouse-wheel-scroll-amount '(2 ((shift) . hscroll))
      mouse-wheel-scroll-amount-horizontal 2)

(blink-cursor-mode -1)
(setq-default cursor-type 'bar)
(setq-default cursor-in-non-selected-windows nil)
(setq blink-matching-paren nil)
(setq x-stretch-cursor nil)
;; useful information, like git-gutter and flycheck.
(setq indicate-buffer-boundaries nil
      indicate-empty-lines nil)

(use-package doom-themes
  :config
  (setq doom-themes-enable-italic nil)
  (setq doom-themes-enable-bold t))
(use-package modus-themes
  :defer t
  :custom
  (modus-themes-italic-constructs t)
  (modus-themes-intense-markup t)
  (modus-themes-mode-line '(borderless moody))
  (modus-themes-tabs-accented t)
  (modus-themes-completions
   '((matches . (extrabold background intense))
     (selection . (semibold accented intense))
     (popup . (accented))
     (t . (extrabold intense))))
  (modus-themes-org-blocks 'tinted-background)
  (modus-themes-mixed-fonts t)
  (modus-themes-headings
   '((1 . (rainbow))
     (2 . (rainbow))
     (3 . (rainbow))
     (t . (monochrome)))))
(use-package gruber-darker-theme)
(use-package darktooth-theme)
(use-package subatomic-theme
  :config
  (setq subatomic-high-contrast t))
(use-package naysayer-theme
  :config
  (defun naysayer-customize ()
    (interactive)
    (let ((border-width '(2 . 2))
          (punctuation "#8cde94")
          (background "#062329")
          (selection  "#0000ff")
          (background-darker "#041b20")
          (fg "#126367")
          (text "#d1b897")
          (white "#ffffff")
          (black "#000000")
          (variables "#c1d1e3")
          (strings "#2ec09c")
          (constants "#7ad0c6")
          (keywords "#ffffff")
          (comments "#44b340")
          (builtin "#ffffff")
          ;; colors from monokay
          (yellow "#E6DB74")
          (orange "#DF911F")
          (red "#F92672")
          (magenta "#FD5FF0")
          (blue "#66D8EF")
          (green "#A6E22E")
          (cyan "#A1EFE4")
          (violet "#AE81FF")
          (smaller 90))
      (custom-set-faces
       ;; Error, Warning, Info, Success
       `(error ((t (:foreground ,red :height ,smaller))))
       `(warning ((t (:foreground ,yellow :height ,smaller))))
       `(info ((t (:foreground ,magenta :height ,smaller))))
       `(success ((t (:foreground ,green :height ,smaller))))

       ;; CTRLF
       `(ctrlf-highlight-active ((t (:background ,selection :foreground ,white))))
       `(ctrlf-highlight-passive ((t (:background ,background-darker :foreground ,strings))))

       ;; Swipper
       `(swiper-line-face ((t (:background ,background-darker))))
       `(swiper-match-face-2 ((t (:background ,strings :foreground ,black))))

       ;; Font lock
       `(font-lock-keyword-face ((t (:foreground ,keywords :slant italic))))
       `(font-lock-constant-face ((t (:foreground ,constants))))
       `(font-lock-builtin-face ((t (:foreground ,builtin :slant italic))))
       `(font-lock-comment-face ((t (:foreground ,comments :height ,smaller :background ,background-darker))))
       `(font-lock-comment-delimiter-face ((t (:foreground ,comments :height ,smaller :background ,background-darker))))
       ;; `(font-lock-type-face              ((t (:foreground ,punctuation))))
       ;; `(font-lock-variable-name-face     ((t (:foreground ,variables))))
       ;; `(font-lock-string-face            ((t (:foreground ,strings))))
       ;; `(font-lock-doc-face               ((t (:foreground ,comments))))
       ;; `(font-lock-function-name-face     ((t (:foreground ,functions))))
       ;; `(font-lock-doc-string-face        ((t (:foreground ,strings))))
       ;; `(font-lock-preprocessor-face      ((t (:foreground ,macros))))
       ;; `(font-lock-warning-face           ((t (:foreground ,warning))))

       ;; Flycheck
       `(flycheck-posframe-background-face ((t (:background ,background-darker))))
       `(flycheck-posframe-border-face ((t (:foreground ,background-darker))))
       `(flycheck-inline-error ((t (:background ,background-darker))))
       `(flycheck-inline-warning ((t (:background ,background-darker))))
       `(flycheck-inline-info ((t (:background ,background-darker))))
       `(flycheck-error
         ((((supports :underline (:style wave)))
           (:underline (:style wave :color ,red)
                       :foreground unspecified
                       :background unspecified
                       :inherit unspecified))
          (t (:foreground ,red :weight normal :underline t))))
       `(flycheck-warning
         ((((supports :underline (:style wave)))
           (:underline (:style wave :color ,yellow)
                       :foreground unspecified
                       :background unspecified
                       :inherit unspecified))
          (t (:forground ,yellow :weight normal :underline t))))
       `(flycheck-info
         ((((supports :underline (:style wave)))
           (:underline (:style wave :color ,green)
                       :foreground unspecified
                       :background unspecified
                       :inherit unspecified))
          (t (:forground ,green :weight normal :underline t))))

       ;; Flymake
       `(flymake-error
         ((((supports :underline (:style wave)))
           (:underline (:style wave :color ,red)
                       :foreground unspecified
                       :background unspecified
                       :inherit unspecified))
          (t (:foreground ,red :weight normal :underline t))))
       `(flymake-warning
         ((((supports :underline (:style wave)))
           (:underline (:style wave :color ,yellow)
                       :foreground unspecified
                       :background unspecified
                       :inherit unspecified))
          (t (:forground ,yellow :weight normal :underline t))))
       `(flymake-note
         ((((supports :underline (:style wave)))
           (:underline (:style wave :color ,green)
                       :foreground unspecified
                       :background unspecified
                       :inherit unspecified))
          (t (:forground ,green :weight normal :underline t))))

       ;; bm
       `(bm-persistent-face ((t (:background ,background-darker))))

       ;; mode-line
       `(mode-line ((t (:inverse-video unspecified
                                       :underline unspecified
                                       :foreground ,background
                                       :background ,text
                                       :box (:line-width ,border-width
                                                         :style released-button)))))
       `(mode-line-inactive ((t (:inverse-video unspecified
                                                :underline unspecified
                                                :foreground ,text
                                                :background ,background-darker
                                                :box (:line-width ,border-width
                                                                  :style released-button
                                                                  :foreground ,text)))))

       `(cursor ((t (:background ,punctuation))))
       `(which-func ((t (:inverse-video unspecified
                                        :underline unspecified
                                        :foreground ,background
                                        :weight bold
                                        :box (:line-width ,border-width
                                                          :style released-button
                                                          :foreground ,text)))))
       `(show-paren-match ((t (:background nil
                                           :foreground ,white
                                           :bold t
                                           :inverse-video nil))))
       `(solaire-default-face ((t (:background ,background-darker))))
       `(symbol-overlay-default-face ((t (:background nil :bold t :underline t))))
       `(whitespace-space ((t (:background ,background :foreground ,fg))))

       ;; Ido
       `(ido-first-match ((t (:foreground ,white :bold t))))

       ;; LSP
       `(lsp-face-highlight-textual ((t (:background , background-darker))))

       ;; Pulsar
       `(pulsar-generic ((t (:background ,selection))))
       `(pulsar-red ((t (:background ,red))))
       `(pulsar-gree ((t (:background ,green))))
       `(pulsar-yellow ((t (:background ,yellow))))
       `(pulsar-blue ((t (:background ,blue))))
       `(pulsar-magenta ((t (:background ,magenta))))
       `(pulsar-cyan ((t (:background ,cyan))))

       ;; rainbow
       `(rainbow-delimiters-depth-1-face ((t (:foreground ,violet))))
       `(rainbow-delimiters-depth-2-face ((t (:foreground ,blue))))
       `(rainbow-delimiters-depth-3-face ((t (:foreground ,green))))
       `(rainbow-delimiters-depth-4-face ((t (:foreground ,yellow))))
       `(rainbow-delimiters-depth-5-face ((t (:foreground ,orange))))
       `(rainbow-delimiters-depth-6-face ((t (:foreground ,red))))
       `(rainbow-delimiters-depth-7-face ((t (:foreground ,violet))))
       `(rainbow-delimiters-depth-8-face ((t (:foreground ,blue))))
       `(rainbow-delimiters-depth-9-face ((t (:foreground ,green))))
       `(rainbow-delimiters-depth-10-face ((t (:foreground ,yellow))))
       `(rainbow-delimiters-depth-11-face ((t (:foreground ,orange))))
       `(rainbow-delimiters-depth-12-face ((t (:foreground ,red)))))))
  (naysayer-customize))
;;; load theme
(load-theme 'naysayer t)

;; Explicitly define a width to reduce the cost of on-the-fly computation
(setq-default display-line-numbers-width 3)
;; Show absolute line numbers for narrowed regions to make it easier to tell the
;; buffer is narrowed, and where you are, exactly.
(setq-default display-line-numbers-widen t)
;; (add-hook 'prog-mode-hook #'display-line-number-mode)
;; (add-hook 'text-mode-hook #'display-line-number-mode)
;; (add-hook 'conf-mode-hook #'display-line-number-mode)
;; (setq display-line-numbers-type t) ;; disable line number as default
(general-define-key "<f10>" 'global-display-line-numbers-mode)

(electric-pair-mode t)

(require 'saveplace)
(setq-default save-place t)
(save-place-mode t)
(setq save-place-file (concat user-emacs-directory "cache/places"))
(setq org-directory "~/org/"
      cache-dir (concat user-emacs-directory "/cache")
      custom-file (concat user-emacs-directory "/custom.el")
      require-final-newline t
      load-prefer-newer t)

;; Made SHIFT+arrow to move to the next adjacent window in the specified direction
(windmove-default-keybindings)

(general-define-key "<mouse-8>" #'previous-buffer
                    "<mouse-9>" #'next-buffer)

(general-define-key "C-=" #'text-scale-increase
                    "C-+" #'text-scale-increase
                    "C--" #'text-scale-decrease
                    "M-n" #'forward-paragraph
                    "M-p" #'backward-paragraph)

(general-define-key "<f3>" #'kmacro-start-macro-or-insert-counter
                    "<f4>" #'kmacro-end-or-call-macro)

(general-define-key "M-3" '(lambda () (interactive) (insert "#"))
                    "M-9" '(lambda () (interactive) (insert "("))
                    "M-0" '(lambda () (interactive) (insert ")"))
                    "M-[" '(lambda () (interactive) (insert "{"))
                    "M-]" '(lambda () (interactive) (insert "}")))

(general-define-key "C-x C-b" #'ibuffer
                    "C-r"     #'isearch-backward-regexp
                    "C-M-s"   #'isearch-forward
                    "C-M-r"   #'isearch-backward)

(general-define-key "C-s" #'swiper-isearch-thing-at-point
                    "C-S" #'swiper-isearch)

(setq isearch-lax-whitespace t
      isearch-regexp-lax-whitespace t
      search-whitespace-regexp "[ \t\r\n]+")

;; Yes, I really want to quit.
(setq confirm-kill-emacs nil)

;; Increase minibuffer font
(add-hook 'minibuffer-setup-hook
          '(lambda () (set (make-local-variable 'face-remapping-alist)
                      '((default :height 1.2)))))

;; Setup dark GTK theme if available
(defun set-emacs-frames-gtk (variant)
  (dolist (frame (frame-list))
    (let* ((window-id (frame-parameter frame 'outer-window-id))
           (id (string-to-number window-id))
           (cmd (format "xprop -id 0x%x -f _GTK_THEME_VARIANT 8u -set _GTK_THEME_VARIANT \"%s\"" id
                        variant)))
      (call-process-shell-command cmd))))
(when (and (eq system-type 'gnu/linux) (display-graphic-p))
  (set-emacs-frames-gtk "dark"))

;; Imortal *scratch* !!
(defun immortal-scratch ()
  (if (eq (current-buffer) (get-buffer "*scratch*"))
      (progn (bury-buffer)
             nil) t))
(defun save-persistent-scratch ()
  "Save the contents of *scratch*"
  (with-current-buffer (get-buffer-create "*scratch*")
    (write-region (point-min) (point-max)
                  (concat user-emacs-directory "scratch"))))
(defun load-persistent-scratch ()
  "Reload the scratch buffer"
  (let ((scratch-file (concat user-emacs-directory "scratch")))
    (if (file-exists-p scratch-file)
        (with-current-buffer (get-buffer "*scratch*")
          (delete-region (point-min) (point-max))
          (insert-file-contents scratch-file)))))
(add-hook 'kill-buffer-query-functions 'immortal-scratch)
(add-hook 'after-init-hook 'load-persistent-scratch)
(add-hook 'kill-emacs-hook 'save-persistent-scratch)
(run-with-idle-timer 300 t 'save-persistent-scratch)

(setq ido-enable-flex-matching t)
(setq ido-use-filename-at-point 'guess)
(setq ido-create-new-buffer 'always)
(setq ido-everywhere t)
(ido-mode 1)

;; (pixel-scroll-precision-mode t)
;; (setq pixel-scroll-precision-large-scroll-height 101.0)
;; (setq pixel-scroll-precision-use-momentum nil)
(setq fast-but-imprecise-scrolling t
      jit-lock-defer-time 0)

(use-package fast-scroll
  :diminish
  :hook
  (fast-scroll-start . (lambda () (flycheck-mode -1)))
  (fast-scroll-end . (lambda () (flycheck-mode 1)))
  :config
  (fast-scroll-config)
  (fast-scroll-mode 1))

;; Yes, I really want compile
(setq compilation-ask-about-save nil)

;; ctyle
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq c-set-style "k&r")
(setq c-basic-offset 4)
(setq comment-style 'extra-line)
(add-hook 'c-mode-hook '(lambda () (setq comment-start "//"
                                    comment-end   "")))
(add-hook 'prog-mode #'electric-operator-mode)

;; copy-paste
(cua-mode t)

;; treat camel-cased words as individual words.
(add-hook 'prog-mode-hook 'subword-mode)
;; don't assume sentences end with two spaces after a period.
(setq sentence-end-double-space nil)
;; show matching parens
(defun show-paren--locate-near-paren-ad ()
  "Locate an unescaped paren \"near\" point to show.
If one is found, return the cons (DIR . OUTSIDE), where DIR is 1
for an open paren, -1 for a close paren, and OUTSIDE is the buffer
position of the outside of the paren.  Otherwise return nil."
  (let* ((before (show-paren--categorize-paren (point))))
    (when (or
           (eq (car before) 1)
           (eq (car before) -1))
      before)))
;; (advice-add 'show-paren--locate-near-paren :override #'show-paren--locate-near-paren-ad)
(show-paren-mode t)
(setq show-paren-delay 0.0)
;; limit files to 80 columns. Controversial, I know.
(setq-default fill-column 80)
;; handle very long lines without hurting emacs
(global-so-long-mode)

(use-package gcmh
  :diminish
  :demand t
  :config
  (gcmh-mode 1))

(setq default-directory "~/"
      ;; overwrite text when selected, like we expect.
      delete-seleciton-mode t
      ;; quiet startup
      inhibit-startup-message t
      ;; hopefully all themes we install are safe
      custom-safe-themes t
      ;; simple lock/backup file management
      create-lockfiles nil
      backup-by-copying t
      delete-old-versions t
      ;; when quiting emacs, just kill processes
      confirm-kill-processes nil
      ;; ask if local variables are safe once.
      enable-local-variables t
      ;; life is too short to type yes or no
      use-short-answers t
      ;; clean up dired buffers
      dired-kill-when-opening-new-dired-buffer t)

(setq-default dired-listing-switches "-alh")

;; always highlight code
(global-font-lock-mode 1)
;; refresh a buffer if changed on disk
(setq global-auto-revert-non-file-buffers t)
(global-auto-revert-mode 1)

;; utf8
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(set-file-name-coding-system 'utf-8)
(set-clipboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)

(add-hook 'compilation-filter-hook 'ansi-color-compilation-filter)

;; default browser
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "firefox")
;;
(which-function-mode t)

;;
(fringe-mode)
(general-setq-default indicate-empty-lines t
                      indicate-buffer-boundaries 'left)

;; please, maximize
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; eletric-mode
(when (fboundp 'electric-indent-mode) (electric-indent-mode -1))

;;; early-init.el ends here;
