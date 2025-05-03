local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()


lspconfig.cssls.setup({
  capabilities = capabilities,
        on_attach = function(client, bufnr)
    -- Nonaktifkan fitur selain formatting
             client.server_capabilities.documentFormattingProvider = true
    -- Format otomatis sebelum save
            if client.server_capabilities.documentFormattingProvider then
                vim.api.nvim_create_autocmd("BufWritePre", {
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format({ async = false })
                    end,
                })
            end
        end,
})
