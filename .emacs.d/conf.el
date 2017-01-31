;;; conf.el --- dotfiles of kazuya

;;; Commentary:

;; this is conf.el for kazuya-gosho

;;; Code:

;;; Load libraries

(require 'anzu)
(require 'auto-complete)
(require 'auto-complete-config)
(require 'coffee-mode)
(require 'color-theme)
(require 'color-theme-solarized)
(require 'expand-region)
(require 'evil)
(require 'go-mode)
(require 'haml-mode)
(require 'ido)
(require 'ido-vertical-mode)
(require 'ido-ubiquitous)
(require 'lua-mode)
(require 'migemo)
(require 'misc)
(require 'mozc)
(require 'multiple-cursors)
(require 'open-junk-file)
(require 'org)
(require 'powerline)
(require 'projectile)
(require 'rainbow-mode)
(require 'recentf)
(require 'recentf-ext)
(require 'saveplace)
(require 'scss-mode)
(require 'server)
(require 'smex)
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

(custom-set-variables '(read-file-name-completion-ignore-case t))

(defun dired-my-append-buffer-name-hint ()
  "Append a auxiliary string to a name of dired buffer."
  (when (eq major-mode 'dired-mode)
    (let* ((dir (expand-file-name list-buffers-directory)))
      (rename-buffer (concat (buffer-name) " [Dired]") t))))
(add-hook 'dired-mode-hook 'dired-my-append-buffer-name-hint)

;;; Search

(global-anzu-mode +1)
(setq anzu-use-migemo nil)
(setq anzu-search-threshold 1000)
(setq anzu-minimum-input-length 3)
(setq helm-ag-base-command "rg --vimgrep --no-heading --smart-case")

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
(setq inhibit-startup-message t)
(fset 'yes-or-no-p 'y-or-n-p)          ; (yes/no) -> (y/n)

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

(evil-mode 1)

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
(scroll-bar-mode -1)

(setq linum-format "%4d ")

;; Hilight current line
(global-hl-line-mode)
(set-face-background 'hl-line "Gray23")
(set-face-foreground 'highlight nil)
(set-cursor-color "gray")

;; カーソル位置の桁数をモードライン行に表示する
(column-number-mode 1)


;; Hilight ()
(show-paren-mode t)
(set-fontset-font t 'japanese-jisx0208
                  (font-spec :family "IPAExGothic"))

;;; ido

(ido-mode t)
(ido-everywhere t)
(ido-vertical-mode t)
(ido-ubiquitous-mode t)
(setq ido-enable-flex-matching t) ;; 中間/あいまい一致
(setq ido-vertical-define-keys 'C-n-and-C-p-only)
(setq ido-use-filename-at-point 'guess)
(defun ido-recentf-open ()
  "Use `ido-completing-read' to \\[find-file] a recent file"
  (interactive)
  (if (find-file (ido-completing-read "Find recent file: " recentf-list))
      (message "Opening file...")
    (message "Aborting")))

;;; helm
(add-hook
 'after-init-hook
 (lambda ()
   (require 'helm-projectile)
   (require 'helm-ag)
   (require 'helm-config) ; キーバインドなどを読み込む
   ))

;;; eww

(setq eww-search-prefix "http://www.google.co.jp/search?q=")

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
(add-to-list 'auto-mode-alist '("\\.vue?\\'" . web-mode))
(setq web-mode-engines-alist
'(("php"    . "\\.phtml\\'")
  ("blade"  . "\\.blade\\.")))
(setq web-mode-markup-indent-offset 2)

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
(setq ac-use-fuzzy t)             ;; 曖昧マッチ
(add-to-list 'ac-modes 'text-mode)         ;; text-modeでも自動的に有効にする
(add-to-list 'ac-modes 'shell-script-mode)
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

;;; JavaScript
(add-hook 'js-mode-hook
          (lambda ()
            (make-local-variable 'js-indent-level)
            (setq js-indent-level 2)))

;;; coffee-mode
(defun coffee-custom ()
  "coffee-mode-hook"
  (and (set (make-local-variable 'tab-width) 2)
       (set (make-local-variable 'coffee-tab-width) 2)))
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
;; (setq mozc-candidate-style 'overlay)
(setq mozc-candidate-style 'echo-area)

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
      (setq ns-use-srgb-colorspace nil)

      (color-theme-solarized)
      (powerline-default-theme)

      ;; 色文字列に色をつける rainbow-mode
      (setq rainbow-html-colors t)
      (setq rainbow-x-colors t)
      (setq rainbow-latex-colors t)
      (setq rainbow-ansi-colors t)
      (add-hook 'css-mode-hook 'rainbow-mode)
      (add-hook 'scss-mode-hook 'rainbow-mode)
      (add-hook 'web-mode-hook 'rainbow-mode)))

(if (not window-system)
    (progn

      ;; linum style
      (set-face-attribute 'linum nil
                          :foreground "#ccc"
                          :background "Gray23")))

(defalias 'exit 'save-buffers-kill-emacs)

;;; Key bindings

(keyboard-translate ?\C-h ?\C-?)
(add-hook 'after-make-frame-functions
          (lambda (f) (with-selected-frame f
                        (keyboard-translate ?\C-h ?\C-?))))

(global-set-key (kbd "C-z") 'undo)
(global-set-key (kbd "C-x C-c") nil)

(bind-keys*
 ("C-u C-s" . helm-swoop)
 ("C-u C-SPC" . helm-mark-ring)
 ("C-x g" . magit-status)
 ("C-x j" . open-junk-file)
 ("C-x o" . other-window)
 ("C-x C-o" . other-window)
 ("C-c m a" . mc/mark-all-dwim)
 ("C-c m l" . mc/edit-lines)
 ("C-c m s" . mc/mark-all-words-like-this)
 ("C-c C-x" . xclip-add-region)
 ("C-x f" . ido-find-file))

(if (evil-mode)
    (progn
      (bind-keys :map evil-visual-state-map
                 ("TAB" . indent-for-tab-command))
      (bind-keys :map evil-normal-state-map
                 ("SPC b" . ido-switch-buffer)
                 ("SPC f" . projectile-find-file)
                 ("SPC a" . helm-do-ag-project-root)
                 ("SPC x" . smex)
                 ("SPC s" . save-buffer)
                 ("SPC d" . dired-jump)
                 ("SPC k" . kill-this-buffer)
                 ("SPC r" . ido-recentf-open)
                 ("SPC 1" . delete-other-windows)
                 ("SPC 0" . delete-window)
                 ("SPC q" . delete-frame)
                 ("SPC t" . xref-find-definitions-other-window)
                 ("SPC y" . browse-kill-ring)
                 ("SPC u" . undo-tree)
                 ("TAB" . indent-for-tab-command))
      (bind-keys :map evil-insert-state-map
                 ("C-g" . evil-normal-state)))
  (progn
      (bind-keys*
       ("C-u C-j" . dired-jump-other-window)
       ("C-u C-SPC" . helm-mark-ring)
       ("C-x C-q" . delete-frame)
       ("C-x C-k" . kill-this-buffer)
       ("C-x k" . kill-this-buffer)
       ("C-x C-j" . dired-jump)
       ("C-x p" . helm-do-ag-project-root)
       ("C-x C-r" . ido-recentf-open)
       ("C-c C-." . er/expand-region)
       ("M-." . xref-find-definitions-other-window)
       ("M-g" . goto-line)
       ("M-j" . join-line)
       ("M-x" . smex)
       ("M-y" . browse-kill-ring)
       ("M-z" . zap-up-to-char))))


(if window-system
    (progn
      (bind-keys :map mozc-mode-map
                 ("q" . mozc-end)
                 ("C-g" . mozc-end)
                 ("C-x h" . mark-whole-buffer)
                 ("C-x C-s" . save-buffer))
      (bind-keys*
       ("<henkan>" . mozc-start)
       ("C-+" . text-scale-increase)
       ("C--" . text-scale-decrease)
       ("C-M-h" . ido-delete-backward-word-updir)
       ("M-%" . anzu-query-replace)
       ("C-M-%" . anzu-query-replace-regexp))))

;;; Set UTF-8 to default

(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
;;(setq default-buffer-file-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8)
(setq coding-system-for-read 'utf-8)
(setq coding-system-for-write 'utf-8)

(provide 'conf)

;;; conf.el ends here
