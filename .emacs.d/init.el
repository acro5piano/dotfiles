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
; Prelude
;;;;;;;;;;;;;;;;;;;;;;;;;;

;(load-file "~/.emacs.d/prelude/init.el")

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Key settings
;;;;;;;;;;;;;;;;;;;;;;;;;;

(keyboard-translate ?\C-h ?\C-?)
(setq kill-whole-line t)
(global-set-key "\C-x\C-b" 'buffer-menu)
(global-set-key (kbd "M-y") 'browse-kill-ring)

;; I never use C-x C-c
(global-set-key (kbd "C-x C-c") 'helm-M-x)
(global-set-key (kbd "C-x C-q") 'save-buffers-kill-emacs)

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; File
;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Do not create backup file
(setq make-backup-files nil)
(setq auto-save-default nil)

;; Do not show welcome message
(setq inhibit-startup-message t)

; save command history
;(setq desktop-globals-to-save '(extended-command-history))
;(setq desktop-files-not-to-save "")
;(desktop-save-mode 1)

; do not insert magic comments
(setq ruby-insert-encoding-magic-comment nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Edit
;;;;;;;;;;;;;;;;;;;;;;;;;;

; Not use auto indent
(setq-default indent-tabs-mode nil)
(electric-indent-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; View
;;;;;;;;;;;;;;;;;;;;;;;;;;

; Don't show tool-bar and menu-bar
(tool-bar-mode -1)
(menu-bar-mode -1)

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org mode
;;;;;;;;;;;;;;;;;;;;;;;;;;

(bind-key* "C-c C-o"
        (interactive)
        (org-mode))

(setq org-src-fontify-natively t)

; Start with org-mode
(add-hook 'after-init-hook
    (lambda()
        (interactive)
        (org-mode)))

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
; X server integration
;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq x-select-enable-clipboard t)
(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)

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
    (## browse-kill-ring markdown-mode htmlize cask bind-key auto-complete))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

