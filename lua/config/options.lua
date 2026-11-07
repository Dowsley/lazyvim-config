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
opt.background = "dark"
opt.signcolumn = "yes"
opt.cursorline = true
opt.cursorlineopt = "number"
-- Right-aligns the cursor line number, which vim otherwise left-aligns.
opt.statuscolumn = "%s%=%{v:relnum == 0 ? v:lnum : v:relnum} "
opt.scrolloff = 8
opt.clipboard = "unnamedplus"
opt.undofile = true
opt.splitright = true
opt.splitbelow = true
opt.mousescroll = "ver:3,hor:0"
opt.updatetime = 200

vim.filetype.add({
  extension = {
    metal = "metal",
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
