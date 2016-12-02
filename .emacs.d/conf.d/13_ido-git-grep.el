(defun ido-git-grep-interactive (search-word)
  "Grep for SEARCH-WORD in the current git repository."
  (interactive "Mkeyword: ")
  (let* ((project-root (shell-command-to-string "git rev-parse --show-toplevel"))
         (command (format "git grep -n \"%s\" %s 2> /dev/null" search-word project-root))
         (search-result (split-string (shell-command-to-string command) "\n"))
         (user-input-line (split-string
                           (ido-completing-read "git-grep: " search-result) ":")))
    (find-file (nth 0 user-input-line))
    (goto-char (point-min))
    (forward-line (1- (string-to-number (nth 1 user-input-line))))))

(defun ido-git-grep ()
  "Grep for SEARCH-WORD in the current git repository."
  (interactive)
  (let* ((project-root
          (replace-regexp-in-string "\n$" ""
                                    (shell-command-to-string "git rev-parse --show-toplevel")))
         (command (format "git grep --full-name -n \"%s\" %s 2>/dev/null"
                          (current-word) project-root))
         (search-result (split-string (shell-command-to-string command) "[\r\n]"))
         (user-input-line (split-string
                           (ido-completing-read+
                            (format "git-grep(%s): " (current-word)) search-result nil t) ":")))
    (find-file (concat project-root "/" (nth 0 user-input-line)))
    (goto-char (point-min))
    (forward-line (1- (string-to-number (nth 1 user-input-line))))))
