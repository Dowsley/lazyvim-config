local servers = {
  "lua_ls",
  "clangd",
  "pyright",
  "ts_ls",
  "html",
  "cssls",
  "rust_analyzer",
}

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = servers,
  automatic_enable = false,
})

vim.diagnostic.config({
  virtual_text = true,
  severity_sort = true,
})

local capabilities = require("blink.cmp").get_lsp_capabilities()
vim.lsp.config("*", { capabilities = capabilities })

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = { checkThirdParty = false },
    },
  },
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local buf = event.buf
    local map = function(keys, fn, desc)
      vim.keymap.set("n", keys, fn, { buffer = buf, desc = "LSP: " .. desc })
    end

    map("gd", "<cmd>FzfLua lsp_definitions<cr>", "Goto definition")
    map("gD", vim.lsp.buf.declaration, "Goto declaration")
    map("gi", "<cmd>FzfLua lsp_implementations<cr>", "Goto implementation")
    map("gr", "<cmd>FzfLua lsp_references<cr>", "References")
    map("K", vim.lsp.buf.hover, "Hover")
    map("<leader>rn", vim.lsp.buf.rename, "Rename")
    map("<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("<leader>cf", function()
      vim.lsp.buf.format({ async = true })
    end, "Format")
    map("[d", function() vim.diagnostic.jump({ count = -1 }) end, "Prev diagnostic")
    map("]d", function() vim.diagnostic.jump({ count = 1 }) end, "Next diagnostic")
    map("<leader>d", vim.diagnostic.open_float, "Line diagnostics")
  end,
})

vim.lsp.enable(servers)

-- GDScript's language server is provided by the running Godot editor over TCP
-- (127.0.0.1:6005), so it is not a Mason package and stays out of the list above.
-- lspconfig ships the config; enabling it connects whenever Godot is open.
vim.lsp.enable("gdscript")
