;; GNU GENERAL PUBLIC LICENSE
;; Version 3, 29 June 2007

;; Meimacs programming tools configuration
;; LSP with Eglot, completion with Corfu, and development utilities

;; ============================================================================
;; COMPLETION - CORFU
;; ============================================================================

(use-package corfu
  :ensure t
  :demand t  ; Load immediately for global mode
  :custom
  (corfu-cycle t)                       ; Enable cycling for corfu-next/previous
  (corfu-auto t)                        ; Enable auto completion
  (corfu-auto-prefix 2)                 ; Minimum length of prefix for auto completion
  (corfu-auto-delay 0.1)                ; Delay before showing (seconds)
  (corfu-popupinfo-mode t)              ; Enable popup information
  (corfu-popupinfo-delay 0.1)           ; Lower popupinfo delay
  (corfu-separator ?\s)                 ; Separator character
  (corfu-quit-no-match 'separator)      ; Don't quit on no match
  (corfu-preview-current 'insert)       ; Preview current candidate
  (corfu-preselect 'prompt)             ; Preselect the prompt
  (corfu-on-exact-match nil)            ; Don't auto-insert exact match
  (corfu-scroll-margin 5)               ; Scroll margin
  :bind (:map corfu-map
              ("TAB" . corfu-next)
              ([tab] . corfu-next)
              ("S-TAB" . corfu-previous)
              ([backtab] . corfu-previous)
              ("RET" . corfu-insert)
              ("M-d" . corfu-show-documentation)
              ("M-l" . corfu-show-location))
  :init
  (global-corfu-mode)
  :config
  ;; Enable Corfu in minibuffer
  (defun corfu-enable-in-minibuffer ()
    "Enable Corfu in the minibuffer if appropriate."
    (when (where-is-internal #'completion-at-point (list (current-local-map)))
      (setq-local corfu-auto nil)
      (corfu-mode 1)))
  (add-hook 'minibuffer-setup-hook #'corfu-enable-in-minibuffer))

;; Corfu terminal support (for terminal Emacs)
(use-package corfu-terminal
  :ensure t
  :if (not (display-graphic-p))
  :after corfu
  :config
  (corfu-terminal-mode))

;; Cape - additional completion backends
(use-package cape
  :ensure t
  :defer t
  :init
  ;; Add to completion-at-point-functions
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  :bind (("C-c p d" . cape-dabbrev)
         ("C-c p f" . cape-file)
         ("C-c p k" . cape-keyword)))

;; Kind-icon - pretty icons in completion
(use-package kind-icon
  :ensure t
  :after corfu
  :custom
  (kind-icon-default-face 'corfu-default)
  (kind-icon-blend-background nil)
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

;; ============================================================================
;; COMPLETION SETTINGS
;; ============================================================================

;; TAB completion behavior
(setq tab-always-indent 'complete)
(setq completion-cycle-threshold 3)

;; Improve completion experience
(setq completion-ignore-case t)
(setq read-buffer-completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)

;; ============================================================================
;; LSP - EGLOT
;; ============================================================================

(use-package eglot
  :ensure nil  ; Built-in on Emacs 29+
  :defer t
  :hook ((c-mode          . eglot-ensure)
         (c++-mode        . eglot-ensure)
         (c-ts-mode       . eglot-ensure)
         (c++-ts-mode     . eglot-ensure)
         (python-mode     . eglot-ensure)
         (python-ts-mode  . eglot-ensure)
         (go-mode         . eglot-ensure)
         (go-ts-mode      . eglot-ensure)
         (nix-mode        . eglot-ensure)
         (nix-ts-mode     . eglot-ensure)
         (bash-ts-mode    . eglot-ensure)
         (sh-mode         . eglot-ensure))
  :custom
  (eglot-send-changes-idle-time 0.1)    ; Send changes quickly
  (eglot-extend-to-xref t)              ; Use xref for references
  (eglot-autoshutdown t)                ; Shutdown server when last buffer closes
  (eglot-events-buffer-size 0)          ; Disable event logging (performance)
  (eglot-sync-connect nil)              ; Async connection
  :config
  ;; Disable event logging for performance
  (fset #'jsonrpc--log-event #'ignore)
  
  ;; Disable some features for performance
  (setq eglot-ignored-server-capabilities
        '(:inlayHintProvider              ; No inline hints
          :documentHighlightProvider))    ; No document highlights
  
  ;; Optional: Configure specific servers
  ;; (add-to-list 'eglot-server-programs
  ;;              '(python-ts-mode . ("pyright-langserver" "--stdio")))
  )

;; Expected LSP servers:
;; - clangd       -> C/C++    (apt install clangd)
;; - gopls        -> Go       (go install golang.org/x/tools/gopls@latest)
;; - pyright      -> Python   (pip install pyright)
;; - nil          -> Nix      (nix-env -iA nixpkgs.nil)
;; - bash-ls      -> Bash     (npm install -g bash-language-server)

;; ============================================================================
;; GIT INTEGRATION - MAGIT
;; ============================================================================

(use-package magit
  :ensure t
  :defer t
  :bind (("C-x g"   . magit-status)
         ("C-x M-g" . magit-dispatch)
         ("C-c g"   . magit-file-dispatch))
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
  (magit-diff-refine-hunk t)
  (magit-save-repository-buffers 'dontask))

;; Git-gutter - show git diff in fringe
(use-package git-gutter
  :ensure t
  :defer 1
  :custom
  (git-gutter:update-interval 0.5)
  (git-gutter:modified-sign "│")
  (git-gutter:added-sign "│")
  (git-gutter:deleted-sign "│")
  :config
  (global-git-gutter-mode))

;; ============================================================================
;; COMPILATION
;; ============================================================================

;; Better compilation output
(setq compilation-scroll-output t)           ; Auto-scroll compilation buffer
(setq compilation-window-height 15)          ; Compilation window height
(setq compilation-ask-about-save nil)        ; Don't ask to save before compiling
(setq compilation-always-kill t)             ; Kill old compilation without asking

;; Colorize compilation buffer
(use-package ansi-color
  :ensure nil  ; Built-in
  :hook (compilation-filter . ansi-color-compilation-filter))

;; ============================================================================
;; PROGRAMMING UTILITIES
;; ============================================================================

;; Show function signature in echo area
(use-package eldoc
  :ensure nil  ; Built-in
  :custom
  (eldoc-idle-delay 0.3)
  (eldoc-echo-area-use-multiline-p nil)
  :config
  (global-eldoc-mode))

;; Highlight TODO/FIXME/NOTE in comments
(use-package hl-todo
  :ensure t
  :defer 1
  :custom
  (hl-todo-keyword-faces
   '(("TODO"   . "#FF0000")
     ("FIXME"  . "#FF0000")
     ("DEBUG"  . "#A020F0")
     ("NOTE"   . "#1E90FF")
     ("HACK"   . "#FF8C00")
     ("REVIEW" . "#FFD700")
     ("XXX"    . "#FF0000")))
  :config
  (global-hl-todo-mode))

;; Highlight matching parentheses
(use-package paren
  :ensure nil  ; Built-in
  :custom
  (show-paren-delay 0)
  (show-paren-style 'parentheses)
  (show-paren-when-point-inside-paren t)
  (show-paren-when-point-in-periphery t)
  :config
  (show-paren-mode))

;; Format all - universal code formatter
(use-package format-all
  :ensure t
  :defer t
  :bind (("C-c f" . format-all-buffer)
         ("C-c F" . format-all-region))
  :hook (prog-mode . format-all-ensure-formatter))

;; Aggressive indent - auto-indent
(use-package aggressive-indent
  :ensure t
  :defer t
  :hook ((emacs-lisp-mode
          lisp-mode
          scheme-mode
          clojure-mode) . aggressive-indent-mode))

;; Quickrun - execute current buffer
(use-package quickrun
  :ensure t
  :defer t
  :bind (("C-c r" . quickrun)
         ("C-c C-r" . quickrun-region)))


;; LISP
(use-package sly
  :ensure t
  :defer t
  :custom
  (inferior-lisp-program "sbcl"))
