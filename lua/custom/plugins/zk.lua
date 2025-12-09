-- Minimal Zettelkasten setup with zk-nvim
-- Requires: zk CLI tool installed (https://github.com/zk-org/zk)

return {
  {
    'zk-org/zk-nvim',
    config = function()
      require('zk').setup {
        picker = 'telescope',
      }

      -- Basic keybindings
      vim.keymap.set('n', '<leader>zn', "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>", { desc = '[Z]ettelkasten: [N]ew note' })
      vim.keymap.set('n', '<leader>zo', '<Cmd>ZkNotes { sort = { "modified" } }<CR>', { desc = '[Z]ettelkasten: [O]pen note' })
      vim.keymap.set('n', '<leader>zt', '<Cmd>ZkTags<CR>', { desc = '[Z]ettelkasten: Find by [T]ags' })
    end,
  },
}
