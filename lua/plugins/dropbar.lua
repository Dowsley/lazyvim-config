return {
  {
    "Bekaboo/dropbar.nvim",
    event = "BufReadPost",
    opts = {},
    keys = {
      { "<leader>cb", function() require("dropbar.api").pick() end, desc = "Breadcrumb pick" },
    },
  },
}
