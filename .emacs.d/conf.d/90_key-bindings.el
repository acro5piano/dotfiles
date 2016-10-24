;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Key settings
;;;;;;;;;;;;;;;;;;;;;;;;;;

(keyboard-translate ?\C-h ?\C-?)
(add-hook 'after-make-frame-functions
          (lambda (f) (with-selected-frame f
                        (keyboard-translate ?\C-h ?\C-?)
                        )))

(setq kill-whole-line t)
(bind-key "M-y" 'browse-kill-ring)

;; I never use C-x C-c
(bind-key "C-x C-c" 'nil)
(defalias 'exit 'save-buffers-kill-emacs)

(bind-key* "C-x C-q" 'delete-frame)
(bind-key* "M-g" 'goto-line)

;; vim 'd t' compatible
(bind-key "M-z" 'zap-up-to-char)
(bind-key "C-c ," 'er/expand-region)

(bind-key (kbd "M-k") 'copy-whole-line)

(bind-key* "C-x g" 'magit-status)

;; helm
(bind-key* "C-x C-b" 'helm-mini)
(bind-key* "M-x" 'helm-M-x)
(bind-key* "C-x p" 'helm-do-ag-project-root)
(bind-key* "C-x b" 'helm-do-ag-buffers)
(bind-key* "C-x f" 'helm-do-ag-this-file)
(bind-key* "C-x a" 'helm-do-ag)

(bind-key* "C-c C-x" 'xclip-add-region)
(bind-key* "C-c C-r" 'mc/mark-next-like-this)

;; open-junk
(bind-key (kbd "C-x j") 'open-junk-file)
