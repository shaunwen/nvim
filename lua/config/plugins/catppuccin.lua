require('catppuccin').setup({
  flavour = 'macchiato',
  auto_integrations = true,
  custom_highlights = function()
    return {
      Visual = { bg = '#3E4452', fg = '#FFAB00', style = { 'bold' } },
    }
  end,
})

vim.cmd.colorscheme('catppuccin')
