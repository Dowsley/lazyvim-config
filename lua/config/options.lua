-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.guicursor = "a:block"
vim.opt.mousescroll = "ver:3,hor:0"
vim.opt.updatetime = 200
vim.opt.timeoutlen = 0
vim.opt.list = false

-- Disable netrw (the ugly built-in file browser)
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1
