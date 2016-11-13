;;;;;;;;;;;;;;;;;;;;;;;;;;
;; for ctags.el
;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq tags-revert-without-query t)
(setq ctags-command "ctags -R --fields=\"+afikKlmnsSzt\" ")
(global-set-key (kbd "<f5>") 'ctags-create-or-update-tags-table)
(global-set-key (kbd "M-.") 'ctags-search)
