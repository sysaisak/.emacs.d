;; GNU GENERAL PUBLIC LICENSE
;; Version 3, 29 June 2007

;; Languages.el
;; Things for better programming env (?)

;; Lisps
(use-package paredit
  :ensure t
  :hook ((clojure-mode . paredit-mode)
         (scheme-mode . paredit-mode)
         (clojure-mode . paredit-mode)
         (emacs-lisp-mode . paredit-mode)
         (lisp-mode . paredit-mode)
	 (cider-repl-mode . paredit-mode))
  :config
  (define-key global-map (kbd "M-[") 'paredit-wrap-square)
  (define-key global-map (kbd "M-(") 'paredit-wrap-sexp))

;; Clojure
(add-to-list 'auto-mode-alist '("\\.clj\\'" . clojure-mode))
(use-package clojure-mode
  :ensure t)

(use-package cider
  :ensure t
  :hook (clojure-mode . cider-mode)
  :custom
  (cider-repl-display-help-banner nil))

;; Lisps
(add-to-list 'auto-mode-alist '("\\.scm\\'" . scheme-mode))
(add-to-list 'auto-mode-alist '("\\.lisp\\'" . lisp-mode))

;; php
(add-to-list 'auto-mode-alist '("\\.php\\'" . php-mode))
(use-package php-mode
  :ensure t)

;; Golang
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))
(use-package go-mode
  :ensure t)

;; html?
(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
(use-package web-mode
  :ensure t)
