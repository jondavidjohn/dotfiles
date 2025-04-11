return {
  "RRethy/base16-nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require('base16-colorscheme').with_config({
        telescope_borders = true
    })
    vim.cmd("colorscheme base16-tomorrow-night")
    vim.cmd("match Tabs /\t/")
    vim.api.nvim_set_hl(0, 'Tabs', { fg = require('base16-colorscheme').colors.base02 })
  end,
}
