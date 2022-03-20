local M = {}

local indexes_list = {}

local function should_handle_backticks(filetype)
  filetypes = {}
  filetypes["javascript"] = true
  filetypes["typescript"] = true
  filetypes["go"] = true
  filetypes["markdown"] = true
  filetypes["svelte"] = true
  return (filetypes[filetype] ~= nil)
end

local function get_quotes_list()
  local quotes = {"'", "\""}
  if should_handle_backticks(vim.bo.filetype) then
    table.insert(quotes, "`")
  end
  return quotes
end

local function get_indexes(line, substring)
  local indexes_list = {}
  local index = 0
  while index do
    index = string.find(line, substring, index + 1)
    if index and ((line:sub(index-1, index-1) ~= '\\') or (line:sub(index-2, index-2) == '\\')) then
      indexes_list[#indexes_list+1] = index
    end
  end
  return indexes_list
end

local function get_first_quote_info(indexes_list)
  local start = nil
  local char = nil
  local table = {}
  for key, table in pairs(indexes_list) do
    if table[1] and ( not start or (table[1] < start)) then
      start = table[1]
      char = key
    end
  end

  if not start then return nil end

  table.start = start
  table.char = char
  return table
end

local function get_first_pair(indexes_list)
  local pair = {}
  local first_quote_info = get_first_quote_info(indexes_list)

  if not first_quote_info then return nil end

  pair.char = first_quote_info.char
  pair.start = first_quote_info.start
  pair.stop = indexes_list[pair.char][2]
  return pair
end

local function get_next_quote(quote)
  local quotes = get_quotes_list()
  local table = {}
  for i, v in ipairs(quotes) do
    table[v] = ( i ~= #quotes and quotes[i+1] or quotes[1])
  end
  return table[quote]
end

local function toggle_pair(line, start, stop)
  local quote, next_quote, quoted_text, inner_text, new_inner_text, new_quoted_text, new_line

  quote = line:sub(start, start)
  next_quote = get_next_quote(quote)
  quoted_text = line:sub(start, stop)
  inner_text = line:sub(start + 1, stop - 1)
  new_inner_text = string.gsub(inner_text, '\\' .. quote, quote)
  new_inner_text = string.gsub(new_inner_text, next_quote, '\\' .. next_quote)
  new_quoted_text = next_quote .. new_inner_text .. next_quote
  new_line = string.gsub(line, quoted_text, new_quoted_text)
  return new_line
end

local function get_new_line(line)
  local quotes = get_quotes_list()
  for i, quote in ipairs(quotes) do
    indexes_list[quote] = get_indexes(line, quote)
  end
  local first_pair = get_first_pair(indexes_list)

  if not first_pair then return line end

  local new_line = toggle_pair(line, first_pair.start, first_pair.stop)
  return new_line
end

M.get_new_line = get_new_line
M.should_handle_backticks = should_handle_backticks

return M
