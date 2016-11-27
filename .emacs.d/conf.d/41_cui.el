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
      ))
