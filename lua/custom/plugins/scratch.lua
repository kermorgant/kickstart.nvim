-- Scratch buffer plugins integrated with notes system

-- Get scratch file path from notes repo
local function get_scratch_file()
  local notes_repo = vim.env.NOTES_REPO
  if not notes_repo then
    return nil
  end
  notes_repo = vim.fn.expand(notes_repo)
  return notes_repo .. '/scratch/scratch.md'
end

-- Open persistent scratch file
local function open_scratch()
  local scratch_file = get_scratch_file()
  if not scratch_file then
    vim.notify('NOTES_REPO not set, using temp scratch', vim.log.levels.WARN)
    vim.cmd 'Scratch' -- Fallback to ephemeral scratch
    return
  end

  -- Create directory if needed
  local dir = vim.fn.fnamemodify(scratch_file, ':h')
  vim.fn.mkdir(dir, 'p')

  -- Open in split
  vim.cmd('split ' .. vim.fn.fnameescape(scratch_file))

  -- Move to end
  vim.cmd 'normal! G'
end

return {
  -- Keep swaits/scratch.nvim as fallback for truly ephemeral buffers
  {
    'https://git.sr.ht/~swaits/scratch.nvim',
    lazy = true,
    keys = {
      { '<leader>X', '<cmd>Scratch<cr>', desc = 'Ephemeral Scratch Buffer', mode = 'n' },
    },
    cmd = {
      'Scratch',
      'ScratchSplit',
    },
    opts = {},
  },

  -- Remove LintaoAmons/scratch.nvim (redundant)
  -- Main scratch keybind now opens persistent scratch from notes repo
  {
    'folke/which-key.nvim',
    optional = true,
    opts = {
      spec = {
        {
          '<leader>x',
          function()
            open_scratch()
          end,
          desc = 'Scratch (persistent)',
        },
      },
    },
  },
}
