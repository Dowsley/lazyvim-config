-- Godot connects to a server pipe in the project root for external editing.
-- The pipe is opened when nvim starts inside a project (or one level below it).
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
