vim.opt.hidden = true
vim.opt.pumheight = 5
vim.opt.incsearch = true
vim.cmd("set whichwrap&")
vim.cmd("set shiftwidth=4")
vim.cmd("set tabstop=4")
vim.cmd("set noexpandtab")

local numbertogglegroup = vim.api.nvim_create_augroup("numbertoggle", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave" }, {
	pattern = "*",
	callback = function()
		vim.opt.relativenumber = true
		vim.api.nvim_set_hl(0, "MiniCursorWord", { underline = true })
		vim.api.nvim_set_hl(0, "MiniCursorWordCurrent", { underline = true })
	end,
	group = numbertogglegroup,
})
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter" }, {
	pattern = "*",
	callback = function()
		vim.opt.relativenumber = false
	end,
	group = numbertogglegroup,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		require("lint").try_lint()
	end,
})

vim.cmd("autocmd TermOpen * :DisableWhitespace")

vim.cmd("autocmd VimEnter * colorscheme nightfox")
