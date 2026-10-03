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
    -- Note creation and search must work from any buffer, but the keymaps are
    -- defined in config, which ft/cmd only run once a markdown buffer exists.
    -- Without these stubs <leader>zd falls through to the builtin zd (E351).
    keys = {
      { '<leader>zd', desc = 'New daily note' },
      { '<leader>zn', desc = 'New zettel' },
      { '<leader>zw', desc = 'New work log (pick type)' },
      { '<leader>zP', desc = 'New problem/solution note' },
      { '<leader>ze', desc = 'New evergreen note' },
      { '<leader>zD', desc = 'New design note' },
      { '<leader>zR', desc = 'New weekly review' },
      { '<leader>zq', desc = 'New question note' },
      { '<leader>zm', desc = 'New MOC' },
      { '<leader>zo', desc = 'Open notes by modified' },
      { '<leader>zt', desc = 'Browse tags' },
      { '<leader>zf', desc = 'Search notes' },
      { '<leader>zf', mode = 'v', desc = 'Search notes (selection)' },
      { '<leader>zF', desc = 'Search notes (filtered)' },
    },
    config = function()
      require('config.plugins.zk')
    end,
  },
  {
    'aklt/plantuml-syntax',
    ft = { 'plantuml', 'puml' },
  },
  {
    'weirongxu/plantuml-previewer.vim',
    dependencies = { 'tyru/open-browser.vim', 'aklt/plantuml-syntax' },
    cmd = { 'PlantumlOpen', 'PlantumlStart', 'PlantumlStop', 'PlantumlSave', 'PlantumlToggle' },
    init = function()
      vim.g['plantuml_previewer#java_path'] = vim.fn.stdpath('config') .. '/scripts/plantuml-java'
      local jar = '/opt/homebrew/opt/plantuml/libexec/plantuml.jar'
      if vim.fn.filereadable(jar) == 1 then
        vim.g['plantuml_previewer#plantuml_jar_path'] = jar
      end
    end,
    keys = {
      {
        '<Leader>pp',
        function()
          require('config.plugins.plantuml-previewer').preview()
        end,
        desc = 'PlantUML preview (block under cursor in Markdown)',
      },
      {
        '<Leader>ps',
        function()
          require('config.plugins.plantuml-previewer').stop()
        end,
        desc = 'Stop PlantUML preview updates',
      },
    },
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
          -- bold via surround char 'e' (ASCII 101): visual Se, normal ysiwe
          vim.b.surround_101 = '**\r**'
          vim.keymap.set('x', '<Leader>a', '<cmd>Tabularize /|/l0l1<CR>', {
            buffer = event.buf,
            noremap = true,
            silent = true,
            desc = 'Align selected Markdown table',
          })
        end,
      })
    end,
  },
}
