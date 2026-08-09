return {
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

  --[[ Winbar breadcrumbs. The path source resolves against the cwd, so the
       trail is only as meaningful as the directory nvim was started from. ]]
  {
    "Bekaboo/dropbar.nvim",
    event = "VeryLazy",
    opts = function()
      local sources = require("dropbar.sources")
      local utils = require("dropbar.utils")

      local SEPARATOR, PADDING = 1, 2

      local function width_of(symbols)
        local width = 0
        for _, symbol in ipairs(symbols) do
          width = width + symbol:displaywidth() + SEPARATOR
        end
        return width
      end

      --[[ Both ends of a path carry information: the leading directories name
           the package a file belongs to, the trailing ones place it inside
           that package. Only the middle is scaffolding every sibling shares,
           so it is the part that gives way, and only by as many segments as
           the window is short. `rest` is whatever follows the path on the bar,
           measured so the trail is fitted against the space actually left. ]]
      local function elide(source, rest, head, tail)
        return {
          get_symbols = function(buf, win, cursor)
            local symbols = source.get_symbols(buf, win, cursor)
            local budget = (vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_width(win) or vim.o.columns)
              - PADDING
              - width_of(rest.get_symbols(buf, win, cursor))
            local width = width_of(symbols)

            -- The ellipsis replaces the dropped run, so it is paid for once.
            local last = head
            while width > budget and last < #symbols - tail do
              if last == head then
                width = width + 1 + SEPARATOR
              end
              last = last + 1
              width = width - symbols[last]:displaywidth() - SEPARATOR
            end
            if last == head then
              return symbols
            end

            local kept = vim.list_slice(symbols, 1, head)
            symbols[last].name = "…"
            symbols[last].name_hl = "DropBarKindFolder"
            kept[#kept + 1] = symbols[last]
            return vim.list_extend(kept, symbols, last + 1)
          end,
        }
      end

      --[[ One separator is drawn between every pair of symbols, so a glyph
           that distinguishes directories from code has to travel with the
           symbols instead. Each carries its own leading mark and the bar
           separator shrinks to the space between them. ]]
      local function lead(source, mark, from)
        return {
          get_symbols = function(buf, win, cursor)
            local symbols = source.get_symbols(buf, win, cursor)
            for i = from, #symbols do
              symbols[i].icon = mark
              symbols[i].icon_hl = "DropBarIconUISeparator"
            end
            return symbols
          end,
        }
      end

      -- The first path symbol opens the trail, so nothing precedes it.
      local trail = lead(sources.path, "/ ", 2)
      local markdown = lead(sources.markdown, "› ", 1)
      local code = lead(utils.source.fallback({ sources.lsp, sources.treesitter }), "› ", 1)

      -- Marks are attached before fitting so their width is counted too.
      local path = elide(trail, code, 2, 2)
      local path_before_markdown = elide(trail, markdown, 2, 2)

      return {
        icons = {
          enable = false,
          ui = { bar = { separator = " " } },
        },
        --[[ Truncation shrinks every segment until the bar fits, which turns
             the whole path into initials. Eliding already bounds the width. ]]
        bar = {
          truncate = false,
          sources = function(buf, _)
            if vim.bo[buf].ft == "markdown" then
              return { path_before_markdown, markdown }
            end
            if vim.bo[buf].buftype == "terminal" then
              return { sources.terminal }
            end
            return { path, code }
          end,
        },
      }
    end,
    keys = {
      { "<leader>cb", function() require("dropbar.api").pick() end, desc = "Pick breadcrumb" },
    },
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
}
