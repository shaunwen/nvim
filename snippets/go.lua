local ls = require('luasnip')

local snip = ls.s
local text = ls.t
local insert = ls.i

return {
  snip('test', {
    text('func '),
    insert(1, 'Name'),
    text('(t *testing.T)'),
    text({ ' {', '' }),
    text('\t'),
    insert(0),
    text({ '', '}' }),
  }),
  snip('typei', {
    text('type '),
    insert(1, 'Name'),
    text({ ' interface {', '' }),
    text('\t'),
    insert(0),
    text({ '', '}' }),
  }),
  snip('types', {
    text('type '),
    insert(1, 'Name'),
    text({ ' struct {', '' }),
    text('\t'),
    insert(0),
    text({ '', '}' }),
  }),
}
