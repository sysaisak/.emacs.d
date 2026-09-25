;; GNU GENERAL PUBLIC LICENSE  -*- lexical-binding: t; -*-
;; Version 3, 29 June 2007

;; ============================================================================
;; MINIBUFFER COMPLETION - Vertico Stack
;; ============================================================================

;; Vertico - vertical completion interface
(use-package vertico
  :ensure t
  :demand t  ; Load immediately
  :custom
  (vertico-cycle t)                      ; Cycle through candidates
  (vertico-count 8)
  ;;  (vertico-resize t)                     ; Resize minibuffer dynamically
  :init
  (vertico-mode))

;; Vertico directory - better directory navigation
(use-package vertico-directory
  :after vertico
  :ensure nil  ; Built-in with vertico
  :bind (:map vertico-map
              ("RET" . vertico-directory-enter)
              ("DEL" . vertico-directory-delete-char)
              ("M-DEL" . vertico-directory-delete-word))
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))

;; Orderless - flexible completion style
(use-package orderless
  :ensure t
  :demand t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles basic partial-completion)))))

;; Marginalia - rich annotations in minibuffer (THIS IS KEY FOR M-x HELP)
(use-package marginalia
  :ensure t
  :demand t  ; Load immediately
  :bind (:map minibuffer-local-map
	      ("M-A" . marginalia-cycle))  ; Cycle between annotation levels
  :custom
  (marginalia-align 'right)           ; Align annotations to right
  (marginalia-max-relative-age 0)     ; Show absolute time
  :init
  (marginalia-mode))

;; Consult - enhanced search and navigation commands
(use-package consult
  :ensure t
  :bind
  ;; Drop-in replacements
  (("C-x b"   . consult-buffer)         ; orig. switch-to-buffer
   ("M-y"     . consult-yank-pop)       ; orig. yank-pop
   ("C-x C-r" . consult-recent-file)    ; Recent files
   ;; M-g bindings (goto-map)
   ("M-g g"   . consult-goto-line)      ; orig. goto-line
   ("M-g M-g" . consult-goto-line)
   ("M-g o"   . consult-outline)        ; Outline navigation
   ("M-g m"   . consult-mark)
   ("M-g k"   . consult-global-mark)
   ("M-g i"   . consult-imenu)
   ;; Searching - Avoiding M-s conflicts with paredit
   ("C-c r"   . consult-ripgrep)
   ("C-c l"   . consult-line)
   ("C-c s"   . consult-line)        
   ("C-c L"   . consult-line-multi)
   ("C-c o"   . consult-outline)
   ;; Isearch integration
   :map isearch-mode-map
   ("M-e"     . consult-isearch-history)   
   ("C-c e"   . consult-isearch-history)   
   ("C-c l"   . consult-line)              
   ("C-c L"   . consult-line-multi))
  :custom
  (consult-narrow-key "<")
  (consult-preview-key 'any)            ; Preview on any key
  :config
  ;; Añadida la declaración lexical-binding arriba
  ;; Preview rápido para cambio de temas
  (consult-customize
   consult-theme
   :preview-key '(:debounce 0.2 any))

  ;; Preview bajo demanda (M-.) para búsquedas pesadas y fuentes
  (consult-customize
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult-source-bookmark 
   consult-source-recent-file
   consult-source-project-recent-file
   :preview-key "M-."))

;; Embark - contextual actions
(use-package embark
  :ensure t
  :bind
  (("C-." . embark-act)		    ; Pick an action
   ("C-;" . embark-dwim)	    ; Do What I Mean
   ("C-h B" . embark-bindings))	    ; Alternative to describe-bindings
  :init
  ;; Show Embark actions via which-key
  (setq prefix-help-command #'embark-prefix-help-command)
  :config
  ;; Hide modeline in embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

;; Embark-Consult integration
(use-package embark-consult
  :ensure t
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

;; ============================================================================
;; MOTION AIDS
;; ============================================================================

;; Avy - jump to visible text
(use-package avy
  :ensure t
  :demand t
  :bind (("C-c j" . avy-goto-line)
         ("s-j"   . avy-goto-char-timer)
         ("C-'"   . avy-goto-char-2))
  :custom
  (avy-timeout-seconds 0.3)
  (avy-all-windows nil))            ; Only current window

;; ============================================================================
;; HISTORY AND PERSISTENCE
;; ============================================================================

;; Save minibuffer history
(use-package savehist
  :ensure nil  ; Built-in
  :demand t
  :custom
  (history-length 1000)
  (history-delete-duplicates t)
  (savehist-save-minibuffer-history t)
  (savehist-additional-variables
   '(kill-ring
     search-ring
     regexp-search-ring))
  :init
  (savehist-mode))

;; ============================================================================
;; WINDOW MANAGEMENT
;; ============================================================================

;; Split and follow horizontally
(defun moon/split-and-follow-horizontally ()
  "Split window horizontally and follow to new window."
  (interactive)
  (split-window-below)
  (balance-windows)
  (other-window 1))

;; Split and follow vertically
(defun moon/split-and-follow-vertically ()
  "Split window vertically and follow to new window."
  (interactive)
  (split-window-right)
  (balance-windows)
  (other-window 1))

;; Keybindings
(global-set-key (kbd "C-x 2") 'moon/split-and-follow-horizontally)
(global-set-key (kbd "C-x 3") 'moon/split-and-follow-vertically)

(defun moon/ansi-colorize-buffer ()
  "Colorize the current buffer interpreting ANSI color codes."
  (interactive)
  (let ((inhibit-read-only t))
    (ansi-color-apply-on-region (point-min) (point-max))))
(global-set-key (kbd "C-c C-a") 'moon/ansi-colorize-buffer)

;; GROFF TOOLS
;; GROFF TOOLS
(use-package pdf-tools
  :ensure t
  :config
  (pdf-tools-install)
  (setq pdf-view-display-size 'fit-page)
  (setq pdf-view-center-content t)
  (setq pdf-view-use-scaling t))

(require 'pdf-view)
(require 'subr-x)

;; 1. Asociar extensiones para que activen nroff-mode automáticamente
(add-to-list 'auto-mode-alist '("\\.ms\\'" . nroff-mode))
(add-to-list 'auto-mode-alist '("\\.mom\\'" . nroff-mode))

;; 2. Separar las banderas dependiendo del tipo de macro
(defvar moon/groff-ms-flags "-k -m es -ms -t -e -Tpdf"
  "Flags por defecto para invocar groff en archivos .ms.")

(defvar moon/groff-mom-flags "-k"
  "Flags por defecto para archivos .mom (usando pdfmom).")

;; 3. Función de compilación inteligente
(defun moon/groff-compile-to-pdf (&optional flags)
  "Compila el archivo groff actual a PDF detectando si es ms o mom."
  (interactive
   (let* ((ext (file-name-extension (buffer-file-name)))
          (default-f (if (string= ext "mom") moon/groff-mom-flags moon/groff-ms-flags))
          (compiler (if (string= ext "mom") "pdfmom" "groff")))
     (list (read-string (format "Banderas de %s (por defecto '%s'): " compiler default-f)
                        nil nil default-f))))
  (when (buffer-file-name)
    (let* ((file (buffer-file-name))
           (ext (file-name-extension file))
           (pdf-file (concat (file-name-sans-extension file) ".pdf"))
           (is-mom (string= ext "mom"))
           (default-flags (if is-mom moon/groff-mom-flags moon/groff-ms-flags))
           (final-flags (if (string-empty-p (or flags "")) default-flags flags))
           (compiler (if is-mom "pdfmom" "groff"))
           (cmd (format "%s %s %s > %s"
                        compiler
                        final-flags
                        (shell-quote-argument file)
                        (shell-quote-argument pdf-file))))
      (message "Compilando: %s" cmd)
      (shell-command cmd)
      (message "Groff Done."))))

;; 4. Refrescar PDF (Sin cambios)
(defun moon/groff-refresh-pdf-buffer (pdf-file)
  "Refresca el buffer PDF si está abierto."
  (let ((pdf-buf (get-file-buffer pdf-file)))
    (when pdf-buf
      (with-current-buffer pdf-buf
        (revert-buffer nil t)
        (when (fboundp 'pdf-view-redisplay)
          (pdf-view-redisplay t))))))

;; 5. Compilar y refrescar silenciosamente (Sin cambios lógicos)
(defun moon/groff-compile-and-revert-silent ()
  "Compila y recarga el PDF si está abierto."
  (interactive)
  (when (buffer-file-name)
    (let ((pdf-file (concat (file-name-sans-extension (buffer-file-name)) ".pdf")))
      (moon/groff-compile-to-pdf nil)
      (moon/groff-refresh-pdf-buffer pdf-file))))

;; 6. Compilar y mostrar PDF (Sin cambios lógicos)
(defun moon/groff-compile-and-view ()
  "Compila y abre/enfoca el PDF a la derecha."
  (interactive)
  (when (buffer-file-name)
    (let* ((file (buffer-file-name))
           (pdf-file (concat (file-name-sans-extension file) ".pdf")))
      ;; Compilar
      (moon/groff-compile-and-revert-silent)
      ;; Abrir PDF
      (let* ((pdf-buf (find-file-noselect pdf-file))
             (pdf-win (get-buffer-window pdf-buf)))
        (if pdf-win
            (select-window pdf-win)
          (display-buffer
           pdf-buf
           '(display-buffer-in-side-window
             (side . right)
             (window-width . 0.5)))
          (select-window (get-buffer-window pdf-buf)))))))

;; 7. Hooks
(add-hook
 'nroff-mode-hook
 (lambda ()
   ;; Compilar al guardar
   (add-hook 'after-save-hook #'moon/groff-compile-and-revert-silent nil t)
   ;; Atajos locales
   (local-set-key (kbd "C-c C-c") #'moon/groff-compile-and-view)
   (local-set-key (kbd "C-c C-p") #'moon/groff-compile-to-pdf)))

;; ============================================================================
;; OPTIONAL: DASHBOARD (uncomment if desired)
;; ============================================================================

;; (use-package dashboard
;;   :ensure t
;;   :demand t
;;   :custom
;;   (dashboard-center-content t)
;;   (dashboard-startup-banner "~/.emacs.d/assets/output-guix.png")
;;   (dashboard-banner-logo-title "Welcome to Meimacs")
;;   (dashboard-items '((recents   . 5)
;;                      (bookmarks . 3)
;;                      (agenda    . 3)))
;;   :config
;;   (dashboard-setup-startup-hook))
;; (setq inhibit-startup-screen t)
;; (setq initial-buffer-choice (lambda () (get-buffer-create "*dashboard*")))

;; ============================================================================
;; OPTIONAL: DOOM MODELINE (uncomment if desired)
;; ============================================================================

;; (use-package doom-modeline
;;   :ensure t
;;   :demand t
;;   :custom
;;   (doom-modeline-height 25)
;;   (doom-modeline-bar-width 5)
;;   (doom-modeline-persp-name t)
;;   (doom-modeline-persp-icon t)
;;   :init
;;   (doom-modeline-mode 1))
