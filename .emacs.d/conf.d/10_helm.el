;; helm
(add-hook
 'after-init-hook
 (lambda ()
   (require 'helm-config)
   (require 'helm-ag)))


(setq recentf-max-saved-items 1000)
