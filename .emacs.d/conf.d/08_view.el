;;;;;;;;;;;;;;;;;;;;;;;;;;
;; View
;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Don't show tool-bar and menu-bar
(tool-bar-mode -1)
(menu-bar-mode -1)
(global-linum-mode t)
(setq linum-format "%4d ")

;; Hilight current line
(global-hl-line-mode)
(set-face-background 'hl-line "Gray23")
(set-face-foreground 'highlight nil)

;; カーソル位置の桁数をモードライン行に表示する
(column-number-mode 1)

;; スクロールバー非表示
(scroll-bar-mode 0)

;; カーソルの色
(set-cursor-color "gray")

(show-paren-mode t)

(display-time-mode)

(custom-set-faces
 '(default
    ((t (:inherit nil
                  :stipple nil
                  :background "#002b36"
                  :foreground "#839496"
                  :inverse-video nil
                  :box nil
                  :strike-through nil
                  :overline nil
                  :underline nil
                  :slant normal
                  :weight normal
                  :height 105
                  :width normal
                  :foundry "Source Code Pro"
                  :family "Source Code Pro"
                  ))))
 '(helm-selection
   ((t (:background "Gray23"
                    :distant-foreground "black")))))

(set-fontset-font t 'japanese-jisx0208
                  (font-spec :family "IPAExGothic"))


(defun my/increase-font-size()
  (interactive)
  (custom-set-faces
   '(default
      ((t (:height 160))))))

(defun my/decrease-font-size()
  (interactive)
  (custom-set-faces
   '(default
      ((t (:height 105))))))

(bind-key "C--" 'my/decrease-font-size)
(bind-key "C-+" 'my/increase-font-size)
