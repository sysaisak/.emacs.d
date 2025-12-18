;; GNU GENERAL PUBLIC LICENSE
;; Version 3, 29 June 2007

;; Meimacs, an emacs starter configuration.
;; Copyright (C) 2025 Isaac Narvaez <isaac.rkt@proton.me>
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
;; or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.


(require 'package)
;(package-initialize)
;; Definir los repositorios iniciales si no están definidos
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")
			 ("nongnu" . "https://elpa.nongnu.org/nongnu/")))

(setopt inferior-lisp-program "sbcl")

;; org mode config
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(use-package org-superstar
  :ensure t)
(add-hook 'org-mode-hook (lambda () (org-superstar-mode 1)))

(use-package compat
  :ensure t)

(use-package eat
  :ensure t)

(use-package sly
  :ensure t)

;; Theme config 
(use-package poet-theme
  :ensure t
  :config
  (load-theme 'poet-dark t))

(defalias 'yes-or-no-p 'y-or-n-p) ;; yes or no are long words

(let ((backup-dir (expand-file-name "emacs-backup/" user-emacs-directory)))
  (setopt backup-directory-alist `(("." . ,backup-dir))))

;; Some emacs things
(use-package emacs
  :custom
  (user-mail-address "uns.isaac@ashajaa.xyz")
  (setq user-full-name "Isaac Narvaez")
  (dired-kill-when-opening-new-dired-buffer t) ;; Dired don't create new buffer
  (pixel-scroll-precision-mode t)              ;; smooth scrolling
  )

(use-package rainbow-delimiters
  :ensure t) ;; Does not work with mindre-theme

;; which-key is a minor mode for Emacs that displays the key bindings
;; following your currently entered incomplete command (a prefix) in a popup.
;; For example, C-x
(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(setopt scroll-step 1)
(setopt blink-cursor-interval 0.2)
(setopt blink-cursor-blinks 0)
(setopt frame-resize-pixelwise t)
(setopt eldoc-echo-area-use-multiline-p nil)
(add-hook 'prog-mode-hook 'electric-pair-mode)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; Visual upgrade, better navigation and minibuffer completion
(load-file (expand-file-name "elisp/upgrade.el" user-emacs-directory))

;; Programming packages, eglot (emacs poliglot) lsp and corfu 
(load-file (expand-file-name "elisp/programming.el" user-emacs-directory))
(load-file (expand-file-name "elisp/languages.el" user-emacs-directory))

;; Emacs X11 Window Manager ;)
;;(load-file (expand-file-name "elisp/exwm.el" user-emacs-directory))

;; Custom vars
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(bookmark-bmenu-toggle-filenames nil)
 '(cider-clojure-cli-aliases nil)
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
