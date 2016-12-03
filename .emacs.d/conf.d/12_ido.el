;;(ido-mode t)
;;(ido-everywhere t)
;;(ido-ubiquitous-mode 1)
;;(ido-vertical-mode 1)
;;
;;(setq ido-enable-flex-matching t) ;; 中間/あいまい一致
;;(setq ido-vertical-define-keys 'C-n-and-C-p-only)
;;
;;
;;(defun ido-recentf ()
;;  "Use `ido-completing-read' to find a recent file."
;;  (interactive)
;;  (if (find-file (ido-completing-read "Find recent file: " recentf-list))
;;      (message "Opening file...")
;;    (message "Aborting")))
;;(setq ido-use-virtual-buffers t)
;;
