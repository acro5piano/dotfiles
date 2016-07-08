;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Package.el
;;;;;;;;;;;;;;;;;;;;;;;;;;


(require 'cask "~/.cask/cask.el")
(cask-initialize)

; Add path for elisp from not MELPA
(add-to-list 'load-path "~/.emacs.d/lisp")

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Markdown
;;;;;;;;;;;;;;;;;;;;;;;;;;

; Qiita markdown
(require 'ox-qmd)
(autoload 'markdown-mode "markdown-mode.el" "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

; Markdown Table
(defun cleanup-org-tables ()
    (save-excursion
        (goto-char (point-min))
        (while (search-forward "-+-" nil t) (replace-match "-|-"))))
(add-hook 'markdown-mode-hook 'orgtbl-mode)
(add-hook 'markdown-mode-hook
    #'(lambda()
        (add-hook 'after-save-hook 'cleanup-org-tables  nil 'make-it-local)))

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Key settings
;;;;;;;;;;;;;;;;;;;;;;;;;;

(keyboard-translate ?\C-h ?\C-?)


;;;;;;;;;;;;;;;;;;;;;;;;;;
;; File
;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Do not create backup file
(setq make-backup-files nil)
(setq auto-save-default nil)

;; Do not show welcome message
(setq inhibit-startup-message t)

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Edit
;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq kill-whole-line t)

(require 'auto-complete)
(global-auto-complete-mode t)

; Not use auto indent
(setq-default indent-tabs-mode nil)
(electric-indent-mode 0)



;;;;;;;;;;;;;;;;;;;;;;;;;;
;; View settings
;;;;;;;;;;;;;;;;;;;;;;;;;;
;(line-number-mode 1)

;; Hilight ()
;(show-paren-mode 1)
;(setq show-paren-style 'mixed)
;(set-face-background 'show-paren-match-face "grey")
;(set-face-foreground 'show-paren-match-face "black")

; Don't show tool-bar and menu-bar
(tool-bar-mode -1)
(menu-bar-mode -1)

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Other tools
;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'org)

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Japanese input using Mozc
;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'mozc)
(set-language-environment "Japanese")
(setq default-input-method "japanese-mozc")

(require 'mozc-popup)
(setq mozc-candidate-style 'popup) ; select popup style.

;; Change IME ON/OFF key
(bind-key* "C-j"
    (lambda()
        (interactive)
        (if current-input-method (inactivate-input-method))
            (toggle-input-method)))
(bind-key* "C-g"
    (lambda()
        (interactive)
        (inactivate-input-method)
        (keyboard-quit)))

;;;;;;;;;;;;;;;;;;;;;;;;;;
; ac-mozc
;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'ac-mozc)
(define-key ac-mode-map (kbd "C-c C-SPC") 'ac-complete-mozc)

(add-to-list 'ac-modes 'org-mode)

(defun my-ac-mozc-setup ()
    (setq ac-sources
        '(ac-source-mozc ac-source-ascii-words-in-same-mode-buffers))
    (set (make-local-variable 'ac-auto-show-menu) 0.2)
    (bind-key* "C-n" (ac-next)))

(add-hook 'org-mode-hook 'my-ac-mozc-setup)

;;;;;;;;;;;;;;;;;;;;;;;;;;
; Edit-server
;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'edit-server)
(edit-server-start)

;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set UTF-8 to default
;;;;;;;;;;;;;;;;;;;;;;;;;;

(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)


(setq x-select-enable-clipboard t)
(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)

