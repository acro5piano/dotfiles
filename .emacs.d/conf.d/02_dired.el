;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Dired
;;;;;;;;;;;;;;;;;;;;;;;;;;

;; dired-find-alternate-file の有効化
(put 'dired-find-alternate-file 'disabled nil)

;; ファイルなら別バッファで、ディレクトリなら同じバッファで開く
(defun dired-open-in-accordance-with-situation ()
  (interactive)
  (let ((file (dired-get-filename)))
    (if (file-directory-p file)
        (dired-find-alternate-file)
      (dired-find-file))))

;; RET 標準の dired-find-file では dired バッファが複数作られるので
;; dired-find-alternate-file を代わりに使う
(require 'dired )
(bind-keys :map dired-mode-map
           ("RET" . dired-open-in-accordance-with-situation)
           ("a" . dired-find-file))


;; Diredを使いやすくする
(ffap-bindings)

;;file名の補完で大文字小文字を区別しない
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (ace-link yaml-mode magit undo-tree iedit ## browse-kill-ring markdown-mode htmlize cask bind-key auto-complete)))
 '(read-file-name-completion-ignore-case t))
