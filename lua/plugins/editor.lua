return {
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    opts = {
      defaults = { file_icons = false, git_icons = false },
      files = {
        fd_opts = [[--color=never --hidden --type f --type l --exclude .git --exclude .DS_Store]],
      },
    },
  },

  {
    "stevearc/oil.nvim",
    lazy = false,
    opts = {
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name) return name == ".DS_Store" end,
      },
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
    "akinsho/toggleterm.nvim",
    keys = {
      { "<leader>t", "<cmd>ToggleTerm<cr>", desc = "Terminal" },
      { "<C-\\>", "<cmd>ToggleTerm<cr>", mode = { "n", "t" }, desc = "Terminal" },
    },
    opts = {
      direction = "float",
      float_opts = { border = "rounded" },
    },
  },

  {
    "ethanholz/nvim-lastplace",
    config = true,
  },

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
    keys = {
      { "<leader>st", "<cmd>TodoFzfLua<cr>", desc = "Search todos" },
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Prev todo" },
    },
  },

  --[[ Sign-column display and helpers for native vim marks: ma sets mark a,
       'a jumps to it, dma deletes it, m] / m[ cycle marks in the buffer. ]]
  {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "<leader>sm", "<cmd>FzfLua marks<cr>", desc = "Search marks" },
      { "<leader>m", function() require("marks").toggle() end, desc = "Toggle mark on line" },
      { "<leader>M", function() require("marks").delete_buf() end, desc = "Delete all marks in buffer" },
    },
  },
}
