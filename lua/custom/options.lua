-- Neovim options configuration
-- See `:help vim.o` and `:help option-list`

-- Line numbers
vim.o.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Don't show mode in command line (it's in status line)
vim.o.showmode = false

-- Hybrid clipboard setup (Neovim built without clipboard support):
-- - If wl-clipboard available: use it for reliable copy/paste (local Wayland)
-- - Otherwise: use OSC-52 for copy (containers/SSH), paste via terminal Ctrl+Shift+V

if vim.fn.executable 'wl-copy' == 1 then
  -- Local Wayland: use wl-clipboard for both copy and paste
  vim.g.clipboard = {
    name = 'wl-clipboard',
    copy = {
      ['+'] = 'wl-copy',
      ['*'] = 'wl-copy --primary',
    },
    paste = {
      ['+'] = 'wl-paste --no-newline',
      ['*'] = 'wl-paste --no-newline --primary',
    },
    cache_enabled = 0,
  }
else
  -- Container/SSH: use OSC-52 for copy, rely on terminal paste
  vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = require('vim.ui.clipboard.osc52').copy '+',
      ['*'] = require('vim.ui.clipboard.osc52').copy '*',
    },
  }
end
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital letters in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor
vim.o.scrolloff = 10

-- Raise dialog asking to save instead of failing due to unsaved changes
vim.o.confirm = true

-- Folding configuration using TreeSitter (built-in Neovim 0.9+)
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldlevel = 99 -- Start with all folds open
vim.opt.foldenable = true

-- EditorConfig support
if vim.fn.has('nvim-0.9') == 1 then
  -- Enable built-in EditorConfig support (Neovim 0.9+)
  vim.g.editorconfig = true
else
  -- Will rely on gpanders/editorconfig.nvim plugin for older versions
end

-- Ensure EditorConfig settings take precedence over guess-indent and other conflicting plugins
vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function()
    -- Give EditorConfig a moment to apply settings, then ensure they're not overridden
    vim.defer_fn(function()
      -- Force re-detection of EditorConfig for the current buffer
      if vim.fn.has('nvim-0.9') == 1 and vim.g.editorconfig then
        -- Built-in support: ensure it's applied
        local ok, _ = pcall(vim.api.nvim_exec2, 'silent! EditorConfigReload', {})
        if not ok then
          -- Fallback: manually apply common EditorConfig-like settings
          local bufnr = vim.api.nvim_get_current_buf()
          vim.api.nvim_set_option_value('expandtab', not (vim.bo[bufnr].shiftwidth == 0), { buf = bufnr })
        end
      end
    end, 50)
  end,
})
