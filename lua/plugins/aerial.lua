return {
  {
    "stevearc/aerial.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<leader>cs", "<cmd>AerialToggle<cr>", desc = "Aerial (Symbols)" },
      { "<leader>cS", "<cmd>AerialNavToggle<cr>", desc = "Aerial Navigation" },
    },
    opts = {
      attach_mode = "global",
      backends = { "lsp", "treesitter", "markdown", "man" },
      layout = {
        min_width = 28,
        default_direction = "prefer_right",
      },
      show_guides = true,
      filter_kind = false,
      guides = {
        mid_item = "├ ",
        last_item = "└ ",
        nested_top = "│ ",
        whitespace = "  ",
      },
    },
  },
}
