return {
  -- Add GLSL filetype detection
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "glsl" })
    end,
  },

  -- Configure LSP for GLSL
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        glsl_analyzer = {},
      },
    },
  },

  -- Auto-detect .vs and .fs files as GLSL
  {
    "LazyVim/LazyVim",
    opts = {
      -- Add filetype detection
    },
    init = function()
      vim.filetype.add({
        extension = {
          vs = "glsl",
          fs = "glsl",
          vert = "glsl",
          frag = "glsl",
          geom = "glsl",
          comp = "glsl",
          tesc = "glsl",
          tese = "glsl",
        },
      })
    end,
  },
}
