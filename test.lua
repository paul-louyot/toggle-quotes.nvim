-- run this file via `:lua dofile('test.lua')`

package.loaded['lua.util'] = nil
local util = require("lua.util")

function assert_equal(expected, actual)
  if expected ~= actual then
    error('\nexpected: ' .. expected  .. '\n' .. 'actual: ' .. actual)
  end
end

assert_equal([['']], util.toggle_quotes([[""]]))
assert_equal([[""]], util.toggle_quotes([['']]))
assert_equal([[]], util.toggle_quotes([[]]))
assert_equal('"test"', util.toggle_quotes("'test'"))
assert_equal("'test'", util.toggle_quotes('"test"'))
assert_equal([['te\'st']], util.toggle_quotes([["te'st"]]))
assert_equal([["te'st"]], util.toggle_quotes([['te\'st']]))
assert_equal([['Test', 'Test2']], util.toggle_quotes([["Test", "Test2"]]))
print('Tests are green')
