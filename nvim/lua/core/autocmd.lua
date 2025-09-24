-- config opt - untuk SEMUA file types
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "*" }, -- Semua file types
  callback = function(args)
    -- Disable LSP formatting
    vim.bo.formatexpr = ""
    vim.keymap.set("n", "<leader>f", "<nop>", { buffer = true })

    -- Disable syntax highlighting
    pcall(vim.treesitter.stop, args.buf)
    vim.cmd("syntax off")

    -- vim.cmd("TSBufDisable highlight")

    -- Disable indent guides
    vim.b.miniindentscope_disable = true

    vim.notify("no colors, no formatter for " .. vim.bo.filetype, vim.log.levels.INFO)
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.lua" },
  callback = function()
    vim.defer_fn(function()
      pcall(vim.cmd, "TSBufDisable highlight")
      vim.cmd("syntax off")
      vim.notify("TSBufDisable for Lua buffer", vim.log.levels.INFO)
    end, 10) -- Delay 100ms
  end,
})
