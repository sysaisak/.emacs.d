(defun moon/connect-to-libera ()
    (interactive)
  (erc-tls :server "irc.libera.chat"
	   :port "6697"
	   :nick "sysbl1nk"))

(setq erc-autojoin-channels-alist
      '(("Libera.Chat" "#guix" "#emacs" "#technicalrenaissance")))

;; Interpret mIRC-style color commands in IRC chats
(setq erc-interpret-mirc-color t)
;; Ingore annoying (and unnecessary) Join, Part, Quit messages
(setq erc-hide-list '("JOIN" "PART" "QUIT"))
