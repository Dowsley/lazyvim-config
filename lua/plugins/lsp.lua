return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      omnisharp = {},    -- C#
      lua_ls = {},       -- Lua
      clangd = {},       -- C/C++
      pyright = {},      -- Python
      ts_ls = {},        -- TypeScript/JavaScript
      rust_analyzer = {  -- Rust
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
