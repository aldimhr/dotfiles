-- Mapping untuk mempercepat resizing vsplit
vim.api.nvim_set_keymap('n', '<C-W>>', ':vertical resize +8<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-W><', ':vertical resize -8<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-W>+', ':resize +5<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-W>-', ':resize -5<CR>', { noremap = true, silent = true })

-- exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', [[<C-\><C-n>]], { noremap = true, silent = true })

-- change copy paste behavior
vim.keymap.set('x', 'p', '"_dP')
