return {
  {
    "Houl/repmo-vim",
    config = function ()
      -- Map `h` and `l` motions
      vim.keymap.set('n', 'h', "repmo#SelfKey('h', 'l')|sunmap h", { expr = true, noremap = true })
      vim.keymap.set('n', 'l', "repmo#SelfKey('l', 'h')|sunmap l", { expr = true, noremap = true })

      -- Map `j` and `k` to `gj` and `gk`
      vim.keymap.set('n', 'j', "repmo#Key('gj', 'gk')|sunmap j", { expr = true, noremap = true })
      vim.keymap.set('n', 'k', "repmo#Key('gk', 'gj')|sunmap k", { expr = true, noremap = true })

      -- Map `;` and `,` for repeating last motion
      vim.keymap.set('n', ';', "repmo#LastKey(';')|sunmap ;", { expr = true, noremap = true })
      vim.keymap.set('n', '\'', "repmo#LastRevKey(',')|sunmap ,", { expr = true, noremap = true })

      -- Map `f`, `F`, `t`, and `T` for zap keys
      vim.keymap.set('n', 'f', "repmo#ZapKey('f')|sunmap f", { expr = true, noremap = true })
      vim.keymap.set('n', 'F', "repmo#ZapKey('F')|sunmap F", { expr = true, noremap = true })
      vim.keymap.set('n', 't', "repmo#ZapKey('t')|sunmap t", { expr = true, noremap = true })
      vim.keymap.set('n', 'T', "repmo#ZapKey('T')|sunmap T", { expr = true, noremap = true })
    end
  }
}
