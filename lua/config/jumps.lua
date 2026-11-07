local M = {}

function M.jump(key)
  local keys = vim.api.nvim_replace_termcodes("<Esc>" .. key, true, false, true)
  local jumps = vim.fn.getjumplist()
  for _ = 1, #jumps[1] + 1 do
    local index = vim.fn.getjumplist()[2]
    local ok, err = pcall(vim.cmd.normal, { keys, bang = true })
    if ok then
      return
    end
    if not tostring(err):match("E19:") then
      error(err)
    end
    --[[ Failed jumps advance the history index even when their line is stale. ]]
    if vim.fn.getjumplist()[2] == index then
      return
    end
  end
end

return M
