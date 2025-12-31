-- Mapping untuk mempercepat resizing vsplit
vim.api.nvim_set_keymap('n', '<C-W>>', ':vertical resize +8<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-W><', ':vertical resize -8<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-W>+', ':resize +5<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-W>-', ':resize -5<CR>', { noremap = true, silent = true })

-- exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', [[<C-\><C-n>]], { noremap = true, silent = true })

-- change copy paste behavior
vim.keymap.set('x', 'p', '"_dP')

-- fzf.nvim - open buffers
vim.keymap.set('n', '<leader>eb', function()
  require('fzf-lua').buffers()
end, { desc = "FZF Buffers" })

-- fzf.nvim - open files
vim.keymap.set('n', '<leader>ff', function()
  require('fzf-lua').files()
end, { desc = "FZF Files" })


-- Mini.nvim
-- Open Files
vim.keymap.set('n', '<leader>ef', function()
  require('mini.files').open()
end, { desc = "Mini Files" })
