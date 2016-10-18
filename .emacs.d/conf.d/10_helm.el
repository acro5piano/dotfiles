;; helm
(add-hook
 'after-init-hook
 (lambda ()
   (require 'helm-config)
   (require 'helm-ag)))
