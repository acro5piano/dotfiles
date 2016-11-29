(defun ido-git-grep (search-word)
  "Grep for SEARCH-WORD in the current git repository."
  (interactive "Mkeyword: ")
  (let* ((command (format "git grep -n %s" search-word))
         (search-result (split-string (shell-command-to-string command) "\n"))
         (user-input-line (split-string
                           (ido-completing-read "git-grep: " search-result) ":")))
    (find-file (nth 0 user-input-line))
    (goto-char (point-min))
    (forward-line (1- (string-to-number (nth 1 user-input-line))))))
