;; forked from https://codeberg.org/fourier/borland-blue-theme

(deftheme borland-blue
  "This theme resembles the Borland/Turbe C IDE with the general idea as golden letters on a blue background.")

(let ((darker "NavyBlue")
      (bg "MidnightBlue"))
  (custom-theme-set-faces
   `borland-blue
   `(cursor ((t (:background "green" :foreground "white"))))
   `(region ((t (:foreground "black" :background "LightGrey"))))
   `(vertical-border ((t (:foreground "white" :background ,bg))))
   `(fringe ((t (:foreground "white" :background ,bg))))
   `(ecb-default-highlight-face ((t (:background "DarkSlateGray" :box (:line-width 1 :style released-button)))))
   `(ecb-default-general-face ((t (:foreground "white"))))
   `(font-lock-comment-face ((t (:foreground "LightGrey"))))
   `(font-lock-comment-delimiter-face ((t (:foreground "LightGrey"))))
   `(font-lock-doc-face ((t (:foreground "SandyBrown"))))
   `(font-lock-keyword-face ((t (:foreground "white"))))
   `(font-lock-preprocessor-face ((t (:foreground "green"))))
   `(font-lock-string-face ((t (:foreground "cyan1"))))
   `(font-latex-string-face ((t (:foreground "cyan1"))))
   `(font-latex-math-face ((t (:foreground "aquamarine1"))))
   `(font-lock-type-face ((t (:foreground "white"))))
   `(font-lock-builtin-face ((t (:foreground "white"))))
   `(font-lock-function-name-face ((t (:foreground "gold" :italic t))))
   `(font-lock-number-face ((t (:foreground "cyan1"))))
   `(font-lock-constant-face ((t (:foreground "gold"))))
   `(font-lock-warning-face ((t (:foreground "red"))))
   `(font-lock-operator-face ((t (:foreground "white"))))
   `(font-lock-end-statement ((t (:foreground "white"))))
   `(log4j-font-lock-warn-face ((t (:foreground "Orange"))))
   `(info-menu-header ((t (:foreground "white"))))
   `(info-title-1 ((t (:foreground "white"))))
   `(info-title-2 ((t (:foreground "white"))))
   `(info-title-3 ((t (:foreground "white"))))
   `(info-title-4 ((t (:foreground "white"))))
   `(py-builtins-face ((t (:foreground "#ffffff"))))
   `(helm-selection ((t (:background "Cyan" :foreground "black"))))
   `(helm-ff-directory ((t (:foreground "#ffffff" :background ,bg))))
   `(diredp-file-name ((t (:foreground "cyan1"))))
   `(diredp-file-suffix ((t (:foreground "cyan1"))))
   `(diredp-dir-heading ((t (:foreground "white" :background ,bg :underline t))))
   `(diredp-dir-priv ((t (:foreground "#ffffff" :background ,bg))))
   `(diredp-read-priv ((t (:foreground "grey" :background ,bg))))
   `(diredp-write-priv ((t (:foreground "grey" :background ,bg))))
   `(diredp-exec-priv ((t (:foreground "grey" :background ,bg))))
   `(diredp-no-priv ((t (:foreground "grey" :background ,bg))))
   `(diredp-flag-mark-line ((t (:background ,bg))))
   `(diredp-flag-mark ((t (:foreground "gold" :background ,bg))))
   `(diredp-inode+size ((t (:foreground "white"))))
   `(diredp-compressed-file-suffix ((t (:foreground "cyan1"))))
   `(diredp-ignored-file-name ((t (:foreground "cyan1"))))
   `(nxml-tag-delimiter ((t (:foreground "#E8BF6A"))))
   `(nxml-attribute-value-delimiter ((t (:foreground "#E8BF6A"))))
   `(nxml-element-local-name ((t (:foreground "#CC7832"))))
   `(nxml-attribute-local-name ((t (:foreground "#ABCDEF"))))
   `(nxml-attribute-value ((t (:foreground "#A5C261"))))
   `(nxml-text ((t (:foreground "#BABABA"))))
   `(nxml-cdata-section-content ((t (:foreground "gold"))))
   `(nxml-attribute-prefix ((t (:foreground "#BBEDFF"))))
   `(nxml-element-prefix ((t (:foreground "#EC9852"))))
   `(py-pseudo-keyword-face ((t (:foreground "#ABCDEF" :italic t))))
   `(py-builtins-face ((t (:foreground "white" :bold t))))
   `(py-number-face ((t (:foreground "cyan1"))))
   `(py-decorators-face ((t (:foreground "#BBB5B9" :italic t))))
   `(scala-font-lock:var-face ((t (:foreground "Magenta"))))
   `(erc-nick-default-face ((t (:foreground "#3b99fc" :bold t))))
   `(erc-default-face ((t (:foreground "#b2d7ff"))))
   `(erc-action-face ((t (:foreground "LightGrey"))))
   `(erc-button ((t (:foreground "cyan" :underline t))))
   `(whitespace-space ((t (:foreground "DarkSlateBlue"))))
   `(whitespace-tab ((t (:foreground "DarkSlateBlue" :background ,bg))))
   `(whitespace-trailing ((t (:foreground "DarkSlateBlue" :background ,bg))))
   `(org-level-1 ((t (:inherit org-level-1 :background ,darker))))
   `(org-level-2 ((t (:inherit org-level-2 :background ,darker))))
   `(org-level-3 ((t (:inherit org-level-3 :background ,darker))))
   `(org-level-4 ((t (:inherit org-level-4 :background ,darker))))
   `(org-level-5 ((t (:inherit org-level-5 :background ,darker))))
   `(org-level-6 ((t (:inherit org-level-6 :background ,darker))))
   `(org-level-7 ((t (:inherit org-level-7 :background ,darker))))
   `(org-level-8 ((t (:inherit org-level-8 :background ,darker))))
   `(default ((t (:family "default" :foundry "default" :underline nil :overline nil :strike-through nil :box nil :inverse-video nil :foreground "gold" :background ,bg :stipple nil :inherit nil))))))

(provide-theme `borland-blue)
