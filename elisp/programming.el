;; GNU GENERAL PUBLIC LICENSE
;; Version 3, 29 June 2007


(use-package corfu
  :ensure t
  :custom
  (corfu-cycle t)	;; Enable cycling for `corfu-next/previous'
  (corfu-auto t)	;; Enable auto completion
  (corfu-auto-prefix 2)	;; Minimum length of prefix for auto completion.
  (corfu-popupinfo-mode t) ;; Enable popup information
  (corfu-popupinfo-delay 0.1) ;; Lower popupinfo delay to 0.5 seconds from 2 seconds
  (corfu-separator ?\s)          
  (completion-ignore-case t)
  (tab-always-indent 'complete)
  (global-corfu-mode))

;; Better YEsons
(use-package json-mode
  :ensure t)

;; Git client 
(use-package magit
  :ensure nil
  :bind (("C-x g" . magit-status)))

(setopt eglot-ignored-server-capabilities '(:inlayHintProvider)) ;; no inline hints
(use-package eglot
  :ensure nil
  :hook
  ((c-mode . eglot-ensure)
   (python-mode . eglot-ensure))
  :custom
  (eglot-send-changes-idle-time 0.1)
  (eglot-extend-to-xref t)
  :config
  (fset #'jsonrpc--log-event #'ignore))

;; M-x compile
(setopt compilation-scroll-output t)
