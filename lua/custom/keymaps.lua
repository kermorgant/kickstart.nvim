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

-- Helper function to get project root
local function project_root()
  local ok, project = pcall(require, 'project_nvim.project')
  if ok and project.get_project_root then
    local root = project.get_project_root()
    if root and #root > 0 then
      return root
    end
  end
  return vim.loop.cwd()
end

-- Buffer management
vim.keymap.set('n', '<leader>bb', require('telescope.builtin').buffers, { desc = 'List buffers' })

-- Project management (Projectile-like)
vim.keymap.set('n', '<leader>pp', '<cmd>Telescope projects<cr>', { desc = '[P]roject switch' })
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
