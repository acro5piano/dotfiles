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

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; File
;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Do not create backup file
(setq make-backup-files nil)
(setq auto-save-default nil)

;; Do not show welcome message
(setq inhibit-startup-message t)

; save command history
(setq desktop-globals-to-save '(extended-command-history))
(setq desktop-files-not-to-save "")
(desktop-save-mode 1)

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
;(custom-set-faces
;  '(default ((t
;               (:foreground "#55FF55")
;               ))))
;'(cursor ((((class color)
;            (background dark))
;           (:background "#00AA00"))
;          (((class color)
;            (background light))
;           (:background "#999999"))
;          (t ())
;          ))
;


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
; Livedown markdown preview with browser
;;;;;;;;;;;;;;;;;;;;;;;;;;

; (require 'livedown)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (browse-kill-ring markdown-mode htmlize cask bind-key auto-complete))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
