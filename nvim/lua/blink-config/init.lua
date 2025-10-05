local capabilities = {
  textDocument = {
    foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true
    }
  }
}

capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)

require('blink.cmp').setup({
  completion = {
    keyword = {
      range = 'prefix',
    },
    list = {
      selection = {
        preselect = false,
        auto_insert = true
      }
    },
    accept = {
      auto_brackets = {
        enabled = true,
        default_brackets = { '(', ')' },
      }
    }
  },
  signature = {
    enabled = true,
    trigger = {
      enabled = true,
    },
    window = {
      treesitter_highlighting = true,
    }
  },
  cmdline = {
    completion = {
      menu = {
        auto_show = function(ctx)
          return vim.fn.getcmdtype() == ':' and #ctx.line > 2
        end
      },
      ghost_text = {
        enabled = false,
      },
      list = {
        selection = {
          preselect = false,
          auto_insert = true,
        },
      },
    },
  },
  fuzzy = {
    implementation = 'lua',
  },
})
