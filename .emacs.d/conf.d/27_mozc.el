;; Mozc settings
(require 'mozc)
(set-language-environment "Japanese")
(setq default-input-method "japanese-mozc")

(setq mozc-candidate-style 'overlay)

(defun mozc-start()
  (interactive)
  (set-cursor-color "blue")
  (message "Mozc start")
  (mozc-mode 1))

(defun mozc-end()
  (interactive)
  (set-cursor-color "gray")
  (message "Mozc end")
  (mozc-mode -1))
