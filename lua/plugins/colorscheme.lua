return {
  {
    "blazkowolf/gruber-darker.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local group = vim.api.nvim_create_augroup("GruberPropertyContrast", { clear = true })
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = group,
        pattern = "gruber-darker",
        callback = function()
          for _, name in ipairs({ "@property", "@variable.member" }) do
            vim.api.nvim_set_hl(0, name, { link = "GruberDarkerFg0" })
          end
        end,
      })
    end,
  },
  { "catppuccin/nvim", name = "catppuccin", lazy = true },
  { "folke/tokyonight.nvim", lazy = true },
  { "rebelot/kanagawa.nvim", lazy = true },
  { "ellisonleao/gruvbox.nvim", lazy = true },
  { "rose-pine/neovim", name = "rose-pine", lazy = true },
  { "EdenEast/nightfox.nvim", lazy = true },
  { "navarasu/onedark.nvim", lazy = true },
  { "Mofiqul/dracula.nvim", lazy = true },
  { "shaunsingh/nord.nvim", lazy = true },
  { "sainnhe/everforest", lazy = true },
  { "sainnhe/gruvbox-material", lazy = true },
  { "sainnhe/sonokai", lazy = true },
  { "projekt0n/github-nvim-theme", lazy = true },
  { "nyoom-engineering/oxocarbon.nvim", lazy = true, build = false },
  { "scottmckendry/cyberdream.nvim", lazy = true },
  { "bluz71/vim-moonfly-colors", lazy = true },
  { "WTFox/luna.nvim", lazy = true },
  { "kdheepak/monochrome.nvim", lazy = true },
  { "mellow-theme/mellow.nvim", lazy = true },
  { "datsfilipe/vesper.nvim", lazy = true },
  { "ficd0/ashen.nvim", lazy = true },
  { "nikolvs/vim-sunbather", lazy = true },
  { "vague-theme/vague.nvim", lazy = true },
}
