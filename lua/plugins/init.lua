return {
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("onedark").setup({
        style = "dark",
        transparent = true,
      })
      require("onedark").load()
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ensure = {
        "tsx", "typescript", "javascript", "html", "css", "json",
        "lua", "rust", "python", "c", "cpp", "bash",
        "markdown", "markdown_inline", "gdscript", "glsl", "vim", "vimdoc", "query",
      }
      local installed = require("nvim-treesitter.config").get_installed()
      local to_install = vim.tbl_filter(function(p)
        return not vim.tbl_contains(installed, p)
      end, ensure)
      if #to_install > 0 then
        require("nvim-treesitter").install(to_install)
      end

      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },

  {
    "junegunn/fzf",
    build = function()
      vim.fn["fzf#install"]()
    end,
  },
  { "junegunn/fzf.vim", dependencies = { "junegunn/fzf" } },

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
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },
  { "tpope/vim-sleuth" },

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
    "ethanholz/nvim-lastplace",
    config = true,
  },

  {
    "NeogitOrg/neogit",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Neogit",
    opts = {},
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      current_line_blame = true,
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "onedark",
        globalstatus = true,
      },
    },
  },

  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        always_show_bufferline = false,
        separator_style = "thin",
        numbers = "ordinal",
        show_buffer_icons = false,
        show_buffer_close_icons = false,
        show_close_icon = false,
        diagnostics = "nvim_lsp",
        custom_filter = function(buf)
          return vim.bo[buf].filetype ~= "oil"
        end,
      },
    },
  },

  {
    "saghen/blink.cmp",
    version = "*",
    event = "InsertEnter",
    opts = {
      keymap = { preset = "default" },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      require("lsp")
    end,
  },
}
