-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local function map(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, { desc = desc })
end

-- local Util = require("lazyvim.util")

if not vim.g.vscode then
  -- vim.keymap.set("n", "<leader>o", function()
  --   if vim.bo.filetype == "snacks-explorer" then
  --     vim.cmd.wincmd("p")
  --   else
  --     require("snacks").explorer.open()
  --   end
  -- end, { desc = "Focus Snacks Explorer" })

  -- ThePrimeagen harpoon keymaps
  local harpoon = require("harpoon")
  local zenmode = require("zen-mode")

  for i = 1, 5 do
    map(("<leader>%d"):format(i), function()
      harpoon:list():select(i)
    end, ("harpoon open file %d"):format(i))
  end
  map("<leader>ha", function()
    harpoon:list():add()
  end, "add current file")
  -- map("<leader>hr", harpoon.list():remove(), "remove current file")
  map("<leader>hu", function()
    harpoon.ui:toggle_quick_menu(harpoon:list())
  end, "toggle UI")
  map("<leader>hn", function()
    harpoon:list():next()
  end, "next file")
  map("<leader>hp", function()
    harpoon:list():prev()
  end, "previous file")

  map("<leader>z", function()
    zenmode.toggle({
      window = { width = 0.85 },
    })
  end, "Toggle zenmode")

  map("<leader>ba", function()
    Snacks.bufdelete.all()
  end, "Close all buffers")
end
