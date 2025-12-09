require('onedark').setup {
  style = 'darker',
  highlights = {
    -- customise selection colors to be orange
    Visual = { bg = '#3E4452', fg = '#FFAB00', fmt = 'bold' },
    -- VisualNOS = { bg = '#3E4452', fg = '#FFAB00', fmt = 'bold' },
  },
}
require('onedark').load()
