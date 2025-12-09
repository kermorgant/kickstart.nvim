-- Neovim options configuration
-- See `:help vim.o` and `:help option-list`

-- Line numbers
vim.o.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Don't show mode in command line (it's in status line)
vim.o.showmode = false

-- Sync clipboard between OS and Neovim using OSC-52
-- This works through SSH and containers by sending escape sequences to the terminal
-- Requires tmux config: set -g set-clipboard on
-- Requires Neovim 0.10+ and OSC-52 compatible terminal (Alacritty, WezTerm, Ghostty, etc.)
vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
    ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
  },
  paste = {
    ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
    ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
  },
}
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
