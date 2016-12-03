;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Key settings
;;;;;;;;;;;;;;;;;;;;;;;;;;

(keyboard-translate ?\C-h ?\C-?)
(add-hook 'after-make-frame-functions
          (lambda (f) (with-selected-frame f
                        (keyboard-translate ?\C-h ?\C-?)
                        )))

(setq kill-whole-line t)
(bind-key "M-k" 'copy-whole-line)

(bind-key "C-x C-k" 'kill-this-buffer)
(bind-key "C-x k" 'kill-this-buffer)
(bind-key* "C-x C-j" 'dired-jump)
(bind-key* "C-x C-o" 'other-window)
(bind-key* "C-x o" 'other-window)

(bind-key* "C-u C-f" 'other-frame)

;; I never use C-x C-c
(bind-key "C-x C-c" 'nil)
(defalias 'exit 'save-buffers-kill-emacs)

(bind-key* "C-x C-q" 'delete-frame)
(bind-key* "M-g" 'goto-line)

;; vim 'd t' compatible
(bind-key "M-z" 'zap-up-to-char)
(bind-key "C-c ," 'er/expand-region)
(bind-key "M-j" 'join-line)

;; Japanese input
(bind-key* "C-;" 'mozc-start)
(bind-key "q" 'mozc-end mozc-mode-map)
(bind-key "C-g" 'mozc-end mozc-mode-map)
(bind-key* "C-x C-s" 'save-buffer)

;; Application
(bind-key* "C-x g" 'magit-status)
(bind-key "M-y" 'browse-kill-ring)

;; Helm
;; (bind-key* "C-x C-b" 'helm-mini)
;; (bind-key* "M-x" 'helm-M-x)
;;(bind-key* "C-x p" 'helm-grep-do-git-grep)
;;(bind-key* "C-u C-s" 'helm-swoop)
(bind-key* "C-u C-SPC" 'helm-mark-ring)

;; ivy
(bind-key* "C-x b" 'ivy-switch-buffer)
(bind-key* "C-x C-b" 'ivy-switch-buffer)
(bind-key* "M-x" 'counsel-M-x)
(bind-key* "C-u C-f" 'counsel-git)
(bind-key* "C-u C-s" 'swiper)
(bind-key* "C-x c i" 'ivy-resume)
(bind-key* "C-x f" 'counsel-find-file)
(bind-key* "C-x p" 'counsel-git-grep)
(bind-key* "C-x C-r" 'counsel-recentf)


(bind-key* "M-/" 'undo-tree-visualize)
(bind-key* "C-c C-r" 'mc/edit-lines)

;; open-junk
(bind-key "C-x j" 'open-junk-file)

(bind-key "C-c 0" 'org-shiftright)

(bind-key* "M-." 'xref-find-definitions-other-window)
