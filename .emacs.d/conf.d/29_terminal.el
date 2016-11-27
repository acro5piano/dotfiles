(defun open-terminator ()
  "see Http://stackoverflow.com/questions/13901955/how-to-avoid-pop-up-of-async-shell-command-buffer-in-emacs"
  (interactive)
  (call-process-shell-command "terminator&" nil 0))
