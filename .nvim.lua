-- project local bindings and helper methods

vim.api.nvim_set_keymap('n', '<F5>', ':so %<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F6>', ':PlenaryBustedFile %<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F9>', ':PlenaryBustedDirectory test/ { sequential = true } <CR>', { noremap = true, silent = true })

