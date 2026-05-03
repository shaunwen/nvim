require('catppuccin').setup({
  flavour = 'macchiato',
  auto_integrations = true,
  custom_highlights = function()
    return {
      Visual = { bg = '#3E4452', fg = '#FFAB00', style = { 'bold' } },
      -- BlinkCmpLabelMatch = { fg = '#CAD3F5', style = { 'bold' } },
      BlinkCmpMenuSelection = { fg = '#FFAB00', style = { 'bold' } },
      FzfLuaFzfMatch = { fg = '#EED49F', style = { 'bold' } },
      FzfLuaFzfMatchCurrent = { fg = '#F5A97F', style = { 'bold' } },
    }
  end,
})

vim.cmd.colorscheme('catppuccin')
