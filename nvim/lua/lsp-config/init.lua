require('vim.lsp')

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.lsp.config('*', {
  root_markers = { '.git' },
  capabilities = {
    textDocument = {
      semanticTokens = {
        multilineTokenSupport = true,
      }
    }
  }
})

vim.api.nvim_create_autocmd("BufWritePre", {
  buffer = buffer,
  callback = function()
    vim.lsp.buf.format { async = false }
  end
})

vim.keymap.set('n', '<leader>fa', vim.lsp.buf.format, { desc = "Format all buffers" })
vim.keymap.set('n', 'gu', vim.lsp.buf.references, { desc = "List references" })
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = "Go to implementation" })
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = "Hover documentation or signature" })
vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = "List references" })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Show diagnostics in floating window" })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
vim.keymap.set('n', ']d', vim.diagnostic.goto_prev, { desc = "Go to next diagnostic" })

local lsp_servers = {
  pyright = "basedpyright",
  lua = "lua-language-server",
}

for server_name, lsp_executable in pairs(lsp_servers) do
  if vim.fn.executable(lsp_executable) == 1 then
    vim.lsp.enable(server_name)
  end
end

vim.lsp.config('basedpyright', {
  fyletypes = { 'python' },
  root_markers = { 
    "pyproject.toml", 
    "setup.py", 
    "setup.cfg", 
    "requirements.txt", 
    "Pipfile", 
    "pyrightconfig.json", 
    ".git"
  },
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "openFilesOnly",
        useLibraryCodeForTypes = true
      }
    }
  }
})
