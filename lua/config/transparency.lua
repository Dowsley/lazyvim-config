local M = {}
local enabled = true
local saved = {}
local groups = {
  "Normal", "NormalNC", "NormalSB", "NormalFloat", "FloatBorder",
  "SignColumn", "SignColumnSB", "EndOfBuffer", "LineNr", "CursorLineNr",
  "FoldColumn", "VertSplit", "WinSeparator", "WinBar", "WinBarNC",
}

local function apply()
  local transparent = {}
  --[[ Resolve links before changing any groups so linked highlights keep
       their foreground and styles when their backgrounds are cleared. ]]
  for _, name in ipairs(groups) do
    saved[name] = vim.api.nvim_get_hl(0, { name = name, link = true })
    local spec = vim.api.nvim_get_hl(0, { name = name, link = false })
    spec.bg = nil
    spec.ctermbg = nil
    transparent[name] = spec
  end
  for name, spec in pairs(transparent) do
    vim.api.nvim_set_hl(0, name, spec)
  end
end

function M.toggle()
  enabled = not enabled
  if enabled then
    apply()
  else
    for name, spec in pairs(saved) do
      vim.api.nvim_set_hl(0, name, spec)
    end
    saved = {}
  end
  vim.notify("Transparency " .. (enabled and "on" or "off"))
end

function M.setup()
  local group = vim.api.nvim_create_augroup("ThemeTransparency", { clear = true })
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = function()
      saved = {}
      if enabled then
        apply()
      end
    end,
  })
  if enabled then
    apply()
  end
end

return M
