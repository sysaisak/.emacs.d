;; GNU GENERAL PUBLIC LICENSE
;; Version 3, 29 June 2007

;; Meimacs early initialization
;; Copyright (C) 2025 Isaac Narvaez <isaac.rkt@proton.me>

;;; Performance optimizations for startup

;; Temporarily increase GC threshold during startup
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

;; Disable file-name-handler during startup
(defvar default-file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

;; Restore values after startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1024 1024) ; 16MB
                  gc-cons-percentage 0.1
                  file-name-handler-alist default-file-name-handler-alist)))

;; Disable package.el early (we initialize it manually in init.el)
(setq package-enable-at-startup nil)

;; Prevent frame resizing during startup
(setq frame-inhibit-implied-resize t)

;; Disable native compilation warnings (if using native-comp)
(setq native-comp-async-report-warnings-errors nil)

;; Minimal UI
(menu-bar-mode -1)    ;; disable menubar
(tool-bar-mode -1)    ;; disable toolbar
(scroll-bar-mode -1)  ;; disable scrollbar

;; Disable additional unnecessary UI elements
(setq inhibit-splash-screen t
      use-file-dialog nil
      tab-bar-new-button-show nil
      tab-bar-close-button-show nil
      tab-line-close-button-show nil
      inhibit-startup-screen t
      inhibit-startup-message t
      inhibit-startup-echo-area-message user-login-name)

;; ;; Configure font efficiently
(set-face-attribute 'default nil
                    :family "JetBrainsMono NF"
                    :height 140)

;; Optional: Set font for fixed-pitch and variable-pitch faces
(set-face-attribute 'fixed-pitch nil :family "JetBrainsMono NF" :height 140)
;;(set-face-attribute 'variable-pitch nil :family "sans-serif" :height 140)


