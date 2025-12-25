-- UI and colorscheme plugins
-- Environment-based theme switching via NVIM_THEME environment variable
-- Supported themes: solarized-dark, gruvbox (fallback: tokyonight-night)
-- Usage: export NVIM_THEME=solarized-dark

-- Check environment variable and determine theme
local nvim_theme = os.getenv('NVIM_THEME') or ''
nvim_theme = nvim_theme:lower()

-- Normalize common variations
if nvim_theme == 'solarized' then
  nvim_theme = 'solarized-dark'
end

-- Theme configurations
local themes = {
  ['solarized-dark'] = {
    plugin = 'maxmx03/solarized.nvim',
    config = function()
      require('solarized').setup({
        variant = 'winter', -- winter is the dark variant
        styles = {
          comments = { italic = false },
        },
      })
      vim.cmd.colorscheme('solarized')
    end,
  },
  ['gruvbox'] = {
    plugin = 'ellisonleao/gruvbox.nvim',
    config = function()
      require('gruvbox').setup({
        contrast = 'hard',
        styles = {
          comments = { italic = false },
        },
      })
      vim.cmd.colorscheme('gruvbox')
    end,
  },
}

-- Determine selected theme
local selected_theme = themes[nvim_theme] and nvim_theme or 'fallback'

-- Show warning for invalid theme names
if nvim_theme ~= '' and not themes[nvim_theme] then
  vim.notify(
    string.format(
      'Invalid NVIM_THEME="%s". Available: solarized-dark, gruvbox. Using tokyonight-night fallback.',
      nvim_theme
    ),
    vim.log.levels.WARN
  )
end

return {
  -- TokyoNight (fallback theme)
  {
    'folke/tokyonight.nvim',
    enabled = selected_theme == 'fallback',
    priority = 1000,
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        styles = {
          comments = { italic = false },
        },
      }
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },

  -- Solarized theme
  {
    'maxmx03/solarized.nvim',
    enabled = selected_theme == 'solarized-dark',
    priority = 1000,
    config = themes['solarized-dark'].config,
  },

  -- Gruvbox theme
  {
    'ellisonleao/gruvbox.nvim',
    enabled = selected_theme == 'gruvbox',
    priority = 1000,
    config = themes['gruvbox'].config,
  },
}
