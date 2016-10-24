;;;;;;;;;;;;;;;;;;;;;;;;;;
; auto-complete
;;;;;;;;;;;;;;;;;;;;;;;;;;

(ac-config-default)
(global-auto-complete-mode)       ;; これで常にac-modeになる？
(add-to-list 'ac-modes 'text-mode)         ;; text-modeでも自動的に有効にする
(add-to-list 'ac-modes 'shell-script-mode)         ;; text-modeでも自動的に有効にする
(add-to-list 'ac-modes 'org-mode)
(add-to-list 'ac-modes 'yatex-mode)
(add-to-list 'ac-modes 'markdown-mode)
(add-to-list 'ac-modes 'lisp-interaction-mode)
(add-to-list 'ac-modes 'sql-mode)
(add-to-list 'ac-modes 'lisp-mode)
(add-to-list 'ac-modes 'ruby-mode)
(add-to-list 'ac-modes 'web-mode)
(add-to-list 'ac-modes 'haml-mode)
(add-to-list 'ac-modes 'ruby-mode)

(setq ac-use-menu-map t)       ;; 補完メニュー表示時にC-n/C-pで補完候補選択
