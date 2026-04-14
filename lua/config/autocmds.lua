-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Godot: auto-start nvim server pipe when in a Godot project
local cwd = vim.fn.getcwd()
local paths_to_check = { "/", "/../" }
for _, suffix in ipairs(paths_to_check) do
  local project_path = cwd .. suffix
  if vim.uv.fs_stat(project_path .. "project.godot") then
    local pipe = project_path .. "server.pipe"
    if not vim.uv.fs_stat(pipe) then
      vim.fn.serverstart(pipe)
    end
    break
  end
end

-- Open telescope file browser instead of netrw when opening a directory
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function(data)
    if vim.fn.isdirectory(data.file) == 1 then
      vim.cmd.cd(data.file)
      vim.cmd.bdelete()
      require("telescope").extensions.file_browser.file_browser()
    end
  end,
})

-- GLSL filetype detection
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
