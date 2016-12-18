;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Edit
;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Not use auto indent
(setq-default indent-tabs-mode nil)
(electric-indent-mode 1)

(setq comment-style 'multi-line)
(setq backward-delete-char-untabify-method 'hungry)

;; スクロールを一行ずつにする
(setq scroll-step 1)

(global-undo-tree-mode t)

;; C-x C-l => downcase
(put 'downcase-region 'disabled nil)

;; M-u => upcase
(put 'upcase-region 'disabled nil)
