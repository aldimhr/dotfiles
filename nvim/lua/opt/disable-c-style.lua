-- Disable formatter & syntax highlighting khusus untuk C
vim.api.nvim_create_autocmd("FileType", {
  pattern = "c",
  callback = function()
    -- 🔹 Disable LSP formatting
    vim.bo.formatexpr = ""
    vim.keymap.set("n", "<leader>f", "<nop>", { buffer = true })

    -- 🔹 Disable syntax highlighting
    vim.treesitter.stop()
    vim.cmd("syntax off")

    -- 🔹 Disable indent guides
    vim.b.miniindentscope_disable = true

    vim.notify("no colors, no formatter for C", vim.log.levels.INFO)
  end,
})
