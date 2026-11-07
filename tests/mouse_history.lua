local child = vim.fn.jobstart({ vim.v.progpath, "--embed", "-u", "NONE", "-i", "NONE" }, { rpc = true })
assert(child > 0, "Could not start Neovim")
local root = vim.fn.tempname()

local function request(method, ...)
  return vim.rpcrequest(child, method, ...)
end

local function check(line)
  assert(request("nvim_get_mode").mode == "n", "Side button started a selection")
  local cursor = request("nvim_win_get_cursor", 0)
  assert(cursor[1] == line and cursor[2] == 0, "Side button moved to the mouse position: " .. vim.inspect(cursor))
end

local function click(button, line, drag)
  request("nvim_input_mouse", button, "press", "", 0, 4, 8)
  request("nvim_command", "redraw")
  if drag then
    request("nvim_input_mouse", button, "drag", "", 0, 5, 9)
    request("nvim_command", "redraw")
  end
  request("nvim_input_mouse", button, "release", "", 0, 4, 8)
  request("nvim_command", "redraw")
  check(line)
end

local ok, err = pcall(function()
  request("nvim_ui_attach", 80, 24, { rgb = true })
  request("nvim_exec_lua", 'dofile("lua/config/options.lua"); dofile("lua/config/keymaps.lua")', {})
  local lines = {}
  for i = 1, 100 do
    lines[i] = "line " .. i .. " some text"
  end
  request("nvim_buf_set_lines", 0, 0, -1, false, lines)
  for _, line in ipairs({ 1, 10, 20, 30 }) do
    request("nvim_command", "normal! " .. line .. "G")
  end
  request("nvim_command", "redraw")

  for _, line in ipairs({ 20, 10, 1, 1, 1, 1 }) do
    click("x1", line)
  end
  for _, line in ipairs({ 10, 20, 30, 30, 30, 30 }) do
    click("x2", line)
  end
  click("x1", 20, true)
  click("x2", 30, true)
  request("nvim_command", "normal! v")
  click("x1", 20)

  --[[ Restored history can reference lines removed while Neovim was closed. ]]
  vim.fn.mkdir(root, "p")
  root = assert(vim.uv.fs_realpath(root))
  vim.fn.writefile(lines, root .. "/history.txt")
  vim.fn.writefile({ "other" }, root .. "/other.txt")
  request("nvim_set_option_value", "shada", "'100,<50,s10", {})
  request("nvim_command", "edit! " .. vim.fn.fnameescape(root .. "/history.txt"))
  request("nvim_command", "clearjumps")
  request("nvim_command", "normal! 10G")
  request("nvim_command", "normal! 30G")
  request("nvim_command", "edit " .. vim.fn.fnameescape(root .. "/other.txt"))
  request("nvim_command", "wshada! " .. vim.fn.fnameescape(root .. "/history.shada"))
  vim.fn.jobstop(child)

  vim.fn.writefile({ "shorter", "file" }, root .. "/history.txt")
  child = vim.fn.jobstart({ vim.v.progpath, "--embed", "-u", "NONE", "-i", "NONE" }, { rpc = true })
  assert(child > 0, "Could not restart Neovim")
  request("nvim_ui_attach", 80, 24, { rgb = true })
  request("nvim_exec_lua", 'dofile("lua/config/options.lua"); dofile("lua/config/keymaps.lua")', {})
  request("nvim_set_option_value", "shada", "'100,<50,s10", {})
  request("nvim_command", "rshada! " .. vim.fn.fnameescape(root .. "/history.shada"))
  request("nvim_command", "edit " .. vim.fn.fnameescape(root .. "/other.txt"))
  request("nvim_command", "redraw")
  click("x1", 1)
  assert(request("nvim_buf_get_name", 0) == root .. "/history.txt", "Did not reach valid older jump")
  click("x1", 1)
  click("x2", 1)
  assert(request("nvim_buf_get_name", 0) == root .. "/other.txt", "Did not reach valid newer jump")
  click("x2", 1)
  local messages = request("nvim_exec2", "messages", { output = true }).output
  assert(not messages:find("E19:", 1, true), "Stale jumps displayed an error: " .. messages)
end)

vim.fn.jobstop(child)
vim.fn.delete(root, "rf")
if not ok then
  error(err)
end
print("Mouse history regression checks passed")
