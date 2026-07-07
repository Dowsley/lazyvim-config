vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true
opt.ignorecase = true
opt.smartcase = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.clipboard = "unnamedplus"
opt.undofile = true
opt.splitright = true
opt.splitbelow = true
opt.mousescroll = "ver:3,hor:0"
opt.updatetime = 200

local map = vim.keymap.set
map("n", "<leader>e", function() require("oil").toggle_float() end, { desc = "File explorer (oil)" })
map("n", "<leader><leader>", "<cmd>FzfLua files<cr>", { desc = "Find files" })
map("n", "<leader>,", "<cmd>FzfLua buffers<cr>", { desc = "Switch buffer" })
map("n", "<leader>/", "<cmd>FzfLua live_grep<cr>", { desc = "Search project (ripgrep)" })
map("n", "<leader>ss", "<cmd>FzfLua lsp_document_symbols<cr>", { desc = "Document symbols" })
map("n", "<leader>sS", "<cmd>FzfLua lsp_live_workspace_symbols<cr>", { desc = "Workspace symbols" })
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Close buffer" })

-- Start a server pipe Godot can connect to for external editing
do
  local cwd = vim.fn.getcwd()
  for _, suffix in ipairs({ "/", "/../" }) do
    local project_path = cwd .. suffix
    if vim.uv.fs_stat(project_path .. "project.godot") then
      local pipe = project_path .. "server.pipe"
      if not vim.uv.fs_stat(pipe) then
        vim.fn.serverstart(pipe)
      end
      break
    end
  end
end

vim.filetype.add({
  extension = {
    vs = "glsl",
    fs = "glsl",
    vert = "glsl",
    frag = "glsl",
    geom = "glsl",
    comp = "glsl",
    tesc = "glsl",
    tese = "glsl",
  },
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")
