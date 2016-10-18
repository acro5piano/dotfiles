;; helm
(bind-key* "M-x" 'helm-M-x)

(add-hook
 'after-init-hook
 (lambda ()
   (require 'helm-config)
   (require 'helm-ag)))
