-- Keymaps configuration
-- See `:help vim.keymap.set()`

-- [[ Basic Keymaps ]]

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode with a shortcut
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Window navigation with CTRL+hjkl
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<A-p>', '<C-w>w', { desc = 'Cycle window focus' })

-- [[ Custom Keymaps ]]

-- Helper function to get project root using native vim.fs
local function project_root()
  -- Find .git directory walking up from current buffer
  local git_root = vim.fs.find('.git', {
    upward = true,
    path = vim.fn.expand('%:p:h'),
  })[1]

  if git_root then
    return vim.fn.fnamemodify(git_root, ':h')
  end
  return vim.loop.cwd()
end

-- Buffer management
vim.keymap.set('n', '<leader>bb', require('telescope.builtin').buffers, { desc = 'List buffers' })

-- Project management (Projectile-like)
vim.keymap.set('n', '<leader>pf', function()
  require('telescope.builtin').find_files { cwd = project_root() }
end, { desc = '[P]roject [F]iles' })
vim.keymap.set('n', '<leader>pg', function()
  require('telescope.builtin').live_grep { cwd = project_root() }
end, { desc = '[P]roject [G]rep' })
vim.keymap.set('n', '<leader>pb', function()
  require('telescope.builtin').buffers { cwd = project_root() }
end, { desc = '[P]roject [B]uffers' })

-- Window management
vim.keymap.set('n', '<leader>w/', ':vsplit<CR>', { desc = 'Vertical Split' })
vim.keymap.set('n', '<leader>wmm', '<C-w>_ <C-w>|', { desc = 'Maximize current window' })

-- File browser
vim.keymap.set('n', '<leader>ff', function()
  require('telescope').extensions.file_browser.file_browser {
    path = '%:p:h',
    select_buffer = true,
    hidden = true,
    grouped = true,
  }
end, { desc = 'File browser at current dir' })

-- Custom delete_pair keymaps
vim.keymap.set('n', 'C', function()
  require('custom.delete_pair').change_to_closing_pair()
end, { desc = 'Change to closing pair' })

vim.keymap.set('n', 'D', function()
  require('custom.delete_pair').delete_to_closing_pair()
end, { desc = 'Delete to closing pair using Treesitter' })

-- Git diff keymaps
vim.keymap.set('n', '<leader>gd', '<cmd>DiffviewOpen<cr>', { desc = '[G]it [D]iff current changes' })
vim.keymap.set('n', '<leader>gh', '<cmd>DiffviewFileHistory<cr>', { desc = '[G]it [H]istory current file' })
vim.keymap.set('n', '<leader>gH', '<cmd>DiffviewFileHistory %<cr>', { desc = '[G]it [H]istory current file' })
vim.keymap.set('n', '<leader>gc', function()
  local commit = vim.fn.input('Commit hash: ')
  if commit ~= '' then
    vim.cmd('DiffviewOpen ' .. commit .. '^..' .. commit)
  end
end, { desc = '[G]it [C]ommit diff' })
vim.keymap.set('n', '<leader>gq', '<cmd>DiffviewClose<cr>', { desc = '[G]it diff [Q]uit' })
