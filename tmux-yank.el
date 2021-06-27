;; An implementation of github.com/roxma/vim-tmux-clipboard for emacs

(unless (equal (getenv "TMUX") "")
  (add-function :after after-focus-change-function #'tmux-yank/on-focus-change)
  (advice-add 'evil-set-register :before #'tmux-yank/on-evil-register))

;; (setq tmux-yank/buffers (shell-command-to-string "tmux list-buffers -F#{buffer_name}"))
(setq tmux-yank/buffers nil)
(setq tmux-yank/active nil)

(defun tmux-yank/on-focus-change ()
  (let ((buffers (shell-command-to-string "tmux list-buffers -F#{buffer_name}"))
        (tmux-yank/active t))
    (unless (equal tmux-yank/buffers buffers)
      (setq tmux-yank/buffers buffers)
      (let ((text (shell-command-to-string "tmux show-buffer")))
        (evil-set-register ?0 text)
        (kill-new text)))))

(defun tmux-yank/on-evil-register (register text)
  (when (equal register ?0)
    (unless tmux-yank/active
      (with-temp-buffer
        (insert text)
        (call-process-region (point-min) (point-max) "tmux" nil nil nil "loadb" "-")
        (setq tmux-yank/buffers (shell-command-to-string "tmux list-buffers -F#{buffer_name}"))))))

(provide 'tmux-yank)
