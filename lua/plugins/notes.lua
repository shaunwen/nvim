return {
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = 'cd app && npm install',
    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }
    end,
    keys = {
      { '<Leader>pv', '<cmd>MarkdownPreview<CR>', desc = 'Markdown preview' },
    },
  },
  {
    'bullets-vim/bullets.vim',
    ft = { 'markdown' },
  },
  {
    'jannis-baum/vivify.vim',
    cmd = { 'Vivify' },
    keys = {
      { '<Leader>mv', '<cmd>Vivify<CR>', desc = 'Vivify preview' },
    },
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown' },
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('config.plugins.render-markdown')
    end,
  },
  {
    'Zeioth/markmap.nvim',
    build = 'yarn global add markmap-cli',
    cmd = { 'MarkmapOpen', 'MarkmapSave', 'MarkmapWatch', 'MarkmapWatchStop' },
    opts = {
      html_output = '/tmp/markmap.html',
      hide_toolbar = false,
      grace_period = 3600000,
    },
    keys = {
      { '<Leader>mp', '<cmd>MarkmapWatch<CR>', desc = 'Markmap watch' },
    },
    config = function(_, opts)
      require('markmap').setup(opts)
    end,
  },
  {
    'mickael-menu/zk-nvim',
    ft = { 'markdown' },
    cmd = { 'ZkNew', 'ZkNotes', 'ZkTags', 'ZkInsertLink', 'ZkMatch', 'ZkBacklinks', 'ZkLinks' },
    config = function()
      require('config.plugins.zk')
    end,
  },
  {
    'aklt/plantuml-syntax',
    ft = { 'plantuml', 'puml' },
  },
  {
    'godlygeek/tabular',
    ft = { 'markdown' },
    cmd = { 'Tabularize' },
    init = function()
      local markdown_group = vim.api.nvim_create_augroup('MarkdownTextObjects', { clear = true })
      vim.api.nvim_create_autocmd('FileType', {
        group = markdown_group,
        pattern = 'markdown',
        callback = function(event)
          vim.b.surround_101 = '**\r**'
          vim.keymap.set(
            'x',
            '<Leader>a',
            '<cmd>Tabularize /|/l0l1<CR>',
            { buffer = event.buf, noremap = true, silent = true, desc = 'Align selected Markdown table' }
          )
        end,
      })
    end,
  },
}
