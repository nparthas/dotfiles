vim.opt.hidden = true
vim.opt.pumheight = 5
vim.opt.incsearch = true
vim.cmd("set whichwrap&")

local numbertogglegroup = vim.api.nvim_create_augroup("numbertoggle", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave" }, {
	pattern = "*",
	callback = function()
		vim.opt.relativenumber = true
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

vim.cmd("autocmd TermOpen * :DisableWhitespace")

vim.cmd("autocmd VimEnter * colorscheme nightfox")
