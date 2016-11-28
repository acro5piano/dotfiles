(add-hook 'before-save-hook 'delete-trailing-whitespace) ;; 行末の空白を削除
(add-hook 'after-init-hook #'global-flycheck-mode)

(add-hook 'js-mode-hook
          (lambda ()
            (make-local-variable 'js-indent-level)
            (setq js-indent-level 2)))
