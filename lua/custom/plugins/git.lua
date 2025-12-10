-- Git integration plugins

return {
  { -- Git signs in the gutter
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  { -- Magit-inspired git interface
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'sindrets/diffview.nvim', -- optional - enhanced diff view
      'nvim-telescope/telescope.nvim', -- optional
    },
    cmd = 'Neogit',
    keys = {
      { '<leader>gg', '<cmd>Neogit<cr>', desc = 'Neogit status' },
    },
    opts = {
      -- Magit-style single character command bindings
      kind = 'tab', -- open in new tab (or 'split', 'vsplit', 'floating')
      integrations = {
        diffview = true, -- enable diffview integration
        telescope = true,
      },
    },
  },
}
