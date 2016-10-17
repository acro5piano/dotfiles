;; helm
(bind-key* "M-x" 'helm-M-x)
(bind-key* "C-x C-d" 'helm-find-files)

(add-hook
 'after-init-hook
 (lambda ()
   (require 'helm-config)
   (require 'helm-ag)
   (helm-mode 1)))
