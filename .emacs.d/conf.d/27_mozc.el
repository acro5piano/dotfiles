;; Mozc settings
(require 'mozc)
(set-language-environment "Japanese")
(setq default-input-method "japanese-mozc")

(add-hook 'helm-mini (lambda()
                       (mozc-mode -1)))
(add-hook 'helm-M-x (lambda()
                      (mozc-mode -1)))

(defun mozc-start()
  (interactive)
  (set-cursor-color "blue")
  (message "Mozc start")
  (mozc-mode 1))

(defun mozc-end()
  (interactive)
  (set-cursor-color "black")
  (mozc-mode -1))
