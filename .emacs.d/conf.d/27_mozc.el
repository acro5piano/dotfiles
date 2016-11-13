;; Mozc settings
(require 'mozc)
(set-language-environment "Japanese")
(setq default-input-method "japanese-mozc")
(bind-key* "C-."
           (lambda()
             (interactive)
             (mozc-mode 1)))
(bind-keys* :map 'mozc-mode-map
            ("C-," .
             (lambda()
               (interactive)
               (mozc-mode -1))))

(add-hook 'helm-mini (lambda()
                       (mozc-mode -1)))
(add-hook 'helm-M-x (lambda()
                      (mozc-mode -1)))
