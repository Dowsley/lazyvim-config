return {
  {
    "blazkowolf/gruber-darker.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      italic = {
        strings = false,
        comments = false,
        operators = false,
        folds = false,
      },
    },
    config = function(_, opts)
      require("gruber-darker").setup(opts)

      -- Realign the port with the original Emacs theme, which leans on quartz
      -- for types/preprocessor/constants and leaves literals at plain fg.
      local fg, quartz, green, brown = "#e4e4ef", "#95a99f", "#73c936", "#cc8c3c"
      local emacs_faithful = {
        ["@keyword.import"] = quartz,
        ["@keyword.directive"] = quartz,
        ["@keyword.directive.define"] = quartz,
        ["@preproc"] = quartz,
        ["@type"] = quartz,
        ["@type.qualifier"] = quartz,
        ["@constant"] = quartz,
        ["@type.builtin"] = quartz,
        ["@constant.builtin"] = quartz,
        ["@boolean"] = quartz,
        ["@number"] = fg,
        ["@number.float"] = fg,
        ["@punctuation.bracket"] = fg,
        ["@punctuation.delimiter"] = fg,
        ["@function"] = fg,
        ["@function.call"] = fg,
        ["@function.method"] = fg,
        ["@function.method.call"] = fg,
        ["@module"] = fg,
        ["@property"] = fg,
        ["@variable.member"] = fg,
      }

      -- The port transcribes two palette entries a shade off from the theme.
      local corrections = {
        [0x73d936] = tonumber(green:sub(2), 16),
        [0xe4e4e4] = tonumber(fg:sub(2), 16),
      }

      local function apply()
        for name, def in pairs(vim.api.nvim_get_hl(0, {})) do
          if not def.link and corrections[def.fg] then
            def.fg = corrections[def.fg]
            vim.api.nvim_set_hl(0, name, def)
          end
        end
        for group, color in pairs(emacs_faithful) do
          vim.api.nvim_set_hl(0, group, { fg = color })
        end
      end

      vim.api.nvim_create_autocmd("ColorScheme", { pattern = "gruber-darker", callback = apply })
      vim.cmd.colorscheme("gruber-darker")
      apply()
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
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>g", group = "git" },
        { "<leader>h", group = "hunks" },
        { "<leader>r", group = "rename" },
        { "<leader>s", group = "search" },
      },
    },
  },

  {
    "NeogitOrg/neogit",
    dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
    cmd = "Neogit",
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" },
    },
    opts = {},
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Git diff view" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      current_line_blame = true,
      on_attach = function(buf)
        local gs = require("gitsigns")
        local function map(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc })
        end
        map("<leader>hn", function() gs.nav_hunk("next") end, "Next hunk")
        map("<leader>hN", function() gs.nav_hunk("prev") end, "Prev hunk")
        map("<leader>hs", gs.stage_hunk, "Stage hunk")
        map("<leader>hr", gs.reset_hunk, "Reset hunk")
        map("<leader>hp", gs.preview_hunk, "Preview hunk")
        map("<leader>gb", function() gs.blame_line({ full = true }) end, "Blame line")
      end,
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "auto",
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
