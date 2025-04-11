return {
  'preservim/vimux',
   vim.keymap.set('n', '<leader>tz',':VimuxZoomRunner<CR>'),
   vim.keymap.set('n', '<leader>tq', ':VimuxCloseRunner<CR>'),
   config = function()
     vim.cmd("let g:VimuxHeight = '35%'")
   end
}
