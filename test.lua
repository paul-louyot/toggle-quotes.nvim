-- run this file via `:lua dofile('test.lua')`

package.loaded['lua.util'] = nil
local util = require("lua.util")

local function assert_array_equal(expected, actual)
  -- Check if the lengths are the same
  if #expected ~= #actual then
      error("Arrays have different lengths! Expected length: " .. #expected .. ", Actual length: " .. #actual)
  end

  -- Check if each element in the arrays is the same
  for i = 1, #expected do
      local expected_subarray = expected[i]
      local actual_subarray = actual[i]

      -- Check if the sub-arrays are of the same length
      if #expected_subarray ~= #actual_subarray then
          error("Sub-arrays at index " .. i .. " have different lengths!")
      end

      -- Compare corresponding elements of the sub-arrays
      for j = 1, #expected_subarray do
          if expected_subarray[j] ~= actual_subarray[j] then
              error("Arrays are not equal at index " .. i .. ", " .. j ..
                  "!\nExpected: " .. expected_subarray[j] .. "\nActual: " .. actual_subarray[j])
          end
      end
  end
end

local function assert_string_equal(expected, actual)
  if expected ~= actual then
    error('\nexpected: ' .. expected  .. '\n' .. 'actual: ' .. actual)
  end
end

-- assert_array_equal({{1, 2}}, util.find_quote_pairs([['']]))
-- assert_array_equal({{1, 2}}, util.find_quote_pairs([[""]]))
-- assert_array_equal({{1, 4}}, util.find_quote_pairs([["''"]]))
-- assert_array_equal({{1, 4}}, util.find_quote_pairs([['""']]))
-- assert_array_equal({{1, 4}}, util.find_quote_pairs([['""']]))
-- assert_array_equal({{4, 5}}, util.find_quote_pairs([[', ""]]))
-- assert_array_equal({{1, 2}, {3, 4}}, util.find_quote_pairs([['''']]))

assert_string_equal([['']], util.toggle_quotes([[""]]))
assert_string_equal([[""]], util.toggle_quotes([['']]))
assert_string_equal([[]], util.toggle_quotes([[]]))
assert_string_equal([["test"]], util.toggle_quotes([['test']]))
assert_string_equal([['test']], util.toggle_quotes([["test"]]))
assert_string_equal([['te\'st']], util.toggle_quotes([["te'st"]]))
assert_string_equal([["te'st"]], util.toggle_quotes([['te\'st']]))
assert_string_equal([['', '']], util.toggle_quotes([["", ""]]))
assert_string_equal([[', '']], util.toggle_quotes([[', ""]]))
assert_string_equal([['', '']], util.toggle_quotes([["", '']]))
assert_string_equal([[' "" ']], util.toggle_quotes([[" \"\" "]]))

print('Tests are green')
