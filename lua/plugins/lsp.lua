return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      omnisharp = {}, -- C#
      lua_ls = {}, -- Lua
      clangd = {}, -- C/C++
      pyright = {}, -- Python
      ts_ls = {}, -- TypeScript/JavaScript
      html = {},
      cssls = {},
      glsl_analyzer = {},
      gdscript = {
        cmd = { "nc", "127.0.0.1", "6008" },
        root_dir = require("lspconfig.util").root_pattern("project.godot", ".git"),
        filetypes = { "gd", "gdscript", "gdscript3" },
      },
      rust_analyzer = {
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
            },
          },
        },
      },
    },
  },
}
