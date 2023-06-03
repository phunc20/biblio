Depending on your Vim, the variable `$MYVIMRC` will point to
the file path of your Vim's configuration file, e.g.
- Vim: Usually `~/.vimrc`
- NeoVim: Usually `~/.config/nvim/init.vim`

The following are a few examples of how to use `$MYVIMRC`:
- Open Vim's configuration file
  ```vim
  # Either
  :find $MYVIMRC<CR>
  # Or
  :split $MYVIMRC<CR>
  ```
- Source Vim's configuration file
  ```vim
  :source $MYVIMRC<CR>
  ```
