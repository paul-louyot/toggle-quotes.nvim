local M = {}

local function getIndexes(line, substring)
  local indexes_list = {}
  local index = 0
  while index do
    index = string.find(line, substring, index + 1)
    if index then
      indexes_list[#indexes_list+1] = index
    end
  end
  return indexes_list
end

local function shouldToggle()
  local should_toggle = (#double_quotes_indexes_list == 0 and #simple_quotes_indexes_list == 2) or
                        (#simple_quotes_indexes_list == 0 and #double_quotes_indexes_list == 2)
  return should_toggle
end

function M.toggle_quotes()

  local cursor_0 = vim.api.nvim_win_get_cursor(0)
  local row = cursor_0[1]
  local col = cursor_0[2]
  local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]


  double_quotes_indexes_list = getIndexes(line, '"')
  simple_quotes_indexes_list = getIndexes(line, "'")

  if not shouldToggle() then
    return
  end

  local new_quote
  local old_quote
  local index_list
  if #simple_quotes_indexes_list == 2 then
    new_quote = '"'
    old_quote = "'"
    indexes_list = simple_quotes_indexes_list
  elseif #double_quotes_indexes_list == 2 then
    new_quote = "'"
    old_quote = '"'
    indexes_list = double_quotes_indexes_list
  else
    return
  end

  local start = indexes_list[1]
  local finish = indexes_list[2]
  local with_quotes = string.sub(line, start, finish)
  local str = string.sub(line, start +1, finish -1)
  local quoted_text = new_quote .. str .. new_quote
  local new_line = string.gsub(line, with_quotes, quoted_text)
  vim.api.nvim_buf_set_lines(0, row - 1, row, false, { new_line })
end

return M

