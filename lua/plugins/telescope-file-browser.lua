return {
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    keys = {
      {
        "<leader>e",
        function()
          require("telescope").extensions.file_browser.file_browser({
            path = "%:p:h",
            select_buffer = true,
          })
        end,
        desc = "File Browser",
      },
    },
    config = function()
      require("telescope").setup({
        extensions = {
          file_browser = {
            hidden = true,
            grouped = true,
            hide_parent_dir = true,
          },
        },
      })
      require("telescope").load_extension("file_browser")
    end,
  },
}
