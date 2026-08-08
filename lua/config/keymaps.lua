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

map("n", "<Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Close buffer" })
