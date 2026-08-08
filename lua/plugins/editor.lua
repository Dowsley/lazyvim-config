return {
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    opts = {
      defaults = { file_icons = false, git_icons = false },
    },
  },

  {
    "stevearc/oil.nvim",
    lazy = false,
    opts = {
      view_options = { show_hidden = true },
      keymaps = {
        ["q"] = "actions.close",
        ["<Esc>"] = "actions.close",
        ["<BS>"] = "actions.parent",
      },
      float = {
        border = "rounded",
        max_width = 90,
        max_height = 30,
        padding = 4,
      },
    },
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    },
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },

  { "tpope/vim-sleuth" },

  {
    "ethanholz/nvim-lastplace",
    config = true,
  },
}
