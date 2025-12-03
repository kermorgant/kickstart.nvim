local ts_utils = require 'nvim-treesitter.ts_utils'

local M = {}

function M.delete_to_closing_pair()
  local node = ts_utils.get_node_at_cursor()
  if not node then
    vim.cmd 'normal! D'
    return
  end

  local start_row, start_col, end_row, end_col = node:range()
  local cursor_row, cursor_col = unpack(vim.api.nvim_win_get_cursor(0))

  -- if cursor is after end of node, fallback
  if cursor_row - 1 > end_row or (cursor_row - 1 == end_row and cursor_col >= end_col) then
    vim.cmd 'normal! D'
    return
  end

  -- restrict to same line for now (you can expand this to multiline later)
  if cursor_row - 1 ~= end_row then
    vim.api.nvim_buf_set_text(0, cursor_row - 1, cursor_col, end_row, 0, {})
  else
    vim.api.nvim_buf_set_text(0, cursor_row - 1, cursor_col, end_row, end_col, {})
  end
end

function M.change_to_closing_pair()
  M.delete_to_closing_pair()
  vim.cmd 'startinsert'
end

return M
