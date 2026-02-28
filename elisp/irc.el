;; GNU GENERAL PUBLIC LICENSE
;; Version 3, 29 June 2007

;; Meimacs IRC configuration - Simple ERC setup

;; ============================================================================
;; ERC - EMACS IRC CLIENT
;; ============================================================================

(use-package erc
  :ensure nil  ; Built-in
  :defer t
  :custom
  ;; Hide join/part/quit spam
  (erc-hide-list '("JOIN" "PART" "QUIT"))
  
  ;; Show mIRC colors
  (erc-interpret-mirc-color t)
  
  ;; Auto-join channels
  (erc-autojoin-channels-alist
   '(("Libera.Chat" "#guix" "#emacs" "#technicalrenaissance")))
  
  ;; Timestamps
  (erc-timestamp-format "[%H:%M] ")
  (erc-insert-timestamp-function 'erc-insert-timestamp-left-and-right)
  
  ;; Kill buffers on quit
  (erc-kill-buffer-on-part t)
  (erc-kill-queries-on-quit t)
  (erc-kill-server-buffer-on-quit t))

;; Colorize nicknames
(use-package erc-hl-nicks
  :ensure t
  :after erc
  :config
  (add-to-list 'erc-modules 'hl-nicks))

;; Connect function
(defun moon/irc-connect ()
  "Connect to Libera.Chat."
  (interactive)
  (erc-tls :server "irc.libera.chat"
           :port 6697
           :nick "sysbl1nk"))

;; Keybinding
(global-set-key (kbd "C-c i") 'irc-connect)
