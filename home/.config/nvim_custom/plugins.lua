local plugins = {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"jose-elias-alvarez/null-ls.nvim",
				config = function()
					local null_ls = require("null-ls")

					local b = null_ls.builtins

					local sources = {
						b.formatting.stylua,
						b.formatting.clang_format,
						b.diagnostics.pylint,
						b.formatting.yapf.with({ extra_args = { "--style", os.getenv("HOME") .. "/.yapfrc" } }),
					}

					null_ls.setup({
						debounce = 150,
						debug = true,
						sources = sources,
					})
				end,
			},
		},
		config = function()
			local configs = require("plugins.configs.lspconfig")

			for _, server in ipairs(require("mason-lspconfig").get_installed_servers()) do
				require("lspconfig")[server].setup({
					on_attach = configs.on_attach,
					capabilities = configs.capabilities,
				})
			end
		end,
	},

	{
		"williamboman/mason.nvim",
		dependencies = {
			{
				"williamboman/mason-lspconfig.nvim",
				opts = {
					ensure_installed = {
						"pyright",
						"clangd",
						"lua_ls",
						"ocamllsp",
					},
				},
			},
		},
		opts = {
			ensure_installed = {
				"clang-format",
				"yapf",
				"stylua",
			},
		},
	},

	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			{ "p00f/nvim-ts-rainbow", lazy = false },
		},
		opts = {
			ensure_installed = { "c", "lua", "rust", "cpp", "python", "vim", "vimdoc" },
			sync_install = false,
			highlight = {
				enable = true,
				disable = { "rust" },
				additional_vim_regex_highlighting = false,
				use_languagetree = true,
			},
			indent = {
				enable = true,
				-- disable = { "python" },
			},
			rainbow = {
				enable = true,
			},
		},
	},

	{
		"telescope.nvim",
		dependencies = {
			"gbrlsnchs/telescope-lsp-handlers.nvim",
		},
		opts = function()
			local conf = require("plugins.configs.telescope")
			local custom = {
				file_ignore_patterns = { "/.git/", "^.git/", "^.clangd/", "/.clangd/", "^.cache/", "/.cache/" },
				pickers = {
					find_files = {
						hidden = true,
						follow = true,
					},
				},
				extensions = {
					lsp_handlers = {
						disable = {
							["textDocument/declaration"] = true,
							["textDocument/definition"] = true,
							["textDocument/implementation"] = true,
							["textDocument/typeDefinition"] = true,
							["textDocument/codeAction"] = true,
						},
					},
				},
			}

			vim.tbl_deep_extend("error", conf, custom)
			vim.list_extend(conf.extensions_list, { "lsp_handlers" })

			return conf
		end,
	},

	{
		"hrsh7th/nvim-cmp",
		opts = function()
			local cmp = require("cmp")
			local conf = require("plugins.configs.cmp")

			local custom = {
				window = {
					documentation = {
						max_height = 0,
					},
				},
				mapping = cmp.mapping.preset.insert({
					["<C-e>"] = cmp.mapping.abort(),
					["<Tab>"] = cmp.mapping.confirm({ select = true }),
					["<CR>"] = cmp.mapping.confirm({ select = false }),
				}),
				experimental = {
					ghost_text = true,
				},
			}

			vim.tbl_deep_extend("force", conf, custom)

			return conf
		end,
	},

	{
		"rust-lang/rust.vim",
		ft = "rust",
		init = function()
			vim.g.rustfmt_autosave = 1
		end,
	},

	{
		"simrat39/rust-tools.nvim",
		dependencies = "neovim/nvim-lspconfig",
		ft = "rust",
		config = function()
			local lspconf = require("plugins.configs.lspconfig")

			local conf = {
				tools = {
					inlay_hints = {
						show_parameter_hints = false,
						parameter_hints_prefix = "",
						other_hints_prefix = "type::",
					},
				},
				server = {
					on_attach = lspconf.on_attach,
					capabilities = lspconf.capabilities,
					settings = {
						["rust-analyzer"] = {
							checkOnSave = { command = "clippy" },
							diagnostics = { disabled = { "inactive-code" } },
						},
					},
				},
			}

			require("rust-tools").setup(conf)
		end,
	},

	{
		"chentoast/marks.nvim",
		lazy = false,
		opts = {
			default_mappings = false,
			signs = true,
			mappings = {},
		},
	},

	{
		"ntpeters/vim-better-whitespace",
		lazy = false,
	},

	{
		"tpope/vim-fugitive",
		cmd = "Git",
	},

	{
		"EdenEast/nightfox.nvim",
		lazy = false,
	},

	{
		"windwp/nvim-autopairs",
		enabled = false,
	},
}

return plugins
