;;;;;;;;;;;;;;;;;;;;;;;;;;
;; eww
;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq eww-search-prefix "http://www.google.co.jp/search?q=")


(add-hook 'eww-mode-hook (lambda ()
                           (linum-mode -1)
                           (rename-buffer "eww" t)))

(ace-link-setup-default)
(define-key eww-mode-map "f" 'ace-link-eww)

(defun eww-disable-images ()
  "ewwで画像表示させない"
  (interactive)
  (setq-local shr-put-image-function 'shr-put-image-alt)
  (eww-reload))
(defun eww-enable-images ()
  "ewwで画像表示させる"
  (interactive)
  (setq-local shr-put-image-function 'shr-put-image)
  (eww-reload))
(defun shr-put-image-alt (spec alt &optional flags)
  (insert alt))
(defun eww-mode-hook--disable-image ()
  (setq-local shr-put-image-function 'shr-put-image-alt))
(add-hook 'eww-mode-hook 'eww-mode-hook--disable-image)
