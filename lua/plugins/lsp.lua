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
      gdscript = {},
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
