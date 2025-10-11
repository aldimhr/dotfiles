local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local lsp_format_augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local function on_attach(client, bufnr)
  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_clear_autocmds({ group = lsp_format_augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = lsp_format_augroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ bufnr = bufnr, async = false })
      end,
    })
  end

  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
end

local function on_attach_minimal(client, bufnr)
  -- Disable semua formatting dan highlighting capabilities
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
  client.server_capabilities.semanticTokensProvider = nil
  client.server_capabilities.documentHighlightProvider = false
  client.server_capabilities.colorProvider = false

  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
end

-- c lang
lspconfig.clangd.setup({
  capabilities = capabilities,
  on_attach = on_attach_minimal,
})

-- astro
lspconfig.astro.setup({
  capabilities = capabilities,
  on_attach = on_attach_minimal,
})

-- tailwindcss
lspconfig.tailwindcss.setup({
  capabilities = capabilities,
  settings = {
    tailwindCSS = {
      experimental = {
        classRegex = {
          { "clsx\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
          { "tw`([^`]*)",        "tw`([^`]*)" },
          { "cn\\(([^)]*)\\)",   "[\"'`]([^\"'`]*).*?[\"'`]" }, -- opsional, classnames lib
        },
      },
    },
  },
})

-- typescript-language-server
lspconfig.tsserver.setup({
  capabilities = capabilities,
  on_attach = on_attach_minimal,
})

-- lua lang
lspconfig.lua_ls.setup({
  capabilities = capabilities,
  on_attach = on_attach_minimal,
  settings = {
    Lua = {
      format = {
        enable = false, -- disable formatting
      },
      diagnostics = {
        globals = { "vim" }, -- supaya 'vim' tidak dianggap error
      },
      semantic = {
        enable = false,
      },
    },
  },
})

-- css
lspconfig.cssls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

-- html
lspconfig.html.setup({
  capabilities = capabilities,
  on_attach = on_attach_minimal,
})

-- emmet ls
-- for better html, css snippet
lspconfig.emmet_ls.setup {
  capabilities = capabilities,
  on_attach = on_attach_minimal,
  -- javascript,
  filetypes = {
    "html",
    "css",
    "vue",
    "jsx",
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "tsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
}


