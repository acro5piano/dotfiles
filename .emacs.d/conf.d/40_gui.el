;; for GUI settings
(if window-system
    (progn
      (defun open-terminator ()
        " open terminator async
Http://stackoverflow.com/questions/13901955/how-to-avoid-pop-up-of-async-shell-command-buffer-in-emacs"
        (interactive)
        (call-process-shell-command "terminator&" nil 0))

      (bind-key* "C-M-h" 'ido-delete-backward-word-updir)
      (bind-key* "C-M-h" 'ido-delete-backward-word-updir)
      (bind-key* "M-%" 'anzu-query-replace)
      (bind-key* "C-M-%" 'anzu-query-replace-regexp)
      (bind-key* "C-t" 'open-terminator)

      (defun eww-disable-images ()
        "ewwで画像表示させない"
        (interactive)
        (setq-local shr-put-image-function 'shr-put-image-alt)
        (eww-reload))
      (defun eww-enable-images ()
        "ewwで画像表示させる"
        (interactive)
        (setq-local shr-put-image-function 'shr-put-image)
        (eww-reload))
      (defun shr-put-image-alt (spec alt &optional flags)
        (insert alt))
      (defun eww-mode-hook--disable-image ()
        (setq-local shr-put-image-function 'shr-put-image-alt))
      (add-hook 'eww-mode-hook 'eww-mode-hook--disable-image)
      ))
