return {
  {
    "datsfilipe/vesper.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("vesper").setup({
        transparent = false,
        italics = {
          comments = false,
          keywords = false,
          functions = false,
          strings = false,
          variables = false,
          bufferline = false,
        },
        overrides = {
          CursorLine = { bg = "#1a1a1a" },
          CursorColumn = { bg = "#1a1a1a" },
          Visual = { bg = "#1a1a1a" },
          VisualNOS = { bg = "#1a1a1a" },
          PmenuSel = { bg = "#1a1a1a" },
          NormalFloat = { bg = "#101010" },
          FloatBorder = { bg = "#101010" },
          LspInlayHint = { fg = "#3a3a3a", bg = "NONE" },
        },
      })
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "vesper",
    },
  },
  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      opts.highlights = require("vesper").bufferline.highlights
    end,
  },
}
