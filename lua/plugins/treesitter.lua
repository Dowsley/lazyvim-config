return {
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
}
