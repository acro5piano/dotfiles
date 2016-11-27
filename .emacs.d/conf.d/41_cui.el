;; for GUI settings
(if (not window-system)
    (progn
      ;; anzu
      (bind-key* "C-]" 'anzu-query-replace)   ;; C-5 compatible
      (bind-key* "M-5" 'anzu-query-replace-regexp)

      ;; linum style
      (set-face-attribute 'linum nil
                          :foreground "#ccc"
                          :background "Gray23")

      (custom-set-faces
       ;; custom-set-faces was added by Custom.
       ;; If you edit it by hand, you could mess it up, so be careful.
       ;; Your init file should contain only one such instance.
       ;; If there is more than one, they won't work right.
       '(helm-selection ((t (:background "magenta" :distant-foreground "black")))))

      ))
