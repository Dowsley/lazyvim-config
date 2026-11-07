local M = {}
local path = vim.fn.stdpath("state") .. "/colorscheme"

function M.select(name)
  local ok, err = pcall(vim.cmd.colorscheme, name)
  if not ok then
    vim.notify("Could not apply theme: " .. tostring(err), vim.log.levels.ERROR)
    return
  end

  local saved, save_err = pcall(function()
    vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
    assert(vim.fn.writefile({ name }, path) == 0, "Could not write theme preference")
  end)
  if not saved then
    vim.notify("Could not save theme: " .. tostring(save_err), vim.log.levels.ERROR)
  end
end

function M.restore()
  if vim.fn.filereadable(path) == 0 then
    return
  end
  local ok, lines = pcall(vim.fn.readfile, path)
  if not ok or not lines[1] or lines[1] == "" then
    return
  end
  local restored, err = pcall(vim.cmd.colorscheme, lines[1])
  if not restored then
    vim.notify("Could not restore saved theme: " .. tostring(err), vim.log.levels.WARN)
  end
end

return M
