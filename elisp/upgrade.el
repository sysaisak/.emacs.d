;; GNU GENERAL PUBLIC LICENSE
;; Version 3, 29 June 2007


;; ;; Dashboard
;; (use-package dashboard
;;   :ensure t
;;   :custom
;;   (dashboard-center-content t)
;;   (dashboard-startup-banner "~/.emacs.d/assets/output-guix.png")
;;   (dashboard-banner-logo-title "Welcome to Meimacs")
;;   :config
;;   (dashboard-setup-startup-hook))
;; (setq inhibit-startup-screen t)
;; (setq initial-buffer-choice (lambda () (get-buffer-create "*dashboard*")))

;; ;; To customize which items are displayed, you can use the following snippet
;; (setq dashboard-items '((recents   . 5)
;;                         (bookmarks . 3)
;; 			;; (projects  . 5)
;;                         (agenda    . 3)
;; 			;; (registers . 5)
;; 			))

;; Better modeline
;; (use-package doom-modeline
;;   :ensure t
;;   :init (doom-modeline-mode 1)
;;   :custom
;;   (doom-modeline-height 25)     ;; Sets modeline height
;;   (doom-modeline-bar-width 5)   ;; Sets right bar width
;;   (doom-modeline-persp-name t)  ;; Adds perspective name to modeline
;;   (doom-modeline-persp-icon t)) ;; Adds folder icon next to persp name

;; Motion aids
(use-package avy
  :ensure t
  :demand t
  :bind (("C-c j" . avy-goto-line)
         ("s-j"   . avy-goto-char-timer)))

;; Consult: Misc. enhanced commands
(use-package consult
  :ensure t
  :bind
  ;; Drop-in replacements
  (("C-x b" . consult-buffer)     ; orig. switch-to-buffer
   ("M-y"   . consult-yank-pop)   ; orig. yank-pop
   ;; Searching - Avoiding M-s conflicts with paredit
   ("C-c r" . consult-ripgrep)
   ("C-c l" . consult-line)
   ("C-c s" . consult-line)       
   ("C-c L" . consult-line-multi)
   ("C-c o" . consult-outline)
   :map isearch-mode-map
   ("M-e"   . consult-isearch-history)   
   ("C-c e" . consult-isearch-history)   
   ("C-c l" . consult-line)             
   ("C-c L" . consult-line-multi))     
  :config
  (setq consult-narrow-key "<"))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package vertico
  :ensure t
  :custom
  (vertico-count 8)
  :init
  (vertico-mode))

;; Marginalia: annotations for minibuffer
(use-package marginalia
  :ensure t
  :config
  (marginalia-mode))

(savehist-mode) ;; Enables save history mode

(defun split-and-follow-horizontally ()
  (interactive)
  (split-window-below)
  (balance-windows)
  (other-window 1))
(global-set-key (kbd "C-x 2") 'split-and-follow-horizontally)

(defun split-and-follow-vertically ()
  (interactive)
  (split-window-right)
  (balance-windows)
  (other-window 1))
(global-set-key (kbd "C-x 3") 'split-and-follow-vertically)
