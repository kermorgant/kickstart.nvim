-- Simple scratch buffer plugin

return {
  {
    'https://git.sr.ht/~swaits/scratch.nvim',
    lazy = true,
    keys = {
      { '<leader>X', '<cmd>Scratch<cr>', desc = 'Scratch Buffer (fullscreen)', mode = 'n' },
      { '<leader>x', '<cmd>ScratchSplit<cr>', desc = 'Scratch Buffer (split)', mode = 'n' },
    },
    cmd = {
      'Scratch',
      'ScratchSplit',
    },
    opts = {},
  },
}
