;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Basic path and Cask
;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(require 'cask "~/.cask/cask.el")
(cask-initialize)

; Add path for elisp from not MELPA
(add-to-list 'load-path "~/.emacs.d/lisp")

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
(bind-key "M-x" 'helm-M-x)
(bind-key "C-x C-q" 'save-buffers-kill-emacs)

;; vim 'd t' compatible
(require 'misc)
(bind-key "M-z" 'zap-up-to-char)

;; expand region
(require 'expand-region)
(bind-key "C-c ," 'er/expand-region)
(bind-key "C-c i" 'iedit-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Search settings
;;;;;;;;;;;;;;;;;;;;;;;;;;

;; anzu周りの設定
(require 'anzu)

(global-anzu-mode +1)
(setq anzu-use-migemo nil)
(setq anzu-search-threshold 1000)
(setq anzu-minimum-input-length 3)

(bind-key* "C-]" 'anzu-query-replace)
(bind-key* "M-5" 'anzu-query-replace-regexp)

;; 選択範囲をisearch
(defadvice isearch-mode
    (around isearch-mode-default-string (forward &optional regexp op-fun recursive-edit word-p) activate)
  (if (and transient-mark-mode mark-active (not (eq (mark) (point))))
      (progn
        (isearch-update-ring (buffer-substring-no-properties (mark) (point)))
        (deactivate-mark)
        ad-do-it
        (if (not forward)
            (isearch-repeat-backward)
          (goto-char (mark))
          (isearch-repeat-forward)))
    ad-do-it))

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; File
;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Do not create backup file
(setq make-backup-files nil)
(setq auto-save-default nil)

;; Do not show welcome message
(setq inhibit-startup-message t)

;; Smart buffer
(global-set-key "\C-x\C-b" 'helm-mini)

;; Auto start server
(require 'server)
(unless (server-running-p)
  (server-start))

;; do not insert magic comments
(setq ruby-insert-encoding-magic-comment nil)

;; シンボリックリンクの読み込みを許可
(setq vc-follow-symlinks t)
;; シンボリックリンク先のVCS内で更新が入った場合にバッファを自動更新
(setq auto-revert-check-vc-info t)

;; Diredを使いやすくする
(ffap-bindings)

;; バッファ自動再読み込み
(global-auto-revert-mode 1)

;;file名の補完で大文字小文字を区別しない
(setq completion-ignore-case t)


;; undo tree always load
(require 'undo-tree)
(global-undo-tree-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Edit
;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Not use auto indent
(setq-default indent-tabs-mode nil)
(electric-indent-mode 1)

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
        (shell-command "xsel -ib < /tmp/clipboard")
        (message "%s" (shell-command-to-string "cat /tmp/clipboard")))
    (progn
      (message "no region"))))

(bind-key* "C-c C-c" 'xclip-add-region)

(require 'multiple-cursors)
(bind-key* "C-c C-r" 'mc/mark-next-like-this)

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; View
;;;;;;;;;;;;;;;;;;;;;;;;;;

; Don't show tool-bar and menu-bar
(tool-bar-mode -1)
(menu-bar-mode -1)
(global-linum-mode t)
(setq linum-format "%4d ")
(set-face-attribute 'linum nil
                    :foreground "#ccc"
                    :background "Gray23")

;; Hilight current line
(global-hl-line-mode)
(set-face-background 'hl-line "Gray23")
(set-face-foreground 'highlight nil)

;; カーソル位置の桁数をモードライン行に表示する
(column-number-mode 1)

;; スクロールバー非表示
(scroll-bar-mode 0)


;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org mode
;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq org-src-fontify-natively t)

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Markdown
;;;;;;;;;;;;;;;;;;;;;;;;;;

(autoload 'markdown-mode "markdown-mode.el" "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

; Markdown Table
(defun cleanup-org-tables ()
    (save-excursion
        (goto-char (point-min))
        (while (search-forward "-+-" nil t) (replace-match "-|-"))))
(add-hook 'markdown-mode-hook 'orgtbl-mode)
(add-hook 'markdown-mode-hook
    '(lambda()
        (add-hook 'after-save-hook 'cleanup-org-tables  nil 'make-it-local)))

;;;;;;;;;;;;;;;;;;;;;;;;;;
; filetype mode
;;;;;;;;;;;;;;;;;;;;;;;;;;

;; php-mode
(require 'php-mode)


;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set UTF-8 to default
;;;;;;;;;;;;;;;;;;;;;;;;;;

(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8)
(setq coding-system-for-read 'utf-8)
(setq coding-system-for-write 'utf-8)


;;;;;;;;;;;;;;;;;;;;;;;;;;
; auto-complete
;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'auto-complete-config)
(ac-config-default)
(add-to-list 'ac-modes 'text-mode)         ;; text-modeでも自動的に有効にする
(add-to-list 'ac-modes 'fundamental-mode)  ;; fundamental-mode
(add-to-list 'ac-modes 'org-mode)
(add-to-list 'ac-modes 'yatex-mode)
(setq ac-use-menu-map t)       ;; 補完メニュー表示時にC-n/C-pで補完候補選択


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (undo-tree iedit ## browse-kill-ring markdown-mode htmlize cask bind-key auto-complete))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(put 'upcase-region 'disabled nil)


;;;;;;;;;;;;;;;;;;;;;;;;;;
; mozc
;;;;;;;;;;;;;;;;;;;;;;;;;;

; Mozc settings
(require 'mozc)
(set-language-environment "Japanese")
(setq default-input-method "japanese-mozc")

(require 'mozc-popup)
(setq mozc-candidate-style 'popup)

