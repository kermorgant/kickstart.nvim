-- Note-taking system with zk (Zettelkasten) and auto-sync
-- Uses $NOTES_REPO environment variable to locate notes repository

local M = {}

-- Get notes repository path from environment variable
local function get_notes_repo()
  local notes_repo = vim.env.NOTES_REPO
  if not notes_repo then
    vim.notify('NOTES_REPO environment variable not set', vim.log.levels.WARN)
    return nil
  end
  -- Expand ~ to home directory
  notes_repo = vim.fn.expand(notes_repo)
  return notes_repo
end

-- Get current month file path
local function get_daily_file()
  local notes_repo = get_notes_repo()
  if not notes_repo then
    return nil
  end
  local month = os.date '%Y-%m'
  return notes_repo .. '/daily/' .. month .. '.md'
end

-- Get scratch file path
local function get_scratch_file()
  local notes_repo = get_notes_repo()
  if not notes_repo then
    return nil
  end
  return notes_repo .. '/scratch/scratch.md'
end

-- Get container ID (hostname or fallback)
local function get_container_id()
  local handle = io.popen 'hostname'
  if handle then
    local hostname = handle:read '*a'
    handle:close()
    return hostname:gsub('%s+$', '') -- trim whitespace
  end
  return 'unknown'
end

-- Insert timestamp and container ID entry
local function insert_entry_header()
  local timestamp = os.date '[%Y-%m-%d %H:%M]'
  local container_id = get_container_id()
  local entry = string.format('%s [%s] ', timestamp, container_id)

  -- Insert at current cursor position
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { entry })

  -- Move cursor to end of inserted text
  vim.api.nvim_win_set_cursor(0, { row, col + #entry })

  -- Enter insert mode
  vim.cmd 'startinsert'
end

-- Open or create a file, create directory if needed
local function open_file(filepath)
  if not filepath then
    return
  end

  -- Create directory if it doesn't exist
  local dir = vim.fn.fnamemodify(filepath, ':h')
  vim.fn.mkdir(dir, 'p')

  -- Open the file
  vim.cmd('edit ' .. vim.fn.fnameescape(filepath))

  -- Move to end of file
  vim.cmd 'normal! G'

  -- Add a newline if file isn't empty and doesn't end with newline
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  if #lines > 0 and lines[#lines] ~= '' then
    vim.api.nvim_buf_set_lines(0, -1, -1, false, { '' })
    vim.cmd 'normal! G'
  end

  -- Insert entry header
  insert_entry_header()
end

-- Git auto-sync function
local function git_sync(filepath)
  local notes_repo = get_notes_repo()
  if not notes_repo then
    return
  end

  -- Check if file is in notes repo
  if not filepath:match('^' .. vim.pesc(notes_repo)) then
    return
  end

  -- Run git commands in background
  vim.fn.jobstart({
    'bash',
    '-c',
    string.format(
      [[
      cd '%s' && \
      git pull --rebase --autostash 2>/dev/null && \
      git add . && \
      git commit -m "Auto-sync: $(date '+%%Y-%%m-%%d %%H:%%M:%%S')" 2>/dev/null && \
      git push 2>/dev/null &
      ]],
      notes_repo
    ),
  }, {
    on_exit = function(_, exit_code)
      if exit_code == 0 then
        vim.schedule(function()
          vim.notify('Notes synced', vim.log.levels.INFO)
        end)
      end
    end,
  })
end

-- Setup function
function M.setup()
  local notes_repo = get_notes_repo()
  if not notes_repo then
    vim.notify('Skipping notes setup: NOTES_REPO not configured', vim.log.levels.WARN)
    return
  end

  -- Keybindings
  vim.keymap.set('n', '<leader>nd', function()
    open_file(get_daily_file())
  end, { desc = '[N]otes: Open [D]aily log' })

  -- Auto-sync on write for files in notes repo
  vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = notes_repo .. '/*',
    callback = function(args)
      git_sync(args.file)
    end,
    desc = 'Auto-sync notes to git',
  })

  -- Auto-sync on VimLeavePre (before exit)
  vim.api.nvim_create_autocmd('VimLeavePre', {
    callback = function()
      -- Final sync before exit
      local notes_files = vim.fn.glob(notes_repo .. '/**/*.md', false, true)
      if #notes_files > 0 then
        git_sync(notes_files[1]) -- Trigger sync with any notes file
      end
    end,
    desc = 'Final notes sync before exit',
  })
end

return {
  -- Zettelkasten note-taking
  {
    'zk-org/zk-nvim',
    config = function()
      local notes_repo = get_notes_repo()
      if notes_repo then
        require('zk').setup {
          picker = 'telescope',
          lsp = {
            config = {
              cmd = { 'zk', 'lsp' },
              name = 'zk',
            },
            auto_attach = {
              enabled = true,
              filetypes = { 'markdown' },
            },
          },
        }

        -- Additional zk keybindings
        vim.keymap.set('n', '<leader>nn', "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>", { desc = '[N]otes: [N]ew permanent note' })
        vim.keymap.set('n', '<leader>nf', '<Cmd>ZkNotes { sort = { "modified" } }<CR>', { desc = '[N]otes: [F]ind notes' })
        vim.keymap.set('n', '<leader>nt', '<Cmd>ZkTags<CR>', { desc = '[N]otes: Search by [T]ags' })
        vim.keymap.set('v', '<leader>nz', ":'<,'>ZkNewFromTitleSelection<CR>", { desc = '[N]otes: New from selection' })
        vim.keymap.set('n', '<leader>nb', '<Cmd>ZkBacklinks<CR>', { desc = '[N]otes: Show [B]acklinks' })
        vim.keymap.set('n', '<leader>nl', '<Cmd>ZkLinks<CR>', { desc = '[N]otes: Show [L]inks' })
      end

      -- Setup notes system (keybinds, auto-sync)
      M.setup()
    end,
  },
}
