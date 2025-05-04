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
end

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
