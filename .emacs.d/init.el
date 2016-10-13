;;; init.el --- dotfiles of kazuya

;;; Commentary:

;; this is init.el for kazuya-gosho

;;; Code:

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

;; Add path for elisp not from MELPA
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
(bind-key "C-x C-q" 'save-buffers-kill-emacs)

;; helm
(bind-key* "M-x" 'helm-M-x)
(bind-key* "C-x C-d" 'helm-find-files)

;; vim 'd t' compatible
(require 'misc)
(bind-key "M-z" 'zap-up-to-char)

;; expand region
(require 'expand-region)
(bind-key "C-c ," 'er/expand-region)


(defun copy-whole-line (&optional arg)
  "Copy current line."
  (interactive "p")
  (or arg (setq arg 1))
  (if (and (> arg 0) (eobp) (save-excursion (forward-visible-line 0) (eobp)))
      (signal 'end-of-buffer nil))
  (if (and (< arg 0) (bobp) (save-excursion (end-of-visible-line) (bobp)))
      (signal 'beginning-of-buffer nil))
  (unless (eq last-command 'copy-region-as-kill)
    (kill-new "")
    (setq last-command 'copy-region-as-kill))
  (cond ((zerop arg)
         (save-excursion
           (copy-region-as-kill (point) (progn (forward-visible-line 0) (point)))
           (copy-region-as-kill (point) (progn (end-of-visible-line) (point)))))
        ((< arg 0)
         (save-excursion
           (copy-region-as-kill (point) (progn (end-of-visible-line) (point)))
           (copy-region-as-kill (point)
                                (progn (forward-visible-line (1+ arg))
                                       (unless (bobp) (backward-char))
                                       (point)))))
        (t
         (save-excursion
           (copy-region-as-kill (point) (progn (forward-visible-line 0) (point)))
           (copy-region-as-kill (point)
                                (progn (forward-visible-line arg) (point))))))
  (message (substring (car kill-ring-yank-pointer) 0 -1)))

(global-set-key (kbd "M-k") 'copy-whole-line)
(bind-key* "C-x C-q" 'delete-frame)
(defalias 'exit 'save-buffers-kill-emacs)

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Dired
;;;;;;;;;;;;;;;;;;;;;;;;;;

;; dired-find-alternate-file の有効化
(put 'dired-find-alternate-file 'disabled nil)

;; ファイルなら別バッファで、ディレクトリなら同じバッファで開く
(defun dired-open-in-accordance-with-situation ()
  (interactive)
  (let ((file (dired-get-filename)))
    (if (file-directory-p file)
        (dired-find-alternate-file)
      (dired-find-file))))

;; RET 標準の dired-find-file では dired バッファが複数作られるので
;; dired-find-alternate-file を代わりに使う
(require 'dired )
(bind-keys :map dired-mode-map
           ("RET" . dired-open-in-accordance-with-situation)
           ("a" . dired-find-file))


;; Diredを使いやすくする
(ffap-bindings)

;;file名の補完で大文字小文字を区別しない
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (ace-link yaml-mode magit undo-tree iedit ## browse-kill-ring markdown-mode htmlize cask bind-key auto-complete)))
 '(read-file-name-completion-ignore-case t))

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

;; Do not create a backup file
(setq make-backup-files nil)
(setq auto-save-default nil)

;; Do not show the welcome message
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

;; バッファ自動再読み込み
(global-auto-revert-mode 1)

;; undo tree always load
(require 'undo-tree)
(global-undo-tree-mode)

;; start scratch buffer without the initial message
(setq initial-scratch-message "")

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

(bind-key* "C-c C-x" 'xclip-add-region)

(require 'multiple-cursors)
(bind-key* "C-c C-r" 'mc/mark-next-like-this)

(add-hook 'before-save-hook 'delete-trailing-whitespace) ;; 行末の空白を削除

(setq comment-style 'multi-line)

(defun xah-copy-file-path (&optional *dir-path-only-p)
  "Copy the current buffer's file path or dired path to `kill-ring'.
Argument: DIR-PATH-ONLY-P
Result is full path.
If `universal-argument' is called first, copy only the dir path.
URL `http://ergoemacs.org/emacs/emacs_copy_file_path.html'
Version 2016-07-17"
  (interactive "P")
  (let ((-fpath
         (if (equal major-mode 'dired-mode)
             (expand-file-name default-directory)
           (if (null (buffer-file-name))
               (user-error "Current buffer is not associated with a file")
             (buffer-file-name)))))
    (kill-new
     (if (null *dir-path-only-p)
         (progn
           (message "File path copied: 「%s」" -fpath)
           -fpath
           )
       (progn
         (message "Directory path copied: 「%s」" (file-name-directory -fpath))
         (file-name-directory -fpath))))))

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
;; eww
;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq eww-search-prefix "http://www.google.co.jp/search?q=")


(add-hook 'eww-mode-hook (lambda ()
                           (linum-mode -1)
                           (rename-buffer "eww" t)))

(require 'helm-eww)

(require 'ace-link)
(ace-link-setup-default)

(define-key eww-mode-map "f" 'ace-link-eww)

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Markdown
;;;;;;;;;;;;;;;;;;;;;;;;;;

(autoload 'markdown-mode "markdown-mode.el" "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; Markdown Table
(require 'org)
(defun cleanup-org-tables ()
    (save-excursion
        (goto-char (point-min))
        (while (search-forward "-+-" nil t) (replace-match "-|-"))))
(add-hook 'markdown-mode-hook 'orgtbl-mode)
(add-hook 'markdown-mode-hook
    '(lambda()
       (add-hook 'after-save-hook 'cleanup-org-tables  nil 'make-it-local)))

(require 'markdown-to-reveal)

;;;;;;;;;;;;;;;;;;;;;;;;;;
; filetype mode
;;;;;;;;;;;;;;;;;;;;;;;;;;

;; php-mode
(require 'php-mode)

;; yaml-mode
(require 'yaml-mode)

;; Flycheck
(add-hook 'after-init-hook #'global-flycheck-mode)

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[gj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(setq web-mode-engines-alist
'(("php"    . "\\.phtml\\'")
  ("blade"  . "\\.blade\\.")))

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

(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)
(global-auto-complete-mode)       ;; これで常にac-modeになる？
(add-to-list 'ac-modes 'text-mode)         ;; text-modeでも自動的に有効にする
(add-to-list 'ac-modes 'shell-script-mode)         ;; text-modeでも自動的に有効にする
(add-to-list 'ac-modes 'fundamental-mode)  ;; fundamental-mode
(add-to-list 'ac-modes 'org-mode)
(add-to-list 'ac-modes 'yatex-mode)
(add-to-list 'ac-modes 'markdown-mode)
(add-to-list 'ac-modes 'lisp-interaction-mode)

(setq ac-use-menu-map t)       ;; 補完メニュー表示時にC-n/C-pで補完候補選択

;; end of my init.el



(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(put 'upcase-region 'disabled nil)
