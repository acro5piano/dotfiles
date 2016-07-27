;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Basic path and Cask
;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'cask "~/.cask/cask.el")
(cask-initialize)

; Add path for elisp from not MELPA
(add-to-list 'load-path "~/.emacs.d/lisp")

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Key settings
;;;;;;;;;;;;;;;;;;;;;;;;;;

(keyboard-translate ?\C-h ?\C-?)
(setq kill-whole-line t)

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

; Not use auto indent
(setq-default indent-tabs-mode nil)
(electric-indent-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; View
;;;;;;;;;;;;;;;;;;;;;;;;;;

; Don't show tool-bar and menu-bar
(tool-bar-mode -1)
(menu-bar-mode -1)
(custom-set-faces
  '(default ((t
               (:background "black" :foreground "#55FF55")
               ))))
'(cursor ((((class color)
            (background dark))
           (:background "#00AA00"))
          (((class color)
            (background light))
           (:background "#999999"))
          (t ())
          ))



;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org mode
;;;;;;;;;;;;;;;;;;;;;;;;;;

(bind-key* "C-c C-o"
        (interactive)
        (org-mode))

(add-hook 'after-init-hook
    (lambda()
        (interactive)
        (org-mode)))


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
    '(lambda()
        (add-hook 'after-save-hook 'cleanup-org-tables  nil 'make-it-local)))

(bind-key* "C-c C-d"
        (interactive)
        (markdown-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Japanese input using Mozc
;;;;;;;;;;;;;;;;;;;;;;;;;;

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
; Set UTF-8 to default
;;;;;;;;;;;;;;;;;;;;;;;;;;

(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)

;;;;;;;;;;;;;;;;;;;;;;;;;;
; X server integration
;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq x-select-enable-clipboard t)
(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)

;;;;;;;;;;;;;;;;;;;;;;;;;;
; Prelude
;;;;;;;;;;;;;;;;;;;;;;;;;;

(load-file "~/.emacs.d/prelude/init.el")


