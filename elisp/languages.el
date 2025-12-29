;;; init.el --- minimal treesit + eglot + corfu
;;; GNU GPL v3

;; Core
(setq inhibit-startup-screen t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(setq use-package-always-ensure t)

;; Tree-sitter
(setq treesit-font-lock-level 4)

(setq treesit-language-source-alist
      '((c        . ("https://github.com/tree-sitter/tree-sitter-c"))
        (go       . ("https://github.com/tree-sitter/tree-sitter-go"))
        (clojure  . ("https://github.com/sogaiu/tree-sitter-clojure"))
	(nix      . ("https://github.com/nix-community/tree-sitter-nix"))))

(setq major-mode-remap-alist
      '((c-mode       . c-ts-mode)
        (go-mode      . go-ts-mode)
        (clojure-mode . clojure-ts-mode)
	(nix-mode     . nix-ts-mode)))

(use-package go-mode)
(use-package clojure-mode)
(use-package nix-mode)
(use-package nix-ts-mode)
;; c-mode is builtin


;; Paredit (Lisps)
(use-package paredit
  :hook ((emacs-lisp-mode
          lisp-mode
          scheme-mode
          clojure-mode
          clojure-ts-mode
          cider-repl-mode) . paredit-mode)
  :bind (("M-[" . paredit-wrap-square)
         ("M-(" . paredit-wrap-sexp)))

;; Clojure tooling
(use-package cider
  :hook (clojure-mode . cider-mode)
  :custom
  (cider-repl-display-help-banner nil))

;; LSP (Eglot)
(use-package eglot
  :custom
  (eglot-events-buffer-size 0)   ;; no event spam
  (eglot-sync-connect nil)
  :config
  (add-to-list 'eglot-stay-out-of 'flymake))

(add-hook 'c-ts-mode-hook       #'eglot-ensure)
(add-hook 'go-ts-mode-hook      #'eglot-ensure)
(add-hook 'clojure-ts-mode-hook #'eglot-ensure)

;; Servers expected:
;; clangd        -> C
;; gopls         -> Go
;; clojure-lsp   -> Clojure

(use-package cargo-mode)
(use-package rustic
  :hook ((rustic-mode . eglot-ensure)
         (rustic-mode . cargo-minor-mode))
  :custom
  (rustic-lsp-client 'eglot)
  (rustic-format-on-save nil))

;; ====================
;; Completion (Corfu)
;; ====================
(use-package corfu
  :init
  (global-corfu-mode)
  :custom
  (corfu-auto t)
  (corfu-cycle t)
  (corfu-preselect-first t))

(setq tab-always-indent 'complete)
(setq completion-cycle-threshold 3)

(use-package kind-icon
  :after corfu
  :custom
  (kind-icon-default-face 'corfu-default)
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

;; Git
(use-package magit
  :bind ("C-x g" . magit-status))

(use-package forge
  :after magit)

(use-package with-editor
  :after magit)
