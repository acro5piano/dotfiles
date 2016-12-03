;;;;;;;;;;;;;;;;;;;;;;;;;;
;; eww
;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq eww-search-prefix "http://www.google.co.jp/search?q=")


(add-hook 'eww-mode-hook (lambda ()
                           (linum-mode -1)
                           (rename-buffer "eww" t)))

(ace-link-setup-default)
