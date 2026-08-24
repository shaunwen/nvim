local ls = require('luasnip')

return {
  ls.s('shebang', {
    ls.t({ '#!/usr/bin/env python', '' }),
    ls.i(0),
  }),
}
