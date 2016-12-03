;;;;;;;;;;;;;;;;;;;;;;;;;;
;; File
;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Do not create a backup file
(setq make-backup-files nil)
(setq auto-save-default nil)

;; Do not show the welcome message
(setq inhibit-startup-message t)

;; Auto start server
(unless (server-running-p)
  (server-start))

;; do not insert magic comments
(setq ruby-insert-encoding-magic-comment nil)

;; シンボリックリンクの読み込みを許可
(setq vc-follow-symlinks t)
;; シンボリックリンク先のVCS内で更新が入った場合にバッファを自動更新
(setq auto-revert-check-vc-info t)

;; バッファ自動再読み込み
(global-auto-revert-mode 1)

;; start scratch buffer without the initial message
(setq initial-scratch-message "")

(setq open-junk-file-format "~/tmp/%Y-%m-%d-%H%M%S.")
(setq open-junk-file-find-file-function 'find-file)

;; undo tree always load
(global-undo-tree-mode)

(global-git-gutter-mode +1)
