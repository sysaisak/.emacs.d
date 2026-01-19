;; GNU GENERAL PUBLIC LICENSE
;; Version 3, 29 June 2007

;; minimal UI
(menu-bar-mode -1) ;; disables menubar
(tool-bar-mode -1) ;; disables toolbar
(scroll-bar-mode -1) ;; disables scrollbar

(setq inhibit-splash-screen t
        use-file-dialog nil 
        tab-bar-new-button-show nil 
        tab-bar-close-button-show nil 
        tab-line-close-button-show nil) 



;; Fuente base
(set-face-attribute 'default nil
                    :family "JetBrains Mono"
                    :height 140)

(set-face-attribute 'fixed-pitch nil
                    :family "JetBrains Mono")

(set-face-attribute 'variable-pitch nil
                    :family "JetBrains Mono")

;; Comentarios
(set-face-attribute 'font-lock-comment-face nil
                    :family "JetBrains Mono")

(set-face-attribute 'font-lock-comment-delimiter-face nil
                    :family "JetBrains Mono")

;; Modeline
(set-face-attribute 'mode-line nil
                    :family "JetBrains Mono")

(set-face-attribute 'mode-line-inactive nil
                    :family "JetBrains Mono")

