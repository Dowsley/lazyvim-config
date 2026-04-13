return {
  {
    "dstein64/nvim-scrollview",
    dependencies = { "lewis6991/gitsigns.nvim" },
    event = "BufReadPost",
    init = function()
      vim.g.scrollview_diagnostics_error_symbol = "▪"
      vim.g.scrollview_diagnostics_warn_symbol = "▪"
      vim.g.scrollview_diagnostics_info_symbol = "▪"
      vim.g.scrollview_diagnostics_hint_symbol = "▪"
    end,
    config = function()
      require("scrollview").setup({
        signs_on_startup = {
          "diagnostics",
          "search",
          "quickfix",
        },
        mousemoveevent = false,
      })
      require("scrollview.contrib.gitsigns").setup()
    end,
  },
}
