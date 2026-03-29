;; GNU GENERAL PUBLIC LICENSE
;; Version 3, 29 June 2007

;; Meimacs language-specific configurations
;; Mode setup, tree-sitter, and language-specific tools

;; ============================================================================
;; TREE-SITTER CONFIGURATION
;; ============================================================================

;; Maximum syntax highlighting level
(setq treesit-font-lock-level 4)

;; Tree-sitter language sources
(setq treesit-language-source-alist
      '((c        "https://github.com/tree-sitter/tree-sitter-c")
        (cpp      "https://github.com/tree-sitter/tree-sitter-cpp")
        (go       "https://github.com/tree-sitter/tree-sitter-go")
        (python   "https://github.com/tree-sitter/tree-sitter-python")
        (clojure  "https://github.com/sogaiu/tree-sitter-clojure")
        (bash     "https://github.com/tree-sitter/tree-sitter-bash")
        (json     "https://github.com/tree-sitter/tree-sitter-json")
        (yaml     "https://github.com/tree-sitter/tree-sitter-yaml")
        (toml     "https://github.com/tree-sitter/tree-sitter-toml")
        (markdown "https://github.com/MDeiml/tree-sitter-markdown")
	))

;; Remap major modes to tree-sitter versions
(setq major-mode-remap-alist
      '((c-mode          . c-ts-mode)
        (c++-mode        . c++-ts-mode)
        (go-mode         . go-ts-mode)
        (python-mode     . python-ts-mode)
        (clojure-mode    . clojure-ts-mode)
        (sh-mode         . bash-ts-mode)
        (js-mode         . js-ts-mode)
        (json-mode       . json-ts-mode)
        (yaml-mode       . yaml-ts-mode)))

;; Function to install missing tree-sitter grammars
(defun moon/install-treesit-grammars ()
  "Install all tree-sitter grammars defined in treesit-language-source-alist."
  (interactive)
  (dolist (lang treesit-language-source-alist)
    (let ((language (car lang)))
      (unless (treesit-language-available-p language)
        (message "Installing tree-sitter grammar for %s..." language)
        (treesit-install-language-grammar language)))))

;; ============================================================================
;; C/C++
;; ============================================================================

;; C mode is built-in, just configure it
(use-package c-mode
  :ensure nil  ; Built-in
  :custom
  (c-basic-offset 4)
  (c-default-style "linux"))

;; ============================================================================
;; PYTHON
;; ============================================================================

;; Python mode is built-in with python-ts-mode
(use-package python-mode
  :ensure nil  ; Built-in
  :custom
  (python-indent-offset 4)
  (python-shell-interpreter "python3"))

;; ============================================================================
;; GO
;; ============================================================================

(use-package go-mode
  :ensure t
  :defer t
  :mode "\\.go\\'"
  :custom
  (gofmt-command "goimports")  ; Use goimports instead of gofmt
  :hook ((go-mode . (lambda ()
                      (setq tab-width 4)
                      (add-hook 'before-save-hook #'gofmt-before-save nil t)))))

;; ============================================================================
;; LISP LANGUAGES
;; ============================================================================

;; Paredit - structural editing for Lisps
(use-package paredit
  :ensure t
  :hook ((emacs-lisp-mode
          lisp-mode
          scheme-mode
          clojure-mode
          clojure-ts-mode
          cider-repl-mode
          ielm-mode) . paredit-mode)
  :bind (:map paredit-mode-map
              ("M-[" . paredit-wrap-square)
              ("M-(" . paredit-wrap-sexp)
              ("M-{" . paredit-wrap-curly))
  :config
  ;; Make paredit work better with delete-selection-mode
  (put 'paredit-forward-delete 'delete-selection 'supersede)
  (put 'paredit-backward-delete 'delete-selection 'supersede))

;; ============================================================================
;; CLOJURE
;; ============================================================================

(use-package clojure-mode
  :ensure t
  :defer t
  :mode (("\\.clj\\'" . clojure-mode)
         ("\\.cljs\\'" . clojurescript-mode)
         ("\\.cljc\\'" . clojurec-mode)
         ("\\.edn\\'" . clojure-mode)))

;; CIDER - Clojure Interactive Development Environment
(use-package cider
  :ensure t
  :defer t
  :hook ((clojure-mode . cider-mode)
         (clojure-ts-mode . cider-mode))
  :bind (:map cider-mode-map
              ("C-c C-d" . cider-doc)
              ("C-c C-s" . cider-repl-set-ns)
              ("C-c M-j" . cider-jack-in))
  :custom
  (cider-repl-display-help-banner nil)
  (cider-repl-pop-to-buffer-on-connect nil)
  (cider-repl-use-pretty-printing t)
  (cider-repl-wrap-history t)
  (cider-repl-history-size 1000)
  (cider-show-error-buffer 'only-in-repl)
  (cider-font-lock-dynamically '(macro core function var))
  (cider-eldoc-display-for-symbol-at-point t)
  (cider-prompt-for-symbol nil)
  (nrepl-log-messages nil))  ; Disable nrepl logging

;; ============================================================================
;; JSON/YAML/TOML
;; ============================================================================

(use-package json-mode
  :ensure t
  :defer t
  :mode "\\.json\\'"
  :custom
  (js-indent-level 2))

(use-package yaml-mode
  :ensure t
  :defer t
  :mode "\\.ya?ml\\'")

(use-package toml-mode
  :ensure t
  :defer t
  :mode "\\.toml\\'")

;; ============================================================================
;; MARKDOWN
;; ============================================================================

(use-package markdown-mode
  :ensure t
  :defer t
  :mode (("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode)
         ("README\\.md\\'" . gfm-mode))
  :custom
  (markdown-command "pandoc")
  (markdown-fontify-code-blocks-natively t))

;; ============================================================================
;; WEB DEVELOPMENT
;; ============================================================================

;; HTML
(use-package web-mode
  :ensure t
  :defer t
  :mode (("\\.html\\'" . web-mode)
         ("\\.htm\\'" . web-mode)
         ("\\.jsx\\'" . web-mode)
         ("\\.tsx\\'" . web-mode))
  :custom
  (web-mode-markup-indent-offset 2)
  (web-mode-css-indent-offset 2)
  (web-mode-code-indent-offset 2))

;; CSS
(use-package css-mode
  :ensure nil  ; Built-in
  :mode "\\.css\\'"
  :custom
  (css-indent-offset 2))

;; ============================================================================
;; SHELL SCRIPTS
;; ============================================================================

(use-package sh-script
  :ensure nil  ; Built-in
  :mode (("\\.sh\\'" . bash-ts-mode)
         ("\\.bash\\'" . bash-ts-mode)
         ("\\.zsh\\'" . sh-mode))
  :custom
  (sh-basic-offset 2)
  (sh-indentation 2))
