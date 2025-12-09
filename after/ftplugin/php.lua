-- PHP filetype tweaks
vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.tabstop = 4

-- Keep formatoptions predictable for PHP
vim.opt_local.formatoptions:remove { 'o' } -- don't continue comments with o/O
