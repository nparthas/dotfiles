local M = {}

M.ui = {
	theme = "nightfox",
	theme_toggle = {},

  statusline = {
    theme = "default",
    separator_style = "block",
    overriden_modules = nil,
  },


	hl_override = {
		CursorLine = {
			bg = "one_bg",
		},
	},
}

M.plugins = "custom.plugins"
M.mappings = require("custom.mappings")

return M
