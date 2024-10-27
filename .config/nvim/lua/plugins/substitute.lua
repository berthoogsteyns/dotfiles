return {
  "gbprod/substitute.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    -- TODO: find a good keybind
    -- local substitute = require("substitute")

    -- substitute.setup()

    -- set keymaps
    -- local keymap = vim.keymap -- for conciseness
    --
    -- keymap.set("n", "r", substitute.operator, { desc = "Substitute with motion" })
    -- keymap.set("n", "rr", substitute.line, { desc = "Substitute line" })
    -- keymap.set("n", "R", substitute.eol, { desc = "Substitute to end of line" })
    -- keymap.set("x", "r", substitute.visual, { desc = "Substitute in visual mode" })
  end,
}
