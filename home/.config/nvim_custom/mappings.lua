local M = {}

M.disabled = {
	n = {
		["<leader>ff"] = "",
		["<leader>rn"] = "",
		["<leader>w"] = "",
		["[d"] = "",
		["]d"] = "",
	},
	t = {
		["<C-x>"] = "",
	},
}

M.AOne = {
	n = {
		["<C-p>"] = { "<cmd> Telescope find_files hidden=true follow=true <CR>", "Telescope files" },
		["<C-f>"] = { "<cmd> Telescope live_grep hidden=true follow=true <CR>", "Telescope fuzzy find" },
		["<leader>w"] = { "<cmd> w <CR>", "Save file" },
		["g["] = { "<cmd> lua vim.diagnostic.goto_prev({float=false})<CR>", "Previous diagnostic" },
		["g]"] = { "<cmd> lua vim.diagnostic.goto_next({float=false})<CR>", "Next diagnostic" },
		["<leader>d"] = { "<cmd> w !diff % - <CR>", "Diff unsaved changes" },
		["gi"] = {
			function()
				vim.lsp.buf.incoming_calls()
			end,
			"Incoming calls",
		},
		["go"] = {
			function()
				vim.lsp.buf.outgoing_calls()
			end,
			"Outgoing calls",
		},
		["gs"] = {
			function()
				vim.lsp.buf.document_symbol()
			end,
			"Document symbols",
		},
		["gw"] = {
			function()
				require("telescope.builtin").lsp_dynamic_workspace_symbols()
			end,
			"Workspace symbols",
		},
		["gp"] = {
			function()
				require("telescope.builtin").registers()
			end,
			"Telescope registers",
		},
		["ge"] = {
			function()
				require("telescope.builtin").resume()
			end,
			"Telescope resume",
		},
		["<leader>ds"] = {
			function()
				require("neogen").generate()
			end,
			"Generate docstring",
		},
	},

	v = {

		["<leader>fm"] = {
			function()
				vim.lsp.buf.format({ async = true })
			end,
			"LSP formatting",
		},
	},

	t = {
		["<esc>"] = { vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true), "Escape terminal mode" },
	},
}

return M
