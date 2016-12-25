;;; init.el --- dotfiles of kazuya

;;; Commentary:

;; this is init.el for kazuya-gosho

;;; Code:

;;; Basic path and Cask

(package-initialize)

(require 'cask "~/.cask/cask.el")
(cask-initialize)

;; Add path for my elisps
(add-to-list 'load-path "~/.emacs.d/lisp")

;; Load init-loader (disabled)
;; (require 'init-loader)
;; (init-loader-load "~/.emacs.d/conf.d")

;;; Load libraries

(require 'ace-link)
(require 'anzu)
(require 'auto-complete)
(require 'auto-complete-config)
(require 'chatwork)
(require 'coffee-mode)
(require 'color-theme)
(require 'color-theme-solarized)
(require 'counsel)
(require 'expand-region)
(require 'go-mode)
(require 'haml-mode)
(require 'ido)
(require 'ivy)
(require 'lua-mode)
(require 'migemo)
(require 'misc)
(require 'mozc)
(require 'multiple-cursors)
(require 'open-junk-file)
(require 'org)
(require 'powerline)
(require 'rainbow-mode)
(require 'recentf)
(require 'recentf-ext)
(require 'saveplace nil t)
(require 'scss-mode)
(require 'server)
(require 'summarye)
(require 'typescript-mode)
(require 'twittering-mode)
(require 'undo-tree)
(require 'web-mode)
(require 'yaml-mode)

;;; Dired

;; dired-find-alternate-file の有効化
(put 'dired-find-alternate-file 'disabled nil)

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
    (term+key-intercept term+ typescript-mode yaml-mode websocket web-mode undo-tree twittering-mode summarye smex smartrep scss-mode request recentf-ext rainbow-mode powerline php-mode open-junk-file multiple-cursors mozc migemo markdown-mode magit lua-mode js2-mode init-loader iedit ido-vertical-mode ido-ubiquitous htmlize helm-swoop helm-ghq helm-ag haml-mode goto-chg go-mode git-gutter flycheck find-file-in-project expand-region editorconfig dashboard ctags-update ctags counsel company color-theme-solarized coffee-mode chatwork cask browse-kill-ring bind-key auto-complete anzu ace-link)))
 '(read-file-name-completion-ignore-case t))

;;; Search

(global-anzu-mode +1)
(setq anzu-use-migemo nil)
(setq anzu-search-threshold 1000)
(setq anzu-minimum-input-length 3)

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

;;; File

(setq recentf-max-saved-items 1000)
(setq make-backup-files nil)
(setq auto-save-default nil)
(desktop-save-mode t)
(setq inhibit-startup-message t)

;; Auto start server
(unless (server-running-p)
  (server-start))


;; シンボリックリンクの読み込み時に確認しない
(setq vc-follow-symlinks t)

;; シンボリックリンク先のVCS内で更新が入った場合にバッファを自動更新
(setq auto-revert-check-vc-info t)

(setq ruby-insert-encoding-magic-comment nil)
(setq initial-scratch-message "")
(setq open-junk-file-format "~/tmp/%Y-%m-%d-%H%M%S.")
(setq open-junk-file-find-file-function 'find-file)

(global-auto-revert-mode 1)
(global-undo-tree-mode)

;;; Edit

(add-hook 'before-save-hook 'delete-trailing-whitespace) ;; 行末の空白を削除
(add-hook 'after-init-hook #'global-flycheck-mode)
(put 'narrow-to-region 'disabled nil)
(editorconfig-mode 1)

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
        (shell-command "xsel -ib < /tmp/clipboard")
        (message "%s" (shell-command-to-string "cat /tmp/clipboard")))
    (progn
      (message "no region"))))

(defun my/copy-file-path (&optional *dir-path-only-p)
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

;;; Face

(tool-bar-mode -1)
(menu-bar-mode -1)
(global-linum-mode t)
(setq linum-format "%4d ")

;; Hilight current line
(global-hl-line-mode)
(set-face-background 'hl-line "Gray23")
(set-face-foreground 'highlight nil)

;; カーソル位置の桁数をモードライン行に表示する
(column-number-mode 1)

(scroll-bar-mode 1)

(set-cursor-color "gray")

;; Hilight ()
(show-paren-mode t)

(display-time-mode)

;; font, font-size, etc
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 105 :width normal :foundry "Source Code Pro" :family "Source Code Pro"))))
 '(helm-selection ((t (:background "Gray23" :distant-foreground "black")))))

(set-fontset-font t 'japanese-jisx0208
                  (font-spec :family "IPAExGothic"))


;;; ctags

(setq tags-revert-without-query t)
;;(setq ctags-command "ctags -R --fields=\"+afikKlmnsSzt\" ")

;;; helm
(add-hook
 'after-init-hook
 (lambda ()
   (require 'helm-config)
   ))

(fset 'yes-or-no-p 'y-or-n-p)          ; (yes/no) -> (y/n)

(ivy-mode 1)
(setq ivy-use-virtual-buffers t)

;;; eww

(setq eww-search-prefix "http://www.google.co.jp/search?q=")


(add-hook 'eww-mode-hook (lambda ()
                           (linum-mode -1)
                           (rename-buffer "eww" t)))
(ace-link-setup-default)

;;; term+

(require 'term+)
(require 'xterm-256color)
(require 'term+key-intercept)

;;; Markdown

(autoload 'markdown-mode "markdown-mode.el" "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; Markdown Table
(defun cleanup-org-tables ()
    (save-excursion
        (goto-char (point-min))
        (while (search-forward "-+-" nil t) (replace-match "-|-"))))
(add-hook 'markdown-mode-hook 'orgtbl-mode)
(add-hook 'markdown-mode-hook
    '(lambda()
       (add-hook 'before-save-hook 'cleanup-org-tables  nil 'make-it-local)))

;;; Web mode
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[gj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(setq web-mode-engines-alist
'(("php"    . "\\.phtml\\'")
  ("blade"  . "\\.blade\\.")))


(defun strip-html (start end)
  "Strip html with regular expression between region START and END."
  (interactive "r")
  (save-excursion
    (save-restriction
      (narrow-to-region start end)
      (goto-char (point-min))
      (while (re-search-forward "<.+?>" nil t)
        (replace-match "")))))

;;; auto-complete

(ac-config-default)
(global-auto-complete-mode)       ;; これで常にac-modeになる？
(add-to-list 'ac-modes 'text-mode)         ;; text-modeでも自動的に有効にする
(add-to-list 'ac-modes 'shell-script-mode)         ;; text-modeでも自動的に有効にする
(add-to-list 'ac-modes 'org-mode)
(add-to-list 'ac-modes 'yatex-mode)
(add-to-list 'ac-modes 'markdown-mode)
(add-to-list 'ac-modes 'lisp-interaction-mode)
(add-to-list 'ac-modes 'sql-mode)
(add-to-list 'ac-modes 'lisp-mode)
(add-to-list 'ac-modes 'ruby-mode)
(add-to-list 'ac-modes 'web-mode)
(add-to-list 'ac-modes 'haml-mode)
(add-to-list 'ac-modes 'ruby-mode)

(setq ac-use-menu-map t)       ;; 補完メニュー表示時にC-n/C-pで補完候補選択

;;; scss-mode

(add-to-list 'auto-mode-alist '("\\.scss$" . scss-mode))

;; インデント幅を2にする
;; コンパイルは gulpなどで行うので、自動コンパイルをオフ

(defun scss-custom ()
  "Set scss-mode-hook."
  (and
   (set (make-local-variable 'css-indent-offset) 2)
   (set (make-local-variable 'scss-compile-at-save) nil)))
(add-hook 'scss-mode-hook
          '(lambda() (scss-custom)))

;;; twittering-mode

;; 起動時パスワード認証 *要 gpgコマンド
(setq twittering-use-master-password t)
;; パスワード暗号ファイル保存先変更 (デフォはホームディレクトリ)
(setq twittering-private-info-file "~/.emacs.d/twittering-mode.gpg")
(defun coffee-custom ()
  "coffee-mode-hook"
  (and (set (make-local-variable 'tab-width) 2)
       (set (make-local-variable 'coffee-tab-width) 2)))

;;; coffee-mode
(add-hook 'coffee-mode-hook
          '(lambda() (coffee-custom)))

;;; migemo
(setq migemo-command "cmigemo")
(setq migemo-options '("-q" "--emacs"))
(setq migemo-dictionary "/usr/share/migemo/utf-8/migemo-dict")
(setq migemo-user-dictionary nil)
(setq migemo-regex-dictionary nil)
(setq migemo-coding-system 'utf-8-unix)
(load-library "migemo")
(migemo-init)

;;; Mozc settings
(set-language-environment "Japanese")
(setq default-input-method "japanese-mozc")
(setq mozc-candidate-style 'overlay)

(defun mozc-start()
  (interactive)
  (set-cursor-color "blue")
  (message "Mozc start")
  (mozc-mode 1))

(defun mozc-end()
  (interactive)
  (set-cursor-color "gray")
  (message "Mozc end")
  (mozc-mode -1))

;;; go-mode
(add-hook 'before-save-hook 'gofmt-before-save)

;;; GUI only settings
(if window-system
    (progn

      (bind-key* "C-M-h" 'ido-delete-backward-word-updir)
      (bind-key* "M-%" 'anzu-query-replace)
      (bind-key* "C-M-%" 'anzu-query-replace-regexp)

      (setq ns-use-srgb-colorspace nil)

      ;; (defun eww-disable-images ()
      ;;   "ewwで画像表示させない"
      ;;   (interactive)
      ;;   (setq-local shr-put-image-function 'shr-put-image-alt)
      ;;   (eww-reload))
      ;;   (setq-local shr-put-image-function 'shr-put-image)
      ;;   (eww-reload))
      ;; (defun shr-put-image-alt (spec alt &optional flags)
      ;;   (insert alt))
      ;; (defun eww-mode-hook--disable-image ()
      ;;   (setq-local shr-put-image-function 'shr-put-image-alt))
      ;; (add-hook 'eww-mode-hook 'eww-mode-hook--disable-image)

      ;; テーマやPowerlineを有効化すると、CUIでEmacsが使い物にならなくなる
      ;; そのため、CUIではVimを使うこと

      (set-face-attribute 'mode-line nil
                          :foreground "#FFF"
                          :background "#4B0082")

      (set-face-attribute 'powerline-active1 nil
                          :foreground "#fff"
                          :background "#006400"
                          :inherit 'mode-line)

      (set-face-attribute 'powerline-active2 nil
                          :foreground "#000"
                          :background "#FFF"
                          :inherit 'mode-line)

      (powerline-default-theme)

      ;; これ有効にすると、powerlineと競合してうまく動作しない
      ;;(color-theme-solarized)

      (powerline-default-theme)

      ;; 色文字列に色をつける rainbow-mode
      (setq rainbow-html-colors t)
      (setq rainbow-x-colors t)
      (setq rainbow-latex-colors t)
      (setq rainbow-ansi-colors t)
      (add-hook 'css-mode-hook 'rainbow-mode)
      (add-hook 'scss-mode-hook 'rainbow-mode)
      (add-hook 'php-mode-hook 'rainbow-mode)
      (add-hook 'html-mode-hook 'rainbow-mode)))

;;; CUI only settings
(if (not window-system)
    (progn
      ;; anzu
      (bind-key* "C-]" 'anzu-query-replace)   ;; C-5 compatible
      (bind-key* "M-5" 'anzu-query-replace-regexp)

      ;; linum style
      (set-face-attribute 'linum nil
                          :foreground "#ccc"
                          :background "Gray23")))

;;; JavaScript
(add-hook 'js-mode-hook
          (lambda ()
            (make-local-variable 'js-indent-level)
            (setq js-indent-level 2)))

;;; others
(defun reopen-with-sudo ()
  "Reopen current buffer-file with sudo using tramp."
  (interactive)
  (let ((file-name (buffer-file-name)))
    (if file-name
        (find-alternate-file (concat "/sudo::" file-name))
      (error "Cannot get a file name"))))

;;; Key bindings

(keyboard-translate ?\C-h ?\C-?)
(add-hook 'after-make-frame-functions
          (lambda (f) (with-selected-frame f
                        (keyboard-translate ?\C-h ?\C-?)
                        )))

(defalias 'exit 'save-buffers-kill-emacs)

(progn
  (bind-key "C-x C-k" 'kill-this-buffer)
  (bind-key "C-x k" 'kill-this-buffer)
  (bind-key* "C-x C-j" 'dired-jump)
  (bind-key* "C-u C-x C-j" 'dired-jump-other-window)
  (bind-key* "C-x C-o" 'other-window)
  (bind-key* "C-x o" 'other-window)
  (bind-key* "C-u C-f" 'other-frame)
  (bind-key "C-x C-c" 'nil)
  (bind-key "C-z" 'nil)
  (bind-key* "C-x C-q" 'delete-frame)
  (bind-key* "M-g" 'goto-line)
  (bind-key "M-z" 'zap-up-to-char)
  (bind-key "C-c ." 'er/expand-region)
  (bind-key "M-j" 'join-line)
  (bind-key* "<menu>" 'mozc-start)
  (bind-key* "<henkan>" 'mozc-start)
  (bind-key "q" 'mozc-end mozc-mode-map)
  (bind-key "C-g" 'mozc-end mozc-mode-map)
  (bind-key "C-x h" 'mark-whole-buffer mozc-mode-map)
  (bind-key "C-x C-s" 'save-buffer mozc-mode-map)
  (bind-key* "C-x g" 'magit-status)
  (bind-key "M-y" 'browse-kill-ring)
  (bind-key* "C-x b" 'helm-mini)
  (bind-key* "C-x C-b" 'helm-mini)
  (bind-key* "M-x" 'helm-M-x)
  (bind-key* "C-x p" 'helm-grep-do-git-grep)
  (bind-key* "C-u C-s" 'helm-swoop)
  (bind-key* "C-u C-SPC" 'helm-mark-ring)
  ;;(bind-key* "C-x b" 'ivy-switch-buffer)
  ;;(bind-key* "C-x C-b" 'ivy-switch-buffer)
  ;;(bind-key* "M-x" 'counsel-M-x)
  (bind-key* "C-u C-f" 'counsel-git)
  ;;(bind-key* "C-u C-s" 'swiper)
  (bind-key* "C-x c i" 'ivy-resume)
  (bind-key* "C-x f" 'counsel-find-file)
  ;;(bind-key* "C-x p" 'counsel-git-grep)
  ;;(bind-key* "C-x C-r" 'counsel-recentf)
  (bind-key* "C-c C-r" 'mc/edit-lines)
  (bind-key "C-x j" 'open-junk-file)
  (bind-key "C-c 0" 'org-shiftright org-mode-map)
  (bind-key* "M-." 'xref-find-definitions-other-window)
  ;; (bind-key* "M-." 'ctags-search)
  )

;;; Set UTF-8 to default

(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8)
(setq coding-system-for-read 'utf-8)
(setq coding-system-for-write 'utf-8)

(provide 'init)

;;; init.el ends here
