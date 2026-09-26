--[[ Replay global ignores before the notes exception so other ignored files
     stay hidden. Project ignore files still take precedence. ]]
local search_args = { "--no-ignore-global" }
local global_ignore = vim.fn.systemlist({ "git", "config", "--path", "--get", "core.excludesFile" })[1]
if vim.v.shell_error ~= 0 then
  global_ignore = (vim.env.XDG_CONFIG_HOME or vim.fn.expand("~/.config")) .. "/git/ignore"
end
if global_ignore and vim.fn.filereadable(global_ignore) == 1 then
  vim.list_extend(search_args, { "--ignore-file", global_ignore })
end
vim.list_extend(search_args, { "--ignore-file", vim.fn.stdpath("config") .. "/search.ignore" })
local search_opts = table.concat(vim.tbl_map(vim.fn.shellescape, search_args), " ")

return {
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    opts = {
      defaults = { file_icons = false, git_icons = false },
      files = {
        cmd = [[rg --files --color=never --hidden -g '!.git' -g '!.DS_Store' ]] .. search_opts,
      },
      grep = {
        rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 "
          .. search_opts .. " -e",
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
    opts = function(_, opts)
      opts.search = opts.search or {}
      opts.search.args = vim.list_extend({
        "--color=never", "--no-heading", "--with-filename", "--line-number", "--column",
      }, search_args)
    end,
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
