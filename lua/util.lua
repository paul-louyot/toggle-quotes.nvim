local M = {}

local function find_quote_pairs(str)
  local pairs = {}  -- Table to store the pairs of indexes
  local length = #str
  local i = 1  -- Start iterating from the first character
  local lead_quote

  while i <= length do
      local char = str:sub(i, i)
      local char_is_quote = (char == '"' or char == "'")
      local char_matches_first_quote = (lead_quote == nil or char == lead_quote)

      -- Check if the character is a single or double quote
      if char_is_quote and char_matches_first_quote then
          -- We found a quote, now find its matching pair
          local quote = char
          local escaped = false
          local pair_start = i

          -- Move forward to find the matching quote
          for j = i + 1, length do
              local next_char = str:sub(j, j)

              -- Check if it's an escaped quote
              if next_char == '\\' then
                  escaped = not escaped  -- Toggle escape flag
              elseif next_char == quote and not escaped then
                  table.insert(pairs, {pair_start, j})
                  lead_quote = char
                  i = j  -- Move past the matching quote
                  break
              else
                  escaped = false  -- Reset escape flag
              end
          end
      end

      i = i + 1  -- Move to the next character in the string
  end

  return pairs
end

local function toggle_quotes_at_pairs(str, quote_pairs)
  -- Convert the string to a mutable array of characters
  local chars = {}
  for i = 1, #str do
      chars[i] = str:sub(i, i)
  end

  -- Iterate over each quote pair
  for _, pair in ipairs(quote_pairs) do
      local start_idx = pair[1]
      local end_idx = pair[2]

      -- Determine which quote is being used at this position
      local quote = chars[start_idx]
      local new_quote = quote == '"' and "'" or '"'

      -- Toggle the quotes (from ' to " or from " to ')
      chars[start_idx] = new_quote
      chars[end_idx] = new_quote

      -- Remove redundant escapes and escape unescaped quotes
      for i = start_idx + 1, end_idx - 1 do
          -- If we find a redundant escape (e.g., \' or \"), remove the backslash
          if chars[i] == "\\" and (chars[i + 1] == quote or chars[i + 1] == new_quote) then
              chars[i] = ""  -- Remove the escape character
          end

          -- Escape quotes inside the string if not already escaped
          if chars[i] == new_quote and (i == 1 or chars[i - 1] ~= '\\') then
              chars[i] = '\\' .. new_quote
          end
      end
  end

  -- Convert the characters back to a string
  return table.concat(chars)
end


local function toggle_quotes(str)
  return toggle_quotes_at_pairs(str, find_quote_pairs(str))
end

M.toggle_quotes = toggle_quotes

return M
