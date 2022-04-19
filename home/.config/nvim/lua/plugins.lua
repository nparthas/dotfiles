local vim = vim
local execute = vim.api.nvim_command
local fn = vim.fn

-- ensure that packer is installed
local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
    execute 'packadd packer.nvim'
end

vim.cmd('packadd packer.nvim')

local packer = require'packer'
local util = require'packer.util'
packer.init({
  package_root = util.join_paths(vim.fn.stdpath('data'), 'site', 'pack')
})

--- startup and add configure plugins
packer.startup(function()
  local use = use

  -- checkout null-ls for other langs
  use 'wbthomason/packer.nvim'
  use 'neovim/nvim-lspconfig'
  use 'EdenEast/nightfox.nvim'
  use 'chentau/marks.nvim'
  use 'Mofiqul/vscode.nvim'
  use {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    tag = 'release'
  }
  use 'rust-lang/rust.vim'
  use 'simrat39/rust-tools.nvim'
  use {
    'amirali/yapf.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
  }

  end
)

vim.g.vscode_style = "dark"
vim.cmd[[colorscheme vscode]]

require('marks').setup {
    default_mappings = true,
    signs = true,
    mappings = {}
}

require('lspconfig').rust_analyzer.setup({})
require('rust-tools').setup({
    tools = {
        inlay_hints = {
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = "type::",
            highlight = "TSStructure",
        },
    },
    server = {
        settings = {
            ["rust-analyzer"] = {
                checkOnSave = { command = "clippy" },
                diagnostics = { disabled = { "inactive-code" } }
            }
        }
    },
})

require('gitsigns').setup()

require('lspconfig').pyright.setup{}
require('yapf').setup {
    style = os.getenv("HOME") .. '/.yapfrc',
}

