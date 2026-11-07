return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>pr", "<cmd>RenderMarkdown buf_toggle<cr>", desc = "Toggle Markdown rendering" },
    },
    opts = {},
  },
  {
    "selimacerbas/mdkite.nvim",
    dependencies = { "selimacerbas/kitehost.nvim" },
    cmd = { "MdKite" },
    keys = {
      { "<leader>pp", "<cmd>MdKite start<cr>", desc = "Markdown browser preview" },
      { "<leader>ps", "<cmd>MdKite stop<cr>", desc = "Stop Markdown preview" },
      { "<leader>pR", "<cmd>MdKite refresh<cr>", desc = "Refresh Markdown preview" },
    },
    opts = { default_theme = "dark", mermaid_elk = true },
    config = function(_, opts) require("mdkite").setup(opts) end,
  },
}
