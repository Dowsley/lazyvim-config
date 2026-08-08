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
      local fg, quartz, green = "#e4e4ef", "#95a99f", "#73c936"
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
}
