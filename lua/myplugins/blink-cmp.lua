-- Blink.cmp configuration
local status, blink = pcall(require, 'blink.cmp')
if not status then
  return
end

-- Load friendly snippets for LuaSnip
-- require('luasnip.loaders.from_vscode').lazy_load()

blink.setup({
  fuzzy = { implementation = 'rust' },
  signature = {
    enabled = true,
    window = { border = 'rounded' },
  },
  keymap = {
    preset = 'enter',
    ['<C-p>'] = { 'show', 'accept' }, -- manually trigger completion
  },
  snippets = {
    preset = 'luasnip',
  },
  completion = {
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
      window = { border = 'rounded' },
    },
    menu = {
      border = 'rounded',
      draw = {
        components = {
          kind_icon = {
            text = function(ctx)
              local icon = ctx.kind_icon
              if vim.tbl_contains({ 'Path' }, ctx.source_name) then
                local dev_icon, _ = require('nvim-web-devicons').get_icon(ctx.label)
                if dev_icon then
                  icon = dev_icon
                end
              else
                icon = require('lspkind').symbolic(ctx.kind, {
                  mode = 'symbol',
                })
              end

              return icon .. ctx.icon_gap
            end,

            -- Optionally, use the highlight groups from nvim-web-devicons
            -- You can also add the same function for `kind.highlight` if you want to
            -- keep the highlight groups in sync with the icons.
            highlight = function(ctx)
              local hl = ctx.kind_hl
              if vim.tbl_contains({ 'Path' }, ctx.source_name) then
                local dev_icon, dev_hl = require('nvim-web-devicons').get_icon(ctx.label)
                if dev_icon then
                  hl = dev_hl
                end
              end
              return hl
            end,
          },
          label = {
            text = function(ctx)
              local source_labels = {
                snippets = '[Snippet] ',
                lsp = '[LSP] ',
                copilot = '[AI] ',
                buffer = '[Buffer] ',
                path = '[Path] ',
              }
              local prefix = source_labels[ctx.source_name:lower()] or ''
              return prefix .. ctx.label
            end,
          },
        },
      },
    },
  },
  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = 'mono',
  },
  sources = {
    default = { 'copilot', 'lsp', 'snippets', 'buffer', 'path' },
    providers = {
      buffer = {
        opts = {
          -- get all buffers, even ones like nvim-tree
          get_bufnrs = vim.api.nvim_list_bufs,
        },
      },
      copilot = {
        name = 'copilot',
        module = 'blink-copilot',
        score_offset = 100,
        async = true,
        opts = {
          max_completions = 3,
          kind_icon = '',
          auto_refresh = { backward = true, forward = true },
        },
      },
    },
  },
})
