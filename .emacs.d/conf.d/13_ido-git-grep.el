(defun ido-git-grep()
  (interactive)
  (setq user-input-line
        (split-string
         (ido-completing-read
          "git-grep:"
          (split-string (shell-command-to-string
                         (format "git grep -n %s" (read-string "keyword:")))
                         "\n"))
         ":"))
  (find-file (nth 0 user-input-line))
  (goto-char (point-min))
  (forward-line (1- (string-to-number (nth 1 user-input-line)))))

(bind-key "C-x C-p" 'ido-git-grep)
