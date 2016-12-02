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


;; Set init-loader
(require 'init-loader)
(init-loader-load "~/.emacs.d/conf.d")

;; end of my init.el

(put 'upcase-region 'disabled nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(desktop-save-mode t)
 '(package-selected-packages
   (quote
    (find-file-in-project ido-ubiquitous smex ido-vertical-mode helm-swoop rainbow-mode dashboard color-theme-modern color-theme-solarized color-theme chatwork summarye haml-mode lua-mode twittering-mode ace-link yaml-mode magit undo-tree iedit ## browse-kill-ring markdown-mode htmlize cask bind-key auto-complete)))
 '(read-file-name-completion-ignore-case t))
(put 'downcase-region 'disabled nil)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#002b36" :foreground "#839496" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 105 :width normal :foundry "Source Code Pro" :family "Source Code Pro"))))
 '(helm-selection ((t (:background "Gray23" :distant-foreground "black")))))
