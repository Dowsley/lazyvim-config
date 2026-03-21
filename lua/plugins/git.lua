return {
  -- Enable inline git blame by default
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
    },
  },

  -- Add fugitive for :Git blame side-by-side view
  { "tpope/vim-fugitive" },
}
