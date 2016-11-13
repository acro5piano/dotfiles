;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Search settings
;;;;;;;;;;;;;;;;;;;;;;;;;;

(global-anzu-mode +1)
(setq anzu-use-migemo nil)
(setq anzu-search-threshold 1000)
(setq anzu-minimum-input-length 3)

;; 選択範囲をisearch
(defadvice isearch-mode
    (around isearch-mode-default-string (forward &optional regexp op-fun recursive-edit word-p) activate)
  (if (and transient-mark-mode mark-active (not (eq (mark) (point))))
      (progn
        (isearch-update-ring (buffer-substring-no-properties (mark) (point)))
        (deactivate-mark)
        ad-do-it
        (if (not forward)
            (isearch-repeat-backward)
          (goto-char (mark))
          (isearch-repeat-forward)))
    ad-do-it))
