local ls = require('luasnip')

return {
  ls.s('shebang', {
    ls.t({ '#!/bin/sh', '' }),
    ls.i(0),
  }),
}
