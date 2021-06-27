An implementation of [vim-tmux-clipboard](https://github.com/roxma/vim-tmux-clipboard) for emacs

```lisp
(unless (equal (getenv "TMUX") "")
  (use-package tmux-yank
    :straight (tmux-yank :host github :repo "roxma/tmux-yank.el")))
```
