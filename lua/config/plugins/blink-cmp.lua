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
    ['<C-y>'] = { 'accept' },
  },
  cmdline = {
    keymap = { preset = 'cmdline' },
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
        columns = { { 'kind_icon' }, { 'source_name', 'label', 'label_description', gap = 1 } },
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
          source_name = {
            text = function(ctx)
              local source_labels = {
                snippets = '[Snippet]',
                lsp = '[LSP]',
                copilot = '[AI]',
                buffer = '[Buffer]',
                path = '[Path]',
              }
              return source_labels[ctx.source_name:lower()] or ctx.source_name
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
    default = { 'lazydev', 'copilot', 'lsp', 'snippets', 'buffer', 'path' },
    providers = {
      snippets = {
        opts = {
          use_label_description = true,
        },
        -- snippets that name themselves (e.g. repo snippets, whose trigger
        -- carries a project prefix) show the name, but still match on the trigger
        transform_items = function(_, items)
          local luasnip = require('luasnip')
          for _, item in ipairs(items) do
            local snip = item.data.snip_id and luasnip.get_id_snippet(item.data.snip_id)
            if snip and snip.name and snip.name ~= item.label then
              item.filterText = item.filterText or item.insertText or item.label
              item.label = snip.name
            end
          end
          return items
        end,
      },
      buffer = {
        opts = {
          -- only real file buffers: scratch buffers (blink's own menu and
          -- documentation windows included) would otherwise be indexed as words
          get_bufnrs = function()
            return vim.tbl_filter(function(bufnr)
              return vim.bo[bufnr].buftype == '' and vim.api.nvim_buf_is_loaded(bufnr)
            end, vim.api.nvim_list_bufs())
          end,
        },
      },
      path = {
        opts = {
          show_hidden_files_by_default = true,
        },
      },
      lazydev = {
        name = 'LazyDev',
        module = 'lazydev.integrations.blink',
        score_offset = 100,
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
