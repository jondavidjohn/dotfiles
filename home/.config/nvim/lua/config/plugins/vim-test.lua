return {
  'vim-test/vim-test',
  dependencies = {
    'preservim/vimux',
  },
  vim.keymap.set('n', '<leader>tl', ':TestNearest<CR>'),
  vim.keymap.set('n', '<leader>ta', ':TestFile<CR>'),
  vim.keymap.set('n', '<leader>tp', ':TestLast<CR>'),
  vim.cmd("let test#strategy = 'vimux'"),
}
