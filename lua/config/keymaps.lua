local map = vim.keymap.set

-- more comfortable in my keyboards, learned from a trusted friend
for _, mode in ipairs({ "n", "x", "o" }) do
  map(mode, "j", "j", { desc = "Down" })
  map(mode, "k", "h", { desc = "Left" })
  map(mode, "l", "l", { desc = "Right" })
  map(mode, ";", "k", { desc = "Up" })
end

map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Insert mode returns to normal after saving, matching <cmd>w behaviour.
map({ "n", "x" }, "<C-s>", "<cmd>write<cr>", { desc = "Save" })
map("i", "<C-s>", "<Esc><cmd>write<cr>", { desc = "Save" })

map("n", "<leader>e", function() require("oil").toggle_float() end, { desc = "File explorer (oil)" })

map("n", "<leader><leader>", "<cmd>FzfLua files<cr>", { desc = "Find files" })
map("n", "<leader>,", "<cmd>FzfLua buffers<cr>", { desc = "Switch buffer" })
map("n", "<leader>/", "<cmd>FzfLua live_grep<cr>", { desc = "Search project (ripgrep)" })
map("n", "<leader>ss", "<cmd>FzfLua lsp_document_symbols<cr>", { desc = "Document symbols" })
map("n", "<leader>sS", "<cmd>FzfLua lsp_live_workspace_symbols<cr>", { desc = "Workspace symbols" })

--[[ Semantic usages of the symbol under the cursor, resolved by the language
     server so shadowed names and unrelated same-spelled words are excluded.
     Falls back to a word-boundary grep when nothing can answer, which is the
     case for GDScript unless the Godot editor is open. ]]
map("n", "<leader>su", function()
  local fzf = require("fzf-lua")
  if #vim.lsp.get_clients({ bufnr = 0, method = "textDocument/references" }) > 0 then
    fzf.lsp_references({
      includeDeclaration = false,
      ignore_current_line = true,
      --[[ Godot's source generator emits a partial class per script that
           mirrors every exported field. Those documents live only in the
           compiler's memory under a roslyn-source-generated:// URI, and each
           one doubles a field's hit count without pointing at editable code. ]]
      regex_filter = function(item)
        return not item.filename:match("^roslyn%-source%-generated:")
      end,
    })
  else
    vim.notify("No language server for this buffer, grepping instead", vim.log.levels.WARN)
    fzf.grep_cword()
  end
end, { desc = "Find usages (references)" })

map("n", "<Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Close buffer" })
