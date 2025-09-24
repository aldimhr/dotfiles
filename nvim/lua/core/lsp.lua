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

local function on_attach_c(client, bufnr)
  local ft = vim.bo[bufnr].filetype

  -- 🔹 Disable autoformat for C
  if ft ~= "c" and client.supports_method("textDocument/formatting") then
    vim.api.nvim_clear_autocmds({ group = lsp_format_augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = lsp_format_augroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ bufnr = bufnr, async = false })
      end,
    })
  else
    -- kalau mau total disable di clangd
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end

  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
end

-- c lang
lspconfig.clangd.setup({
  capabilities = capabilities,
  on_attach = on_attach_c,
})

-- astro
lspconfig.astro.setup({
  capabilities = capabilities,
  on_attach = on_attach,
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
  on_attach = on_attach,
})

-- lua lang
lspconfig.lua_ls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    Lua = {
      format = {
        enable = true,
      },
      diagnostics = {
        globals = { "vim" }, -- supaya 'vim' tidak dianggap error
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
  on_attach = on_attach,
})

-- emmet ls
-- for better html, css snippet
lspconfig.emmet_ls.setup {
  capabilities = capabilities,
  on_attach = on_attach,
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
