(defvar senny-temporary-file-directory (expand-file-name "~/.emacs.d/tmp"))

; basic configurations
(save-place-mode t)
(menu-bar-mode -1)
(electric-indent-mode 1)
(setq kill-whole-line t)
(setq-default indent-tabs-mode nil)
(defalias 'yes-or-no-p 'y-or-n-p)
(ffap-bindings)

(require 'dired)

; Bootstrap packages
(package-initialize)

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-and-compile
  (add-to-list 'load-path (expand-file-name "vendor" user-emacs-directory)))

(use-package helm
  :ensure t
  :bind (("M-x" . helm-M-x)
         ("M-y" . helm-show-kill-ring)
         ("C-x C-n" . helm-resume)
         ("C-x C-b" . helm-buffers-list))
  :config (progn
	    (setq helm-buffers-fuzzy-matching t)
	    (setq helm-recentf-fuzzy-match t)
	    (setq helm-M-x-fuzzy-match t)
            (set-face-attribute 'helm-selection nil
                                :background "purple"
                                :foreground "black")
            (helm-mode 1)))

(use-package helm-swoop
  :ensure t
  :bind (("C-x C-l" . helm-swoop)))

(use-package helm-rg
  :ensure t
  :bind (("M-s" . helm-rg)))

(use-package evil
  :init
  :ensure t
  :config (progn
            (evil-mode)))

(use-package helm-projectile
  :ensure t
  :bind (("C-x C-p" . helm-projectile-find-file)))

(use-package typescript-mode
  :mode "\\.tsx?\\'"
  :ensure t
  :init (progn
          (lsp)))

(use-package auto-complete
  :ensure t
  :config (progn
            (global-auto-complete-mode)
            (add-to-list 'ac-modes 'text-mode)
            (add-to-list 'ac-modes 'typescript-mode)
            (setq ac-use-menu-map t)
            (ac-config-default)))

(use-package lsp-mode
  :ensure t
  :bind (("C-c C-j" . lsp-goto-type-definition))
  :config (progn
            (add-hook 'typescript-mode-hook #'lsp)))

(use-package editorconfig
  :ensure t
  :config (editorconfig-mode 1))

; Keyboard settings

(keyboard-translate ?\C-h ?\C-?)
(add-hook 'after-make-frame-functions
          (lambda (f) (with-selected-frame f
                        (keyboard-translate ?\C-h ?\C-?))))

(defalias 'evil-insert-state 'evil-emacs-state)
(bind-keys :map evil-visual-state-map
           ("TAB" . indent-for-tab-command))
(define-key evil-emacs-state-map (kbd "C-g") 'evil-normal-state)
(define-key evil-emacs-state-map (kbd "C-x C-o") 'completion-at-point)
(bind-keys*
 ("C-u" . undo)
 ("C-x C-k" . kill-this-buffer)
 ("C-x C-j" . dired-jump))
(bind-keys :map evil-insert-state-map
           ("C-g" evil-normal-state)
           ("C-x C-o" completion-at-point))
(bind-keys :map evil-normal-state-map
           ("SPC b b" . helm-buffers-list)
           ("SPC g f" . helm-projectile)
           ("SPC s a a" . helm-do-ag-project-root)
           ("SPC SPC" . helm-M-x)
           ("SPC f s" . save-buffer)
           ("SPC j d" . dired-jump)
           ("SPC b d" . kill-this-buffer)
           ("SPC w m" . delete-other-windows)
           ("SPC w d" . delete-window)
           ("SPC q q" . delete-frame)
           ("SPC t" . xref-find-definitions-other-window)
           ("SPC y" . browse-kill-ring)
           ("SPC u" . undo-tree)
           ("TAB" . indent-for-tab-command))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (lsp-mode helm-swoop auto-complete helm-projectile helm-rg helm use-package popup helm-core))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
