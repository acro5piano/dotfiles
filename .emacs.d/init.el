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

(custom-set-variables
 '(package-selected-packages
   (quote
    (git-gutter
     goto-chg
     counsel
     ivy
     ido-ubiquitous
     smex
     ido-vertical-mode
     helm-swoop
     rainbow-mode
     dashboard
     color-theme-modern
     color-theme-solarized
     color-theme
     chatwork
     summarye
     haml-mode
     lua-mode
     twittering-mode
     ace-link
     yaml-mode
     magit
     undo-tree
     browse-kill-ring
     markdown-mode
     htmlize
     cask
     bind-key
     auto-complete))))

;; end of my init.el
