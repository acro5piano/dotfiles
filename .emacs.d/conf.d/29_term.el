;;;;;;;;;;;;;;;;;;;;;;;;;;
;; term
;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'term-mode-hook (lambda ()
                           (linum-mode -1)
                           (rename-buffer "term" t)))
