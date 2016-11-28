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

      (setq ns-use-srgb-colorspace nil)

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

      ;; テーマやPowerlineを有効化すると、CUIでEmacsが使い物にならなくなる
      ;; そのため、CUIではVimを使うこと

      ;; これ無くてもなぜか動作するから、外す
      ;; (color-theme-solarized)

      (set-face-attribute 'mode-line nil
                          :foreground "#FFF"
                          :background "#4B0082")

      (set-face-attribute 'powerline-active1 nil
                          :foreground "#fff"
                          :background "#006400"
                          :inherit 'mode-line)

      (set-face-attribute 'powerline-active2 nil
                          :foreground "#000"
                          :background "#FFF"
                          :inherit 'mode-line)

      (powerline-default-theme)

      ;; 色文字列に色をつける rainbow-mode
      (setq rainbow-html-colors t)
      (setq rainbow-x-colors t)
      (setq rainbow-latex-colors t)
      (setq rainbow-ansi-colors t)
      (add-hook 'css-mode-hook 'rainbow-mode)
      (add-hook 'scss-mode-hook 'rainbow-mode)
      (add-hook 'php-mode-hook 'rainbow-mode)
      (add-hook 'html-mode-hook 'rainbow-mode)

      (custom-set-faces
       ;; custom-set-faces was added by Custom.
       ;; If you edit it by hand, you could mess it up, so be careful.
       ;; Your init file should contain only one such instance.
       ;; If there is more than one, they won't work right.
       '(helm-selection ((t (:background "Gray23" :distant-foreground "black")))))

      ))
