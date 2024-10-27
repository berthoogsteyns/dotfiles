-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- local Util = require("lazyvim.util")

map("n", "<leader>o", function()
  if vim.bo.filetype == "neo-tree" then
    vim.cmd.wincmd("p")
  else
    vim.cmd.Neotree("focus")
  end
end, { desc = "Toggle neotree focus" })

-- ThePrimeagen harpoon keymaps
local harpoon = require("harpoon")
local zenmode = require("zen-mode")

map("n", "<leader><leader>a", function()
  harpoon:list():add()
end, { desc = "Toggle harpoon menu" })
map("n", "<leader><leader>e", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Toggle harpoon menu" })
map("n", "<leader><leader>1", function()
  harpoon:list():select(1)
end, { desc = "goto first harpoon" })
map("n", "<leader><leader>2", function()
  harpoon:list():select(2)
end, { desc = "goto second harpoon" })
map("n", "<leader><leader>3", function()
  harpoon:list():select(3)
end, { desc = "goto third harpoon" })
map("n", "<leader><leader>4", function()
  harpoon:list():select(4)
end, { desc = "goto fourth harpoon" })
map("n", "<leader>z", function()
  zenmode.toggle({
    window = { width = 0.85 },
  })
end, { desc = "Toggle zenmode" })
