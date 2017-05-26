;;; terminal.el --- terminal only settings

;;; Commentary:

;; this is conf.el for kazuya-gosho

;;; Code:

;;; Load libraries

(custom-set-variables '(read-file-name-completion-ignore-case t))

(fset 'yes-or-no-p 'y-or-n-p)          ; (yes/no) -> (y/n)

;; シンボリックリンクの読み込み時に確認しない
(setq vc-follow-symlinks t)

;; シンボリックリンク先のVCS内で更新が入った場合にバッファを自動更新
(setq auto-revert-check-vc-info t)

(setq ruby-insert-encoding-magic-comment nil)
(setq initial-scratch-message "")

(global-auto-revert-mode 1)
(ido-mode t)

;;; Edit

(add-hook 'before-save-hook 'delete-trailing-whitespace) ;; 行末の空白を削除

;; Use auto indent
(setq-default indent-tabs-mode nil)
(electric-indent-mode 1)
(setq kill-whole-line t)

(setq comment-style 'multi-line)

;; 複数のスペースは同時に除去
(setq backward-delete-char-untabify-method 'hungry)

(setq scroll-step 1)

;; C-x C-l => downcase
(put 'downcase-region 'disabled nil)

;; M-u => upcase
(put 'upcase-region 'disabled nil)

;; Region to X clipboard
(defun paste-to-tmp-file(data)
  (with-temp-buffer
    (insert data)
    (write-file "/tmp/clipboard")))

(defun xclip-add-region()
  (interactive)
  (if (region-active-p)
      (progn
        (paste-to-tmp-file (buffer-substring-no-properties (region-beginning) (region-end)))
        (shell-command "xclip -i -selection clipboard < /tmp/clipboard")
        (message "%s" (shell-command-to-string "cat /tmp/clipboard")))
    (progn
      (message "no region"))))

;;; Face

(tool-bar-mode -1)
(menu-bar-mode -1)
(global-linum-mode t)
(scroll-bar-mode -1)

(setq linum-format "%4d ")

;; Hilight current line
(global-hl-line-mode)
(set-face-background 'hl-line "Gray23")
(set-face-foreground 'highlight nil)
(set-cursor-color "gray")

;;; migemo
(setq migemo-command "cmigemo")
(setq migemo-options '("-q" "--emacs"))
(setq migemo-dictionary "/usr/share/migemo/utf-8/migemo-dict")
(setq migemo-user-dictionary nil)
(setq migemo-regex-dictionary nil)
(setq migemo-coding-system 'utf-8-unix)
(load-library "migemo")
(migemo-init)

(if (not window-system)
    (progn
      ;; anzu
      (bind-key* "C-]" 'anzu-query-replace)   ;; C-5 compatible
      (bind-key* "M-5" 'anzu-query-replace-regexp)

      ;; linum style
      (set-face-attribute 'linum nil
                          :foreground "#ccc"
                          :background "Gray23")))

(defalias 'exit 'save-buffers-kill-emacs)

(keyboard-translate ?\C-h ?\C-?)
(add-hook 'after-make-frame-functions
          (lambda (f) (with-selected-frame f
                        (keyboard-translate ?\C-h ?\C-?))))

(progn
  (bind-key* "M-g" 'goto-line)
  (bind-key* "M-j" 'join-line)
  (bind-key* "M-z" 'zap-up-to-char))

;;; Set UTF-8 to default

(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
;;(setq default-buffer-file-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8)
(setq coding-system-for-read 'utf-8)
(setq coding-system-for-write 'utf-8)

(provide 'terminal)

;;; conf.el ends here

