(add-hook 'before-save-hook 'delete-trailing-whitespace) ;; 行末の空白を削除
(add-hook 'after-init-hook #'global-flycheck-mode)
