-- Mason-managed servers. Two are deliberately absent: GDScript, whose server is
-- the running Godot editor over TCP, and C#, whose Roslyn server is installed
-- through mason but configured and started by roslyn.nvim.
local servers = {
  "lua_ls",
  "clangd",
  "pyright",
  "ts_ls",
  "html",
  "cssls",
  "rust_analyzer",
}

return {
  {
    "saghen/blink.cmp",
    version = "*",
    event = "InsertEnter",
    opts = {
      keymap = { preset = "default" },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = servers,
        automatic_enable = false,
      })

      vim.diagnostic.config({
        virtual_text = true,
        severity_sort = true,
      })

      vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })

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
          local function map(keys, fn, desc)
            vim.keymap.set("n", keys, fn, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          map("gd", "<cmd>FzfLua lsp_definitions<cr>", "Goto definition")
          map("gD", vim.lsp.buf.declaration, "Goto declaration")
          map("gi", "<cmd>FzfLua lsp_implementations<cr>", "Goto implementation")
          map("gr", "<cmd>FzfLua lsp_references<cr>", "References")
          map("K", vim.lsp.buf.hover, "Hover")
          map("<leader>rn", vim.lsp.buf.rename, "Rename")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("<leader>cf", function() vim.lsp.buf.format({ async = true }) end, "Format")
          map("[d", function() vim.diagnostic.jump({ count = -1 }) end, "Prev diagnostic")
          map("]d", function() vim.diagnostic.jump({ count = 1 }) end, "Next diagnostic")
          map("<leader>d", vim.diagnostic.open_float, "Line diagnostics")
        end,
      })

      vim.lsp.enable(servers)
      vim.lsp.enable("gdscript")
    end,
  },

  {
    "seblyng/roslyn.nvim",
    ft = "cs",
    dependencies = { "mason-org/mason.nvim" },
    opts = {},
    config = function(_, opts)
      --[[ The server is a mason package rather than an lspconfig server, so it
           is not covered by mason-lspconfig's ensure_installed. ]]
      local registry = require("mason-registry")
      local pkg = registry.get_package("roslyn-language-server")
      if not pkg:is_installed() then
        pkg:install()
      end
      require("roslyn").setup(opts)
    end,
  },
}
