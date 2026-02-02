-- Helper function to focus the OpenCode Snacks window
local function focus_opencode()
  vim.defer_fn(function()
    local ok, config = pcall(require, "opencode.config")
    if not ok then return end
    
    local provider = config.provider
    if provider then
      local win = provider:get()
      if win and win.valid and win:valid() then
        win:focus()
      end
    end
  end, 50)
end

return {
  {
    "NickvanDyke/opencode.nvim",
    dependencies = {
      -- Recommended for `ask()` and `select()`.
      -- Required for `snacks` provider.
      ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
      { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
    },
    config = function()
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition".
      }

      -- Required for `opts.events.reload`.
      vim.o.autoread = true
    end,
    keys = {
      {
        "<leader>oa",
        function()
          require("opencode").ask("@this: ", { submit = true })
          focus_opencode()
        end,
        desc = "Ask opencode",
        mode = { "n", "x" },
      },
      {
        "<leader>ob",
        function()
          require("opencode").prompt("@buffer")
          focus_opencode()
        end,
        desc = "Add buffer to opencode",
        mode = { "n" },
      },
      {
        "<leader>ox",
        function()
          require("opencode").select()
        end,
        desc = "Execute opencode action…",
        mode = { "n", "x" },
      },
      {
        "ga",
        function()
          require("opencode").prompt("@this")
          focus_opencode()
        end,
        desc = "Add to opencode",
        mode = { "n", "x" },
      },
      {
        "<leader>oo",
        function()
          -- Check if window exists before toggling (to determine if we're opening or closing)
          local provider = require("opencode.config").provider
          local win = provider and provider:get() or nil
          local was_visible = win and win.valid and win:valid()
          
          require("opencode").toggle()
          
          -- Only focus if we're opening (window wasn't visible before)
          if not was_visible then
            focus_opencode()
          end
        end,
        desc = "Toggle opencode",
        mode = { "n", "t" },
      },
      {
        "<leader>ou",
        function()
          require("opencode").command("session.half.page.up")
        end,
        desc = "opencode half page up",
      },
      {
        "<leader>od",
        function()
          require("opencode").command("session.half.page.down")
        end,
        desc = "opencode half page down",
      },
    },
  },
}
