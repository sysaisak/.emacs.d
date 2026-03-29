;; GNU GENERAL PUBLIC LICENSE
;; Version 3, 29 June 2007

;; Meimacs, an emacs starter configuration.
;; Copyright (C) 2025 Isaac Narvaez <isaac.rkt@proton.me>

;; ============================================================================
;; STARTUP MEASUREMENT
;; ============================================================================

;; Display startup time
(defun display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
           (format "%.2f seconds"
                   (float-time
                    (time-subtract after-init-time before-init-time)))
           gcs-done))

(add-hook 'emacs-startup-hook #'display-startup-time)

;; ============================================================================
;; CUSTOM VARIABLES FILE
;; ============================================================================

;; Set custom file location to keep init.el clean
(setq custom-file (expand-file-name "elisp/custom.el" user-emacs-directory))

;; Load custom file if it exists
(when (file-exists-p custom-file)
  (load custom-file))

;; ============================================================================
;; PACKAGE CONFIGURATION
;; ============================================================================

(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")))

(package-initialize)

;; Install use-package if not available
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t
      use-package-always-defer t) ; DEFERRED LOADING BY DEFAULT

;; ============================================================================
;; BASIC EMACS CONFIGURATION
;; ============================================================================

(defalias 'yes-or-no-p 'y-or-n-p) ;; yes or no are long words

(let ((backup-dir (expand-file-name "emacs-backup/" user-emacs-directory)))
  (setopt backup-directory-alist `(("." . ,backup-dir))))

(use-package emacs
  :demand t ; Load immediately
  :custom
  (user-mail-address "uns.isaac@ashajaa.xyz")
  (user-full-name "Isaac Narvaez")
  (dired-kill-when-opening-new-dired-buffer t) ;; Dired don't create new buffer
  :config
  (pixel-scroll-precision-mode t)) ;; smooth scrolling

;; Visual configuration (no packages)
(setq cursor-type 'hbar
      line-spacing nil
      cursor-in-non-selected-windows nil
      cursor-height 100
      scroll-step 1
      blink-cursor-interval 0.2
      blink-cursor-blinks 0
      frame-resize-pixelwise t
      eldoc-echo-area-use-multiline-p nil)

;; Hooks for prog-mode
(add-hook 'prog-mode-hook 'electric-pair-mode)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; ============================================================================
;; PACKAGES WITH DEFERRED LOADING
;; ============================================================================

;; compat - required by some packages
(use-package compat
  :demand t) ; Must be loaded immediately if other packages depend on it

;; which-key - useful but not critical at startup
;; which-key is a minor mode for Emacs that displays the key bindings
;; following your currently entered incomplete command (a prefix) in a popup.
;; For example, C-x
(use-package which-key
  :defer 2 ; Load after 2 seconds
  :config
  (which-key-mode))

;; Theme - load immediately to avoid flash
(use-package doric-themes
  :ensure t
  :demand t
  :config
  (doric-themes-select 'doric-dark)
  (load-theme 'doric-dark t)
  )

;; rainbow-delimiters - only when needed
;; Does not work with mindre-theme
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; ============================================================================
;; ORG MODE - Enhanced Configuration
;; ============================================================================

(use-package org
  :mode ("\\.org\\'" . org-mode)
  :hook ((org-mode . visual-line-mode)
         (org-mode . org-indent-mode))
  :bind (("C-c l" . org-store-link)
         ("C-c a" . org-agenda)
         ("C-c c" . org-capture))
  :custom
  ;; Files
  (org-agenda-files '("~/org/calendar.org"
                      "~/org/university/tasks.org"
                      "~/org/cpts/roadmap.org"
                      "~/org/inbox.org"))
  (org-default-notes-file "~/org/inbox.org")
  (org-archive-location "~/org/archive/%s_archive::")
  
  ;; Appearance
  (org-startup-folded 'content)
  (org-startup-indented t)
  (org-startup-with-inline-images t)
  (org-hide-emphasis-markers t)
  (org-pretty-entities t)
  (org-ellipsis " ▾")
  
  ;; Behavior
  (org-return-follows-link t)
  (org-src-tab-acts-natively t)
  (org-src-preserve-indentation t)
  (org-edit-src-content-indentation 0)
  
  ;; Agenda & Logging
  (org-agenda-start-with-log-mode t)
  (org-log-done 'time)
  (org-log-into-drawer t)
  
  ;; TODO Keywords
  (org-todo-keywords
   '((sequence "TODO(t)" "IN-PROGRESS(i)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))
  (org-todo-keyword-faces
   '(("TODO" . org-warning)
     ("IN-PROGRESS" . (:foreground "orange" :weight bold))
     ("WAITING" . (:foreground "yellow" :weight bold))
     ("DONE" . (:foreground "green" :weight bold))
     ("CANCELLED" . (:foreground "gray" :weight bold))))
  
  ;; Capture Templates
  (org-capture-templates
   '(("t" "Todo" entry (file+headline "~/org/inbox.org" "Tasks")
      "* TODO %?\n  %i\n  %a")
     ("n" "Note" entry (file+headline "~/org/inbox.org" "Notes")
      "* %?\nEntered on %U\n  %i\n  %a")
     ("u" "University" entry (file+headline "~/org/university/tasks.org" "Tasks")
      "* TODO %?\nDEADLINE: %t\n  %i")))
  
  :config
  ;; Babel languages
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (shell . t)
     (python . t)
     (lisp . t)))
  (setq org-confirm-babel-evaluate nil))

;; Better bullets and styling
(use-package org-superstar
  :hook (org-mode . org-superstar-mode)
  :custom
  (org-superstar-headline-bullets-list '("◉" "○" "●" "○" "●" "○" "●"))
  (org-superstar-special-todo-items t))

;; Modern, clean appearance
(use-package org-modern
  :ensure t
  :hook (org-mode . org-modern-mode)
  :custom
  (org-modern-table-vertical 1)
  (org-modern-table-horizontal 0.1))

;; Show markup when editing
(use-package org-appear
  :ensure t
  :hook (org-mode . org-appear-mode))

;; ============================================================================
;; TERMINAL
;; ============================================================================

(use-package eat
  :defer t)

;; ============================================================================
;; EXTERNAL MODULES (deferred loading)
;; ============================================================================

;; Load after startup to avoid blocking
(add-hook 'emacs-startup-hook
          (lambda ()
            ;; Visual upgrade, better navigation and minibuffer completion
            (load (expand-file-name "elisp/upgrade.el" user-emacs-directory) t)
            ;; Programming packages, eglot (emacs polyglot) lsp and corfu
            (load (expand-file-name "elisp/programming.el" user-emacs-directory) t)
            ;; Language configurations
            (load (expand-file-name "elisp/languages.el" user-emacs-directory) t)
            ;; IRC nerd chat
            (load (expand-file-name "elisp/irc.el" user-emacs-directory) t)))

;; Emacs X11 Window Manager ;)
;;(load-file (expand-file-name "elisp/exwm.el" user-emacs-directory))
