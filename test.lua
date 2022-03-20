-- run this file via `:lua dofile('test.lua')`

package.loaded['lua.util'] = nil
local util = require("lua.util")

function assert_equal(expected, actual)
  if expected ~= actual then
    print("actual: ", actual)
    print("expected: ", expected)
    error('Test failed.')
  end
end

assert_equal(true, util.should_handle_backticks('javascript'))
assert_equal(true, util.should_handle_backticks('go'))
assert_equal(true, util.should_handle_backticks('typescript'))
assert_equal(true, util.should_handle_backticks('markdown'))
assert_equal(true, util.should_handle_backticks('svelte'))
assert_equal(false, util.should_handle_backticks('ruby'))
assert_equal([['']], util.get_new_line([[""]]))
assert_equal([[""]], util.get_new_line([['']]))
assert_equal([[]], util.get_new_line([[]]))
assert_equal('"test"', util.get_new_line("'test'"))
assert_equal("'test'", util.get_new_line('"test"'))
assert_equal([['te\'st']], util.get_new_line([["te'st"]]))
assert_equal([["te'st"]], util.get_new_line([['te\'st']]))
print('Tests are green')
