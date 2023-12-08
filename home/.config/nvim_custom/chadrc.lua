local M = {}

M.ui = {
  theme = "nightfox",
  theme_toggle = {},

  hl_override = {
    CursorLine = {
      bg = "one_bg",
    },
  },
}

M.plugins = "custom.plugins"
M.mappings = require "custom.mappings"

return M
