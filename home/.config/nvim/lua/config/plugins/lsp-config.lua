return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function ()
      local caps = require('blink.cmp').get_lsp_capabilities()

      require('lspconfig').lua_ls.setup({ capabilities = caps })
      require('lspconfig').ruby_lsp.setup({ capabilities = caps })
      require('lspconfig').solargraph.setup({ capabilities = caps })
      require('lspconfig').gopls.setup({ capabilities = caps })
      require('lspconfig').yamlls.setup({ capabilities = caps })

      require('lspconfig').rubocop.setup({
        cmd = { "bundle", "exec", "rubocop", "--lsp" },
        capabilities = caps
      })
    end
  }
}
