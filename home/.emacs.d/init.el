(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(setq inhibit-startup-message t)
(keyboard-translate ?\C-h ?\C-?)
(define-key key-translation-map (kbd "C-h") (kbd "<DEL>"))

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'helm)
(straight-use-package 'evil)
(straight-use-package 'spaceline)
(straight-use-package 'helm-swoop)
(straight-use-package 'monokai-theme)

(evil-mode t)
(helm-mode t)

(setq monokai-background "#000000")
(load-theme 'monokai t)

(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "M-b") 'helm-mini)
(global-set-key (kbd "M-s") 'save-buffer)
(global-set-key (kbd "C-s") 'helm-swoop)
(global-set-key (kbd "M-w") 'helm-resume)

(require 'spaceline-config)
(spaceline-emacs-theme)
(spaceline-helm-mode t)
(setq spaceline-highlight-face-func 'spaceline-highlight-face-evil-state)
