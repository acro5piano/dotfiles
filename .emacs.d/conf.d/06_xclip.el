;; Region to X clipboard
(defun paste-to-tmp-file(data)
  (with-temp-buffer
    (insert data)
    (write-file "/tmp/clipboard")))

(defun xclip-add-region()
  (interactive)
  (if (region-active-p)
      (progn
        (paste-to-tmp-file (buffer-substring-no-properties (region-beginning) (region-end)))
        (shell-command "xsel -ib < /tmp/clipboard")
        (message "%s" (shell-command-to-string "cat /tmp/clipboard")))
    (progn
      (message "no region"))))
