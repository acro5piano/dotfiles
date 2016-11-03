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

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(put 'upcase-region 'disabled nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(desktop-save-mode t)
 '(package-selected-packages
   (quote
    (haml-mode twittering-mode ace-link yaml-mode magit undo-tree iedit ## browse-kill-ring markdown-mode htmlize cask bind-key auto-complete)))
 '(read-file-name-completion-ignore-case t))
(put 'downcase-region 'disabled nil)
