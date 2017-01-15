;;; init.el --- dotfiles of kazuya

;;; Commentary:

;; this is init.el for kazuya-gosho

;;; Code:

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)
(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
        ("melpa" . "http://melpa.org/packages/")
        ("org" . "http://orgmode.org/elpa/")))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (ripgrep helm-projectile helm-ag-r icicles projectile typescript-mode yaml-mode websocket web-mode undo-tree twittering-mode summarye smex smartrep scss-mode request recentf-ext rainbow-mode powerline php-mode open-junk-file multiple-cursors mozc migemo markdown-mode magit lua-mode js2-mode init-loader iedit ido-vertical-mode ido-ubiquitous htmlize helm-swoop helm-ghq helm-ag haml-mode goto-chg go-mode flycheck find-file-in-project expand-region editorconfig dashboard ctags-update ctags company color-theme-solarized coffee-mode chatwork cask browse-kill-ring bind-key auto-complete anzu ace-link)))
 '(read-file-name-completion-ignore-case t))

;; font, font-size, etc
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 105 :width normal :foundry "Source Code Pro" :family "Source Code Pro")))))

(require 'cask "~/.cask/cask.el")
(cask-initialize)

(add-to-list 'load-path "~/.emacs.d/lisp")
;;(load "~/.emacs.d/conf.el")
(load "~/.emacs.d/terminal.el")


;;; init.el ends here
