-- lua/config/plugins/mini.lua
return {
  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.files').setup {
        options = {
          use_as_default_explorer = true,
        }
      }
      local minifiles_toggle = function()
        if not MiniFiles.close() then MiniFiles.open() end
      end
      vim.keymap.set("n", "<leader>e", minifiles_toggle, { noremap = true })

      local set_mark = function(id, path, desc)
        MiniFiles.set_bookmark(id, path, { desc = desc })
      end
      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesExplorerOpen',
        callback = function()
          set_mark('c', vim.fn.stdpath('config'), 'Config')
          set_mark('w', vim.fn.getcwd, 'Working directory')
          set_mark('~', '~', 'Home directory')
        end,
      })

      require('mini.trailspace').setup {}
      vim.keymap.set("n", "<leader>sw", MiniTrailspace.trim, { noremap = true })
    end
  },
}
