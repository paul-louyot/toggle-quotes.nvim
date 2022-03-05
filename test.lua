package.loaded['lua.util'] = nil
local util = require("lua.util")

function assert_equal(expected, actual)
  if expected ~= actual then
    error('\nexpected: ' .. expected  .. '\n' .. 'actual: ' .. actual)
  end
end

assert_equal('"test"', util.get_new_line("'test'"))
assert_equal("'test'", util.get_new_line('"test"'))
-- assert_equal([['te\'st']], util.get_new_line([["te'st"]]))
print('Tests are green')
