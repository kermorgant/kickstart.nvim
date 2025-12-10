-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  -- Comment.nvim for easy code commenting
  {
    'numToStr/Comment.nvim',
    event = 'VeryLazy',
    config = function()
      require('Comment').setup {
        ---Add a space b/w comment and the line
        padding = true,
        ---Whether the cursor should stay at its position
        sticky = true,
        ---Lines to be ignored while (un)comment
        ignore = nil,
        ---LHS of toggle mappings in NORMAL mode
        toggler = {
          ---Line-comment toggle keymap
          line = 'gcc',
          ---Block-comment toggle keymap
          block = 'gbc',
        },
        ---LHS of operator-pending mappings in NORMAL and VISUAL mode
        opleader = {
          ---Line-comment keymap
          line = 'gc',
          ---Block-comment keymap
          block = 'gb',
        },
        ---LHS of extra mappings
        extra = {
          ---Add comment on the line above
          above = 'gcO',
          ---Add comment on the line below
          below = 'gco',
          ---Add comment at the end of line
          eol = 'gcA',
        },
        ---Enable keybindings
        ---NOTE: If given `false` then the plugin won't create any mappings
        mappings = {
          ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
          basic = true,
          ---Extra mapping; `gco`, `gcO`, `gcA`
          extra = true,
        },
        ---Function to call before (un)comment
        pre_hook = nil,
        ---Function to call after (un)comment
        post_hook = nil,
      }

      -- Emacs-style keybinding with transition reminder
      local comment_api = require 'Comment.api'

      vim.keymap.set('n', '<C-x><C-;>', function()
        vim.notify('Emacs: C-x C-; → Neovim: gcc or gc+motion', vim.log.levels.INFO, { title = 'Comment' })
        comment_api.toggle.linewise.current()
      end, { desc = 'Toggle comment (Emacs style)' })

      vim.keymap.set('x', '<C-x><C-;>', function()
        vim.notify('Emacs: C-x C-; → Neovim: gc in visual', vim.log.levels.INFO, { title = 'Comment' })
        local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
        vim.api.nvim_feedkeys(esc, 'nx', false)
        comment_api.toggle.linewise(vim.fn.visualmode())
      end, { desc = 'Toggle comment (Emacs style)' })
    end,
  },
}
