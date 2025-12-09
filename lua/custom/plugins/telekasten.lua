-- Minimal Telekasten setup for Zettelkasten note-taking
-- No external dependencies needed

return {
  {
    'nvim-telekasten/telekasten.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function()
      local home = vim.fn.expand(vim.env.NOTES_REPO or '~/notes')

      require('telekasten').setup {
        home = home,

        -- Use markdown files
        extension = '.md',

        -- Minimal configuration - keep it simple
        auto_set_filetype = true,
      }

      -- Basic keybindings
      vim.keymap.set('n', '<leader>zn', '<cmd>Telekasten new_note<CR>', { desc = '[Z]ettelkasten: [N]ew note' })
      vim.keymap.set('n', '<leader>zf', '<cmd>Telekasten find_notes<CR>', { desc = '[Z]ettelkasten: [F]ind notes' })
      vim.keymap.set('n', '<leader>zg', '<cmd>Telekasten search_notes<CR>', { desc = '[Z]ettelkasten: [G]rep notes' })
      vim.keymap.set('n', '<leader>zt', '<cmd>Telekasten show_tags<CR>', { desc = '[Z]ettelkasten: Show [T]ags' })
    end,
  },
}
