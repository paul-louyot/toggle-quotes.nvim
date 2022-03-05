local util = require('util')

local M = {}

function M.toggle_quotes()

  local cursor_0 = vim.api.nvim_win_get_cursor(0)
  local row = cursor_0[1]
  local col = cursor_0[2]
  local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
  local new_line = util.get_new_line(line)

  vim.api.nvim_buf_set_lines(0, row - 1, row, false, { new_line })
end

return M

