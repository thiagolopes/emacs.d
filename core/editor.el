;;; editor.el

;; Delete the selection with a keypress
(delete-selection-mode t)

;; Store all backup and autosave files in the tmp dir
(setq-default backup-directory-alist `(("." . ,(expand-file-name "backup" savefile-dir))))

;; Revert buffers automatically when underlying files are changed externally
(setq auto-revert-interval 1)
(setq auto-revert-check-vc-info t)
(global-auto-revert-mode)

;; Move through windows with Ctrl-<arrow keys>
(windmove-default-keybindings 'control) ; You can use other modifiers here

;; Make right-click do something sensible
(when (display-graphic-p)
  (context-menu-mode))

;;; Make names uniques
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)
(setq uniquify-separator "/")
(setq uniquify-after-kill-buffer-p t)    ; rename after killing uniquified
(setq uniquify-ignore-buffers-re "^\\*") ; don't muck with special buffers

;; https://www.emacswiki.org/emacs/SavePlace
;; Saveplace remembers your location in a file when saving files and activate it for all buffers
(setq-default save-place-file (expand-file-name "saveplace" savefile-dir))
(save-place-mode 1)

;; savehist keeps track of some history
(require 'savehist)
(setq savehist-additional-variables
      ;; search entries
      '(search-ring regexp-search-ring)
      ;; save every minute
      savehist-autosave-interval 60
      ;; keep the home clean
      savehist-file (expand-file-name "savehist" savefile-dir))
(savehist-mode +1)

;; save recent files
(require 'recentf)
(setq recentf-save-file (expand-file-name "recentf" savefile-dir)
      recentf-max-saved-items 500
      recentf-max-menu-items 15
      ;; disable recentf-cleanup on Emacs start, because it can cause
      ;; problems with remote files
      recentf-auto-cleanup 'never)
(recentf-mode +1)

;; more useful frame title, that show either a file or a
;; buffer name (if the buffer isn't visiting a file)
(setq frame-title-format
      '(""(:eval (if (buffer-file-name)
                     (abbreviate-file-name (buffer-file-name))
                   "%b"))))

(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(setq-default display-line-numbers-width 3)
(setq column-number-mode t)

(global-set-key (kbd "C-=") #'text-scale-increase)
(global-set-key (kbd "C-+") #'text-scale-increase)
(global-set-key (kbd "C--") #'text-scale-decrease)
(global-set-key (kbd "M-n") #'forward-paragraph)
(global-set-key (kbd "M-p") #'backward-paragraph)

;; Buffer navegation
(global-set-key (kbd "<f3>") 'kmacro-start-macro-or-insert-counter)
(global-set-key (kbd "<f4>") 'kmacro-end-or-call-macro)

;; lisp sanitize
(global-set-key (kbd "M-3") #'(lambda () (interactive) (insert "#")))
(global-set-key (kbd "M-9") #'(lambda () (interactive) (insert "(")))
(global-set-key (kbd "M-0") #'(lambda () (interactive) (insert ")")))
(global-set-key (kbd "M-[") #'(lambda () (interactive) (insert "{")))
(global-set-key (kbd "M-]") #'(lambda () (interactive) (insert "}")))

(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)

;; sanitize macos keys
(if (eq system-type 'darwin)
    (progn
      (setq mac-option-key-is-meta nil)
      (setq mac-command-key-is-meta t)
      (setq mac-command-modifier 'meta)
      (setq mac-option-modifier nil)))

;; better scratch https://www.reddit.com/r/emacs/comments/4cmfwp/scratch_buffer_hacks_to_increase_its_utility/
(defun immortal-scratch ()
  (if (eq (current-buffer) (get-buffer "*scratch*"))
      (progn (bury-buffer)
             nil) t))
(add-hook 'kill-buffer-query-functions 'immortal-scratch)

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
(add-hook 'after-init-hook 'load-persistent-scratch)
(add-hook 'kill-emacs-hook 'save-persistent-scratch)
(run-with-idle-timer 300 t 'save-persistent-scratch)

;; focus at compilation buffer
(defadvice compile (after jump-back activate)
  (other-window 1))

;; Fix compilation buffer asci caracheters
(require 'ansi-color)
(defun ansi-colorize-buffer ()
  (let ((buffer-read-only nil))
    (ansi-color-apply-on-region (point-min) (point-max))))
(add-hook 'compilation-filter-hook 'ansi-colorize-buffer)

;; dired with larger font
(global-set-key (kbd "C-x C-d") 'dired)

;;
(setq enable-recursive-minibuffers t)                ; Use the minibuffer whilst in the minibuffer
(setq x-underline-at-descent-line nil)               ; Prettier underlines
(setq switch-to-buffer-obey-display-actions t)       ; Make switching buffers more consistent
(setq-default show-trailing-whitespace nil)          ; By default, don't underline trailing spaces
(setq-default indicate-buffer-boundaries 'left)      ; Show buffer top and bottom in the margin

(keymap-set minibuffer-mode-map "TAB" 'minibuffer-complete) ; TAB acts more like how it does in the shell
(add-hook 'text-mode-hook 'visual-line-mode)

;; display time
(display-time-mode)

(provide 'editor)
