local config = vim.fn.getcwd()
local plugins = vim.fn.stdpath("data") .. "/lazy/"
vim.opt.rtp:prepend(config)
vim.opt.rtp:append(plugins .. "oil.nvim")
vim.opt.rtp:append(plugins .. "oil-git-status.nvim")

local root = vim.fn.tempname()

local function git(args)
  local result = vim.system(vim.list_extend({ "git" }, args), { text = true }):wait()
  assert(result.code == 0, result.stderr)
end

local function write(path, lines)
  vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
  vim.fn.writefile(lines or { "fixture" }, path)
end

local function check_directory(path, expected)
  require("oil").open(path, {}, function()
    require("oil-git-status").refresh_buffer(vim.api.nvim_get_current_buf())
  end)
  local observed = {}
  local ready = vim.wait(5000, function()
    local buf = vim.api.nvim_get_current_buf()
    observed = {}
    local marks = vim.api.nvim_buf_get_extmarks(buf, vim.api.nvim_create_namespace("oil-git-status"), 0, -1, {
      details = true,
    })
    for _, mark in ipairs(marks) do
      local entry = require("oil").get_entry_on_line(buf, mark[2] + 1)
      if entry then
        observed[entry.name] = observed[entry.name] or {}
        observed[entry.name][mark[4].priority == 2 and 1 or 2] = mark[4].sign_text:sub(1, 1)
      end
    end
    for name, status in pairs(expected) do
      if table.concat(observed[name] or {}) ~= status then
        return false
      end
    end
    return true
  end, 20)
  assert(ready, "Incorrect Oil signs in " .. path .. ": " .. vim.inspect(observed))
end

local ok, err = pcall(function()
  git({ "clone", "--quiet", "--shared", "--no-checkout", config, root })
  root = assert(vim.uv.fs_realpath(root))
  write(root .. "/.git/info/exclude", { ".turbo/", "node_modules/" })
  local accounts = root .. "/packages/accounts"
  write(accounts .. "/package.json")
  write(accounts .. "/tsconfig.json")
  write(accounts .. "/src/first.ts")
  write(accounts .. "/src/second.ts")
  write(accounts .. "/space dir/first.ts")
  write(accounts .. '/space dir/second"file.ts')
  write(accounts .. "/.turbo/cache")
  write(accounts .. "/node_modules/dependency/index.js")

  require("oil").setup({
    columns = {},
    win_options = { signcolumn = "yes:2" },
    view_options = { show_hidden = true },
  })
  if vim.env.OIL_GIT_WITHOUT_FIX ~= "1" then
    require("config.oil_git").setup()
  end
  require("oil-git-status").setup({})

  check_directory(accounts, {
    [".turbo"] = "!!",
    node_modules = "!!",
    src = "??",
    ["space dir"] = "??",
    ["package.json"] = "??",
    ["tsconfig.json"] = "??",
  })
  check_directory(accounts .. "/src", { ["first.ts"] = "??", ["second.ts"] = "??" })

  git({ "-C", root, "add", "packages/accounts/package.json" })
  write(accounts .. "/package.json", { "changed after staging" })
  check_directory(accounts, { ["package.json"] = "AM", src = "??", node_modules = "!!" })
end)

vim.fn.delete(root, "rf")
if not ok then
  error(err)
end
print("Oil Git status regression checks passed")
